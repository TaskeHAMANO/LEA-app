import TabStore   from "Store/TabStore"
import TabAction  from "Action/TabStoreAction"

<my-panel>
  <ul class="nav nav-tabs nav-justified">
    <li each={tab, i in tabs} class="{tab:true, active:parent.isActiveTab(tab)}" onclick={ parent.changeTab }>
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
    this.on("mount", () => {
      const tabAction = new TabAction();
      self.setStore = (tab) => {
        tabAction.setStore(tab);
      }
      tabAction.resetStore();

      TabStore.on(TabStore.ActionTypes.changed, () => {
        self.activeTab = TabStore.tab;
        self.update();
      })

      self.activeTab = TabStore.tab;
      self.update();
    })

    // データのパターン
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

    // 入力されているtabがactiveか判断してboolを返す
    self.isActiveTab =  function(tab){
      return self.activeTab === tab.type;
    }

    // 受け取った値をself.activeTabへ代入する
    self.changeTab = function(e){
      self.setStore(e.item.tab.type) ;
    };
  </script>

</my-panel>
