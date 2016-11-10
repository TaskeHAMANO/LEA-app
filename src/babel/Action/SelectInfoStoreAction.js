import RiotControl from "riotcontrol"
import SelectInfoActionTypes from "Constant/SelectInfoActionTypes"

class SelectInfoAction {
  setStore(select_info){
    RiotControl.trigger(SelectInfoActionTypes.setSelectInfoStore, (stored_select_info) => select_info)
  }
  resetStore(){
    RiotControl.trigger(SelectInfoActionTypes.resetSelectInfoStore, (stored_select_info) => {})
  }
}

export default SelectInfoAction
