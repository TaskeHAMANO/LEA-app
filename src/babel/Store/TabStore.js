import RiotControl from 'riotcontrol'
import TabActionTypes from "Constant/TabActionTypes"

const store = new class TabStore{
  get tab(){
    return this._tab
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._tab = "search"

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(TabActionTypes.resetTabStore, this._setValue.bind(this));
    this.on(TabActionTypes.setTabStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._tab = storeAction(this._tab);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"tab_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
