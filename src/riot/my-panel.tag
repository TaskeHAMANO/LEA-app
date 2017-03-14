import TabStore   from "Store/TabStore"
import TabAction  from "Action/TabStoreAction"

<my-panel>
  <ul class="nav nav-tabs nav-justified">
    <li each={tab in tabs} class="{tab:true, active:parent.isActiveTab(tab)}" onclick="{parent.changeTab}">
      <a href="javascript:void(0)">{tab.label}</a>
    </li>
  </ul>

  <div class="content" if="{activeTab==="search"}">
    <my-search></my-search>
  </div>
  <div class="content" if="{activeTab==="info"}">
    <my-info></my-info>
  </div>
  <div class="content" if="{activeTab==="data"}">
    <my-data></my-data>
  </div>

  <style scoped>
    .content, my-search, my-info{
      height: calc(100% - 42px);
    }
  </style>

  <script>
    var self = this;
    const tabAction = new TabAction();

    //StoreにTabの状態を保存する関数
    self.setTabStore = (tab) => {
      tabAction.setStore(tab);
    }

    //Storeの状態を検知してコンポーネント変数を書き換える
    TabStore.on(TabStore.ActionTypes.changed, () => {
      self.activeTab = TabStore.tab;
      self.update();
    })

    //コンポーネント変数の初期化
    self.activeTab = TabStore.tab;
    self.update();

    // Tabのパターン
    self.tabs = [
      {
        type:"search",
        label:"Search"
      },
      {
        type:"info",
        label:"Information"
      },
      {
        type:"data",
        label:"Data"
      }
    ]

    // 入力されているtabがactiveか判断してboolを返すメソッド
    self.isActiveTab =  function(tab){
      return self.activeTab === tab.type;
    }

    // 受け取った値をself.activeTabへ代入するメソッド
    self.changeTab = function(e){
      self.setTabStore(e.item.tab.type) ;
    };
  </script>

</my-panel>
