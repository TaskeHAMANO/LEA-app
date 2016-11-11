import SelectInfoStore      from "Store/SelectInfoStore"

<my-info>
  <div class="container-fluid">
    <div if={!metadata}>
      <h3>Select sample or topic.</h3>
    </div>
    <div if={has_sample_id()} class="row-metadata">
      <div class="row">
        <div class="col-lg-12">
          <h3>Sample metadata</h3>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-12">
          <h4> Sample ID: </h4> {metadata.sample_id}
          <div if={ metadata.sample_name }>
            <h4> Sample Name: </h4> {metadata.sample_name}
          </div>
          <div if={ metadata.project_id }>
            <h4> Project ID: </h4> {metadata.project_id}
          </div>
        </div>
      </div>
      <div class="row" if={ metadata.sample_mdb_url && metadata.sample_ncbi_url }>
        <div class="col-lg-6">
          <h4> MicrobeDB.jp: </h4> <a href={metadata.sample_mdb_url}>Link</a>
        </div>
        <div class="col-lg-6">
          <h4> NCBI: </h4> <a href={metadata.sample_ncbi_url}>Link</a>
        </div>
      </div>
    </div>
    <div if={has_topic_id()} class="row-metadata">
      <div class="row">
        <div class="col-lg-12">
          <h3>Topic metadata</h3>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-12">
          <h4> Topic ID: </h4> {metadata.topic_id}
          <h6> License: </h6> {metadata.license}
          <h6> Attribution: </h6> {metadata.attribution}
          <h6> Source: </h6> <a href={metadata.image_url}>Link</a>
        </div>
      </div>
    </div>
    <div class="row row-chart">
      <div class="col-lg-6">
        <div id="taxon_chart" if={taxon_list}>
          <h3>Taxon</h3>
          <my-bar data={taxon_list} element_name={taxon_element_name} chart_id="taxon_bar_chart" color={taxon_color}></my-bar>
        </div>
      </div>
      <div class="col-lg-6">
        <div id="topic_chart" if={topic_list}>
          <h3>Topic</h3>
          <my-bar data={topic_list} element_name={topic_element_name} chart_id="topic_bar_chart" color={topic_color}></my-bar>
        </div>
        <div id="word_chart" if={word_list}>
          <h3>Word</h3>
          <ul class="list-group">
            <li each={word, i in word_list} class="list-group-item">{word.word}</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <style scoped>
    .container-extend {
      height:100%;
    }
  </style>

  <script>
    var self = this;
    fetch("http://localhost:5000/topic/location")
      .then((response) => response.json())
      .then((json) => {
        let color = json.topic_list.reduce((object, d, index) => {
          object[d.topic_id] = d.color
          return object
        }, {})
        self.topic_color = color ;
      })
    self.taxon_color = undefined ;

    self.has_project_id = () => self.metadata.hasOwnProperty("project_id")

    self.has_sample_id  = () => self.metadata.hasOwnProperty("sample_id")

    self.has_topic_id   = () => self.metadata.hasOwnProperty("topic_id")

    self.on("mount", ()=>{
      self.topic_element_name = "topic_id" ;
      self.taxon_element_name = "taxonomy_name" ;

      SelectInfoStore.on(SelectInfoStore.ActionTypes.changed, ()=>{
        self.metadata = {}
        self.metadata = SelectInfoStore.select_info;
        if(self.has_sample_id()){
          delete self.word_list ;
          if(self.has_project_id()){
            d3.queue()
              .defer(d3.json, `http://localhost:5000/newsample/${self.metadata.project_id}/${self.metadata.sample_id}/taxonomies/genus`)
              .defer(d3.json, `http://localhost:5000/newsample/${self.metadata.project_id}/${self.metadata.sample_id}/topics`)
              .await((error, taxon, topics) => {
                if (error) throw error

                let taxon_list = {}
                taxon_list[self.metadata.sample_id] = taxon.taxonomy_list ;
                self.taxon_list = taxon_list ;

                let topic_list = {}
                topic_list[self.metadata.sample_id] = topics.topic_list ;
                self.topic_list = topic_list ;

                self.update()
              })
            ;
          }else{
            d3.queue()
              .defer(d3.json, `http://localhost:5000/sample/${self.metadata.sample_id}/metadata`)
              .defer(d3.json, `http://localhost:5000/sample/${self.metadata.sample_id}/taxonomies/genus`)
              .defer(d3.json, `http://localhost:5000/sample/${self.metadata.sample_id}/topics`)
              .await((error, metadata, taxon, topics) => {
                if (error) throw error

                self.metadata["sample_name"] = metadata.metadata.SampleName;
                self.metadata["sample_ncbi_url"] = `http://ncbi.nlm.nih.gov/sra/${self.metadata.sample_id}`;
                self.metadata["sample_mdb_url"] = `http://biointegra.jp/MDBdemo/search/?q1=${self.metadata.sample_id}&q1_cat=sample&q1_param_srs_id=${self.metadata.sample_id}` ;

                let taxon_list = {}
                taxon_list[self.metadata.sample_id] = taxon.taxonomy_list ;
                self.taxon_list = taxon_list ;

                let topic_list = {}
                topic_list[self.metadata.sample_id] = topics.topic_list ;
                self.topic_list = topic_list ;

                self.update();
              })
            ;
          }
        }else if(self.has_topic_id()){
          delete self.topic_list ;
          d3.queue()
            .defer(d3.json, `http://localhost:5000/topic/${self.metadata.topic_id}/metadata`)
            .defer(d3.json, `http://localhost:5000/topic/taxonomies/${self.metadata.topic_id}`)
            .defer(d3.json, `http://localhost:5000/topic/words/${self.metadata.topic_id}`)
            .await((error, metadata, taxon, words) => {
              if (error) throw error

              self.metadata["attribution"] = metadata.metadata.Attribution ;
              self.metadata["image_url"] = metadata.metadata.ImageURL ;
              self.metadata["license"] = metadata.metadata.License ;

              let taxon_list = {}
              taxon_list[''+self.metadata.topic_id] = taxon.taxonomy_list ;
              self.taxon_list = taxon_list ;

              self.word_list = words.word_list.slice(0,5) ;

              self.update();
            })
          ;
        }
      });
    });
  </script>
</my-info>
