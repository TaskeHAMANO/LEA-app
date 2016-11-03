import SampleIDStore      from "Store/SampleIDStore"

<my-info>
  <div class="container-fluid">
    <div class="row row-metadata">
      <div class="col-lg-12">
        <div if={metadata}>
          <h3>Metadata</h3>
          <h4> Sample ID:</h4> {metadata.sample_id}
          <h4> Sample Name:</h4> {metadata.sample_name}
          <h4> NCBI:</h4> <a href={metadata.sample_url}>Link</a>
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

    this.on("mount", ()=>{
      self.topic_element_name = "topic_id" ;
      self.taxon_element_name = "taxonomy_name" ;

      SampleIDStore.on(SampleIDStore.ActionTypes.changed, ()=>{
        self.metadata = {}
        self.metadata["sample_id"] = SampleIDStore.sample_id;
        d3.queue()
          .defer(d3.json, `http://localhost:5000/sample/${this.metadata.sample_id}/metadata`)
          .defer(d3.json, `http://localhost:5000/sample/${this.metadata.sample_id}/taxonomies/genus`)
          .defer(d3.json, `http://localhost:5000/sample/${this.metadata.sample_id}/topics`)
          .await((error, metadata, taxon, topics) => {
            if (error) throw error
            self.metadata["sample_name"] = metadata.metadata.SampleName;
            self.metadata["sample_url"] = metadata.metadata.SampleURL;
            let taxon_list = {}
            taxon_list[self.metadata.sample_id] = taxon.taxonomy_list ;
            self.taxon_list = taxon_list ;
            let topic_list = {}
            topic_list[self.metadata.sample_id] = topics.topic_list ;
            self.topic_list = topic_list ;
            self.update();
          })
      });
    });
  </script>

</my-info>
