import SampleIDStore from "Store/SampleIDStore"
import SampleTopicAction from "Action/SampleTopicStoreAction"

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
        <div id="taxon_chart" if={taxon_list}><my-bar data={taxon_list}></my-bar></div>
      </div>
      <div class="col-lg-6">
        <div id="topic_chart"><my-bar></my-bar></div>
      </div>
    </div>
  </div>

  <style scoped>
    .container-extend {
      height:100%;
    }
    .row-metadata {
      height:30%;
    }
    .row-chart {
      height:70%;
    }
  </style>
  <script>
    this.on("mount", ()=>{
      var self = this;
      const sampleTopicAction = new SampleTopicAction();
      self.setStore = (topic_data) => {
        sampleTopicAction.setStore(topic_data)
      }
      sampleTopicAction.resetStore();

      // Dispatcherから発火が伝えられたら動作開始
      SampleIDStore.on(SampleIDStore.ActionTypes.changed, ()=>{
        self.sample_id = SampleIDStore.sample_id;
        fetch(`http://localhost:5000/sample/${this.sample_id}/metadata`)
          .then((response) =>response.json())
          .then((json)=>{
            self.sample_name = json.metadata.SampleName;
            self.sample_url = json.metadata.SampleURL;
            self.update()
          });
        fetch(`http://localhost:5000/sample/${this.sample_id}/topics`)
          .then((response)=>response.json())
          .then((json)=>{
            let topic_list = {}
            topic_list[self.sample_id] = json.topic_list ;
            self.setStore(topic_list)
            self.update({topic_list: topic_list})
          })
      });
    });
  </script>

</my-info>
