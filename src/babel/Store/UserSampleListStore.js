import RiotControl from 'riotcontrol'
import UserSampleListActionTypes from "Constant/UserSampleListActionTypes"

const store = new class UserSampleListStore{
  get user_sample_list(){
    return this._user_sample_list
  }

  constructor(){
    riot.observable(this);

    // インスタンス変数の初期値を設定　
    this._user_sample_list = []

    // actiontypeが与えられると、後ろの関数が実行される
    this.on(UserSampleListActionTypes.resetUserSampleListStore, this._setValue.bind(this));
    this.on(UserSampleListActionTypes.setUserSampleListStore, this._setValue.bind(this));
    this.on(UserSampleListActionTypes.appendUserSampleListStore, this._setValue.bind(this));
    this.on(UserSampleListActionTypes.removeUserSampleListStore, this._setValue.bind(this));
  }

  _setValue(storeAction){
    this._user_sample_list = storeAction(this._sample_list);
    RiotControl.trigger(this.ActionTypes.changed);
  }
}();

// オブジェクト変数の初期化
store.ActionTypes = {changed:"user_sample_list_store_changed"}

// RiotControlに代入
RiotControl.addStore(store);

export default store
