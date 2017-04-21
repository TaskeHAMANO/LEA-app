import RiotControl from "riotcontrol"
import MouseOnActionTypes from "Constant/MouseOnActionTypes"

class MouseOnAction {
  setStore(tab){
    RiotControl.trigger(MouseOnActionTypes.setMouseOnStore, (stored_tab) => tab)
  }
  resetStore(){
    RiotControl.trigger(MouseOnActionTypes.resetMouseOnStore, (stored_tab) => "")
  }
}

export default MouseOnAction
