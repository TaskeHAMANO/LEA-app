import SampleListStore from "Store/SampleListStore"
import SampleListAction from "Action/SampleListStoreAction"

<my-search>
  <div class="container-fluid">
    <div class="row">
      <div class="well">
        <form onsubmit='{submit}'>
          <div class="form-group">
            <h5>Search samples by text input</h3>
            <input type="text" name="searched_text" class="form-control">
          </div>
          <button type="reset" name="reset" class="btn btn-default" onclick='{reset}'>Reset</button>
          <button type="submit" name="submit" class="btn btn-primary">Search</button>
        </form>
      </div>
    </div>
    <div class="menu row">
      <div class="col-lg-12">
        <div each={sem_topic, i in sem_topic_list} class="menu-category list-group">
          <div class="menu-category-name list-group-item active"><h6> Semantic meaning of current status </h4></div>
          <a each={word_value, j in sem_topic.word} href="javascript:void(0)" class="menu-item list-group-item" onclick='{click_word}'>{word_value.word}<span class="badge">{word_value.value}</span></a>
        </div>
      </div>
    </div>
    <div class="menu row">
      <div class="col-lg-12">
        <div each={eco_topic, i in eco_topic_list} class="menu-category list-group">
          <div class="menu-category-name list-group-item active"><h6> Ecologically co-occurrence word </h4></div>
          <a each={word_value, j in eco_topic.word} href="javascript:void(0)" class="menu-item list-group-item" onclick='{click_word}'>{word_value.word}<span class="badge">{word_value.value}</span></a>
        </div>
      </div>
    </div>
  </div>

  <script>
    var self = this ;
    this.on("mount", ()=>{
      const sampleListAction = new SampleListAction();

      self.setStore = (sample_list) => {
        sampleListAction.setStore(sample_list);
      }
      self.resetStore = () => {
        sampleListAction.resetStore();
      }
      sampleListAction.resetStore();
    })

    this.click_word = function(e){
      let word = e.item.word_value.word ;
      self.searched_text.value += ` ${word}`;
      self.update();
    }

    this.reset = function(){
      this.searched_text.value = "" ;
      this.eco_topic_list = [] ;
      this.sem_topic_list = [] ;
      self.resetStore() ;
    }


    this.submit = function(){
      let content_height = d3.select(".content").node().getBoundingClientRect().height
      let well_height = d3.select(".well").node().getBoundingClientRect().height 
      let row_size = parseInt((((content_height - well_height)/42) - 3 )/2)
      console.log(row_size);
      if(this.searched_text.value.length !== 0){
        fetch(`http://localhost:5000/string/${encodeURIComponent(this.searched_text.value)}/samples?n_limit=2000`)
          .then((response) => response.json())
          .then((json) => {
            self.setStore(json.sample_list)
          })
        fetch(`http://localhost:5000/string/${encodeURIComponent(this.searched_text.value)}/topics/ecological?n_element_limit=${row_size}`)
          .then((response) => response.json())
          .then((json) => {
            self.eco_topic_list = json.topic_list;
            self.update();
          })
        fetch(`http://localhost:5000/string/${encodeURIComponent(this.searched_text.value)}/topics/semantic?n_element_limit=${row_size}`)
          .then((response) => response.json())
          .then((json) => {
            self.sem_topic_list = json.topic_list;
            self.update();
          })
      }else{
        self.reset();
      }
    }
  </script>
</my-search>
