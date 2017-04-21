import SampleListStore from "Store/SampleListStore"
import SampleListAction from "Action/SampleListStoreAction"

<my-search>
  <div class="container-fluid">
    <div class="row">
      <div class="well">
        <form onsubmit='{submit}'>
          <div class="form-group">
            <label><h3>Search</h3></label>
            <input type="text" name="searched_text" class="form-control">
          </div>
          <button type="submit" name="submit" class="btn btn-primary">Search</button>
          <button type="reset" name="reset" class="btn btn-default" onclick='{reset}'>Reset</button>
        </form>
      </div>
    </div>
    <div class="menu row">
      <div class="col-xs-6 col-lg-12" if={message}>
        <h5>{message}</h5>
      </div>
      <div class="col-xs-6 col-lg-12" if={sem_topic_list}>
        <div each="{sem_topic in sem_topic_list}" class="menu-category list-group">
          <div class="menu-category-name list-group-item active">
            <h4> Semantic meaning of current status </h4>
          </div>
          <a each="{word_value in sem_topic.word}" href="javascript:void(0)" class="menu-item list-group-item" onclick='{click_word}'>
            {word_value.word}
            <span class="badge">{word_value.value}</span>
          </a>
        </div>
      </div>
      <div class="col-xs-6 col-lg-12" if={eco_topic_list}>
        <div each="{eco_topic in eco_topic_list}" class="menu-category list-group">
          <div class="menu-category-name list-group-item active">
            <h4> Ecologically co-occurrence word </h4>
          </div>
          <a each="{word_value in eco_topic.word}" href="javascript:void(0)" class="menu-item list-group-item" onclick='{click_word}'>
            {word_value.word}
            <span class="badge">{word_value.value}</span>
          </a>
        </div>
      </div>
    </div>
  </div>

  <style scoped>
    .menu {
      overflow:scroll ;
      height:calc(100vh - 42px - 230px) ;
    }
  </style>

  <script>
    var self = this ;
    self.on("mount", ()=>{
      //To avoid mystery bug, focus out form
      d3.select(".form-control")
        .on("mouseout", () => {
          document.getElementsByClassName("form-control")[0].blur() ;
        })
      ;
    })

    const sampleListAction = new SampleListAction();
    self.setSampleListStore = (sample_list) => {
      sampleListAction.setStore(sample_list);
    }
    self.resetSampleListStore = () => {
      sampleListAction.resetStore();
    }

    self.click_word = function(e){
      let word = e.item.word_value.word ;
      self.searched_text.value += ` ${word}`;
      self.update();
    }

    self.reset = function(){
      self.searched_text.value = "" ;
      delete self.eco_topic_list ;
      delete self.sem_topic_list ;
      delete self.message ;
      self.resetSampleListStore() ;
      d3.select(".d3-map")
        .selectAll(".selected_dot")
          .classed(".selected_dot", false)
          .attr("stroke", "none") ;
      d3.select(".d3-map")
        .selectAll(".selected_topic")
          .classed(".selected_topic", false)
          .select("circle")
            .attr("stroke", "none") ;
    }

    self.submit = function(){
      self.message = "Loading..."
      self.update();

      if(self.searched_text.value){
        d3.queue()
          .defer(d3.json, `http://snail.nig.ac.jp/leaapi/string/${encodeURIComponent(self.searched_text.value)}/samples?n_limit=2000`)
          .defer(d3.json, `http://snail.nig.ac.jp/leaapi/string/${encodeURIComponent(self.searched_text.value)}/topics/ecological?n_element_limit=6`)
          .defer(d3.json, `http://snail.nig.ac.jp/leaapi/string/${encodeURIComponent(self.searched_text.value)}/topics/semantic?n_element_limit=6`)
          .awaitAll((error, result) => {
            if (error){
              self.message = `Error: ${error.target.statusText}` ;
              self.update()
              throw error ;
            };

            let sample_list = result[0];
            let eco_topics = result[1];
            let sem_topics = result[2];

            if(sample_list.sample_list.length != 0){
              self.setSampleListStore(sample_list.sample_list) ;
              self.eco_topic_list = eco_topics.topic_list ;
              self.sem_topic_list = sem_topics.topic_list ;
              self.message = "Success." ;
            }else{
              self.message = "No result." ;
            }
            self.update() ;
          })
        ;
      }else{
        self.reset();
      }
    }
  </script>
</my-search>
