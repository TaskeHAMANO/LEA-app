import RiotControl from "riotcontrol"
import SampleIDActionTypes from "Constant/SampleIDActionTypes"

class SampleIDAction {
  setStore(sample_id){
    RiotControl.trigger(SampleIDActionTypes.setSampleIDStore, (stored_sample_id) => sample_id)
  }
  resetStore(){
    RiotControl.trigger(SampleIDActionTypes.resetSampleIDStore, (stored_sample_id) => "")
  }
}

export default SampleIDAction
