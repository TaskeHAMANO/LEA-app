import RiotControl from 'riotcontrol'
import SelectInfoActionTypes from "Constant/SelectInfoActionTypes"

const store = new class SelectInfoStore{
  get select_info(){
    return this._select_info
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._select_info = {}

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(SelectInfoActionTypes.resetSelectInfoStore, this._setValue.bind(this));
    this.on(SelectInfoActionTypes.setSelectInfoStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._select_info = storeAction(this._select_info);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"select_info_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
