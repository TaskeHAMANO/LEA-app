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

  <style scoped>
    .content {
      height:100%;
    }
  </style>

  <script>
    var self = this;
    // データのパターン
    self.tabs = [
      {
        type:"search",
        label:"Search"
      },
      {
        type:"info",
        label:"Information"
      }
    ]
    // 初期値をsearchで保存する
    self.activeTab = "search"

    // 入力されているtabがactiveか判断してboolを返す
    self.isActiveTab =  function(tab){
      return self.activeTab === tab.type;
    }

    // 受け取った値をself.activeTabへ代入する
    self.changeTab = function(e){
      self.activeTab = e.item.tab.type;
    };
  </script>

</my-panel>