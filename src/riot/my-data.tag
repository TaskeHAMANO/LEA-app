import UserSampleListStore from "Store/UserSampleListStore"
import UserSampleListAction from "Action/UserSampleListStoreAction"

<my-data>
  <div class="container-fluid">
    <div class="row">
      <div class="col-sm-12">
        <div class="well">
          <h3>Download</h3>
          <button type="button" name="down_svg" onclick="{click_svg}" class="btn btn-primary btn-block">Download as SVG</button>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-12">
        <div class="well">
          <h3>Upload</h3>
          <form onSubmit={submit} id="upload_form">
            <h4>Upload cluster file</h4>
            <h5>.cluster file or tar.gz compressed cluster file by <a href="http://snail.nig.ac.jp/vitcomic2/">VITCOMIC2</a></h5>
            <input type="file" id="upload_file">
            <button type="submit" class="btn btn-primary">Submit</button>
            <button type="reset" name="reset" class="btn btn-default" onclick="{reset}">Reset</button>
          </form>
          <h5>{message}</h5>
        </div>
      </div>
    </div>
  </div>

  <script>
    var self = this ;

    const userSampleListAction = new UserSampleListAction();

    self.setUserSampleListStore = (sample_list) => {
      userSampleListAction.setStore(sample_list) ;
    }
    self.resetUserSampleListStore = () => {
      userSampleListAction.resetStore()
    }

    self.reset = function(){
      delete self.message ;
      self.resetUserSampleListStore() ;
    }

    self.submit = function(){
      self.message = "Loading..."
      let input = document.getElementById("upload_file") ;
      let data = new FormData() ;
      data.append("cluster_file", input.files[0])
      fetch("http://snail.nig.ac.jp/leaapi/new_sample", {
        method: "post",
        mode: "cors",
        headers: {
          "Accept": "application/json",
        },
        body: data
      })
      .then((response) => {
        if(response.ok){
          return response.json()
        }else{
          throw Error(response.statusText)
        }
      })
      .then((json) => {
        self.message = "Success"
        let new_data = json.new_sample_list;
        self.setUserSampleListStore(new_data);
        self.update();
      })
      .catch((err) => {
        self.message = `Error: ${err.message}`;
        self.update();
      })
    }

    self.click_svg = function(){
      let svg = (new XMLSerializer).serializeToString(document.getElementById("map_svg"));
      let blob = new Blob([svg], { 'type': 'image/svg+xml' });

      window.URL = window.URL || window.webkitURL;
      let link = document.createElement('a');
          link.href = window.URL.createObjectURL(blob);
          link.download = (new Date).getTime().toString(16) + '.svg';
      link.click();
    }
  </script>
</my-data>
