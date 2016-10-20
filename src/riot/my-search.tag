import SampleListStore from "Store/SampleListStore"
import SampleListAction from "Action/SampleListStoreAction"

<my-search>
  <div class="container-fluid">
    <div class="row">
      <form onsubmit='{submit}'>
        <div class="col-lg-7">
            <input type="text" name="searched_text">
        </div>
        <div class="col-lg-2">
            <button type="reset" name="reset" >Reset</button>
        </div>
        <div class="col-lg-2">
            <button type="submit" name="submit" disabled={ !searched_text }>Search</button>
        </div>
        <div class="col-lg-1">
        </div>
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

    this.submit = function(){
      if(this.searched_text.value.length !== 0){
        fetch(`http://localhost:5000/string/${this.searched_text.value}/samples?n_limit=500`)
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
