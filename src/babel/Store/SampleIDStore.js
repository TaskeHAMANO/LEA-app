import RiotControl from 'riotcontrol'
import SampleIDActionTypes from "Constant/SampleIDActionTypes"

const store = new class SampleIDStore{
  get sample_id(){
    return this._sample_id
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._sample_id = ""

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(SampleIDActionTypes.resetSampleIDStore, this._setValue.bind(this));
    this.on(SampleIDActionTypes.setSampleIDStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._sample_id = storeAction(this._sample_id);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"sample_id_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
