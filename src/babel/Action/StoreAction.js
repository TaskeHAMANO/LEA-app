import RiotControl from "riotcontrol"
import SampleActionTypes from "Constant/SampleActionTypes"

class SampleAction {
  setStore(sample_id){
    RiotControl.trigger(SampleActionTypes.setSampleStore, (stored_sample_id) => sample_id
    )
  }
  resetStore(){
    RiotControl.trigger(SampleActionTypes.resetSampleStore, (stored_sample_id) => "")
  }
}

export default SampleAction
