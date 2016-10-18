import RiotControl from 'riotcontrol'
import SampleTopicActionTypes from "Constant/SampleTopicActionTypes"

const store = new class SampleTopicStore{
  get topic_data(){
    return this._topic_data
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._topic_data = []

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(SampleTopicActionTypes.resetSampleTopicStore, this._setValue.bind(this));
    this.on(SampleTopicActionTypes.setSampleTopicStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._topic_data = storeAction(this._topic_data);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {
  changed:"sample_topic_store_changed"
}

// RiotControlに代入
RiotControl.addStore(store);

export default store
