import RiotControl from "riotcontrol"
import SampleAction from "Action/StoreAction"
import SampleStore from "Store/SampleStore"

<my-info>
  <p if={sample_id}>Sample ID:{sample_id}</p>
  <script>
    this.on("mount", ()=>{
      const action = new SampleAction();

      // Dispatcherから発火が伝えられたら動作開始
      RiotControl.on(SampleStore.ActionTypes.changed, ()=>{
        this.sample_id = sample_id;
        this.update()
      });
    });
  </script>

</my-info>
