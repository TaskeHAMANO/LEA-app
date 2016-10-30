import SampleIDStore      from "Store/SampleIDStore"

<my-info>
  <div class="container-fluid">
    <div class="row row-metadata">
      <div class="col-lg-12">
        <p if={sample_id}>Sample ID: {sample_id}</p>
        <p if={sample_name}>Sample Name: {sample_name}</p>
        <p if={sample_url}><a href={sample_url}>Link for NCBI</a>
      </div>
    </div>
    <div class="row row-chart">
      <div class="col-lg-6">
        <div id="taxon_chart" if={taxon_list}>
          <my-bar data={taxon_list} element_name={taxon_element_name} chart_id="taxon_bar_chart"></my-bar>
        </div>
      </div>
      <div class="col-lg-6">
        <div id="topic_chart" if={topic_list}>
          <my-bar data={topic_list} element_name={topic_element_name} chart_id="topic_bar_chart"></my-bar>
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
    this.on("mount", ()=>{
      self.topic_element_name = "topic_id" ;
      self.taxon_element_name = "taxonomy_name" ;

      // SampleIDの変更が伝えられたら動作開始
      SampleIDStore.on(SampleIDStore.ActionTypes.changed, ()=>{
        self.sample_id = SampleIDStore.sample_id;
        fetch(`http://localhost:5000/sample/${this.sample_id}/metadata`)
          .then((response) =>response.json())
          .then((json)=>{
            self.sample_name = json.metadata.SampleName;
            self.sample_url = json.metadata.SampleURL;
            self.update()
          });
        fetch(`http://localhost:5000/sample/${this.sample_id}/taxonomies/genus`)
          .then((response)=>response.json())
          .then((json)=>{
            let taxon_list = {}
            taxon_list[self.sample_id] = json.taxonomy_list ;
            self.taxon_list = taxon_list ;
            self.update();
          })
        fetch(`http://localhost:5000/sample/${this.sample_id}/topics`)
          .then((response)=>response.json())
          .then((json)=>{
            let topic_list = {}
            topic_list[self.sample_id] = json.topic_list ;
            self.topic_list = topic_list ;
            self.update();
          })
      });

    });
  </script>

</my-info>
