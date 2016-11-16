import UserSampleListStore from "Store/UserSampleListStore"
import UserSampleListAction from "Action/UserSampleListStoreAction"

<my-data>
  <div class="container-fluid">
    <div class="row">
      <div class="well">
        <h3>Download</h3>
        <button type="button" name="down_png" onclick="{click_png}" class="btn btn-primary btn-block">Download as PNG</button>
        <button type="button" name="down_svg" onclick="{click_svg}" class="btn btn-primary btn-block">Download as SVG</button>
      </div>
    </div>
    <div class="row">
      <div class="well">
        <h3>Upload</h3>
        <form onSubmit={submit_file} id="upload_form">
          <h4>Upload cluster file</h4>
          <h5>.cluster file or tar.gz compressed cluster file</h5>
          <input type="file" id="upload_file">
          <button type="submit">Submit</button>
        </form>
        <h5>{message}</h5>
      </div>
    </div>
  </div>

  <script>
    var self = this ;
    self.on("mount", ()=>{
      const userSampleListAction = new UserSampleListAction();

      self.setStore = (sample_list) => {
        userSampleListAction.setStore(sample_list) ;
      }
      self.resetStore = () => {
        userSampleListAction.resetStore() ;
      }

      self.submit_file = function(){
        self.message = "Loading..."
        let input = document.getElementById("upload_file") ;
        let data = new FormData() ;
        data.append("cluster_file", input.files[0])
        fetch("http://localhost:5000/new_sample", {
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
          self.setStore(new_data);
          self.update();
        })
        .catch((err) => {
          self.message = `Error: ${err.message}`;
          self.update();
        })
      }

      self.click_png = function(){
        let svg = (new XMLSerializer).serializeToString(d3.select("#map_svg").node());
        let width = d3.select("#map_svg").attr("width");
        let height = d3.select("#map_svg").attr("height")
        let canvas = document.createElement('canvas');
        canvas.width = width * 2;
        canvas.height = height * 2;

        let image = new Image;
        image.src = 'data:image/svg+xml;charset=utf-8;base64,' + btoa(unescape(encodeURIComponent(svg)));
        image.onload = function() {
          // 2倍の大きさで保存
          canvas.getContext('2d').drawImage(image, 0, 0, width, height, 0, 0, canvas.width, canvas.height);
          let link = document.createElement('a');
          link.href = canvas.toDataURL('image/png');
          link.download = (new Date).getTime().toString(16) + '.png';
          link.click();
        };
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
    })
  </script>
</my-data>
