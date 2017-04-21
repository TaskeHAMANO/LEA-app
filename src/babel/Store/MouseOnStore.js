import RiotControl from 'riotcontrol'
import MouseOnActionTypes from "Constant/MouseOnActionTypes"

const store = new class MouseOnStore{
  get mouseon(){
    return this._mouseon
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._mouseon= ""

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(MouseOnActionTypes.resetMouseOnStore, this._setValue.bind(this));
    this.on(MouseOnActionTypes.setMouseOnStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._mouseon = storeAction(this._mouseon);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"mouseon_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
