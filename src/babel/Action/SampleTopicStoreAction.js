import RiotControl from "riotcontrol"
import SampleTopicActionTypes from "Constant/SampleTopicActionTypes"

class SampleTopicAction {
  setStore(topic_data){
    RiotControl.trigger(SampleTopicActionTypes.setSampleTopicStore, (stored_topic_data) => topic_data)
  }
  resetStore(){
    RiotControl.trigger(SampleTopicActionTypes.resetSampleTopicStore, (stored_sample_id) => [])
  }
}

export default SampleTopicAction
