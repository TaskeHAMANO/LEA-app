import RiotControl from "riotcontrol"
import TabActionTypes from "Constant/TabActionTypes"

class TabAction {
  setStore(tab){
    RiotControl.trigger(TabActionTypes.setTabStore, (stored_tab) => tab)
  }
  resetStore(){
    RiotControl.trigger(TabActionTypes.resetTabStore, (stored_tab) => "search")
  }
}

export default TabAction
