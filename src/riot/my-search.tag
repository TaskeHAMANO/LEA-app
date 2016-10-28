import SampleListStore from "Store/SampleListStore"
import SampleListAction from "Action/SampleListStoreAction"

<my-search>
  <div class="well">
    <form onsubmit='{submit}'>
      <div class="form-group">
        <p>Search samples by text input</p>
        <input type="text" name="searched_text" class="form-control">
      </div>
      <button type="reset" name="reset" class="btn btn-default" onclick='{reset}'>Reset</button>
      <button type="submit" name="submit" class="btn btn-primary">Search</button>
    </form>
  </div>

  <script>
    var self = this
    this.on("mount", ()=>{
      const sampleListAction = new SampleListAction();

      self.setStore = (sample_list) => {
        sampleListAction.setStore(sample_list);
      }
      self.resetStore = () => {
        sampleListAction.resetStore();
      }
      sampleListAction.resetStore();
    })

    this.reset = function(){
      this.searched_text.value = "" ;
      self.resetStore();
    }

    this.submit = function(){
      if(this.searched_text.value.length !== 0){
        fetch(`http://localhost:5000/string/${encodeURIComponent(this.searched_text.value)}/samples?n_limit=500`)
          .then((response) => response.json())
          .then((json) => {
            self.setStore(json.sample_list)
          })
      }else{
        self.resetStore();
      }
    }
  </script>
</my-search>
