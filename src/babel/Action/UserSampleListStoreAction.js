import RiotControl from "riotcontrol"
import UserSampleListActionTypes from "Constant/UserSampleListActionTypes"

class UserSampleListAction {
  setStore(sample_list){
    RiotControl.trigger(UserSampleListActionTypes.setUserSampleListStore, (stored_sample_list) => sample_list)
  }
  resetStore(){
    RiotControl.trigger(UserSampleListActionTypes.resetUserSampleListStore, (stored_sample_list) => [])
  }
  appendStore(sample_info){
    RiotControl.trigger(UserSampleListActionTypes.appendUserSampleListStore, (stored_sample_list) => stored_sample_list.push(sample_info))
  }
  appendStore(sample_info){
    RiotControl.trigger(UserSampleListActionTypes.removeUserSampleListStore, (stored_sample_list) => {
      let index = stored_sample_list.splice(sample_info)
      return stored_sample_list.splice(index, 1)
    })
  }
}

export default UserSampleListAction
