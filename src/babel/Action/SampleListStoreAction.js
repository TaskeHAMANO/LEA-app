import RiotControl from "riotcontrol"
import SampleListActionTypes from "Constant/SampleListActionTypes"

class SampleListAction {
  setStore(sample_list){
    RiotControl.trigger(SampleListActionTypes.setSampleListStore, (stored_sample_list) => sample_list)
  }
  resetStore(){
    RiotControl.trigger(SampleListActionTypes.resetSampleListStore, (stored_sample_list) => [])
  }
}

export default SampleListAction

