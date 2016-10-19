import RiotControl from 'riotcontrol'
import SampleListActionTypes from "Constant/SampleListActionTypes"

const store = new class SampleListStore{
  get sample_list(){
    return this._sample_list
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._sample_list = []

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(SampleListActionTypes.resetSampleListStore, this._setValue.bind(this));
    this.on(SampleListActionTypes.setSampleListStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._sample_list = storeAction(this._sample_list);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"sample_list_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
