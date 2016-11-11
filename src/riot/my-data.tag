import UserSampleListStore from "Store/UserSampleListStore"
import UserSampleListAction from "Action/UserSampleListStoreAction"

<my-data>
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12">
        <h3>Download</h3>
        <button type="button" name="down_png" onclick="{click_png}" class="btn btn-primary btn-block">Download as PNG</button>
        <button type="button" name="down_svg" onclick="{click_svg}" class="btn btn-primary btn-block">Download as SVG</button>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12">
        <h3>Upload</h3>
        <form onSubmit={submit_single} id="upload_single_form">
          <h4>Upload cluster file</h4>
          <input type="file" id="up_single_file">
          <button type="submit">Submit</button>
        </form>
        <form onSubmit={submit_multi} id="upload_multi_form">
          <h4>Upload compressed cluster file</h4>
          <input type="file" id="up_multi_file">
          <button type="submit">Submit</button>
        </form>
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

      self.submit_single = function(){
        let input = document.getElementById("up_single_file") ;
        let data = new FormData() ;
        data.append("cluster_file", input.files[0])
        fetch("http://localhost:5000/predict_single", {
          method: "post",
          mode: "cors",
          body: data
        })
        .then((response) => response.json())
        .then((json) => {
          let new_data = json.new_sample_list;
          self.setStore(new_data);
        })
      }

      self.submit_multi = function(){
        let input = document.getElementById("up_multi_file") ;
        let data = new FormData() ;
        data.append("clusters_targz_file", input.files[0])
        fetch("http://localhost:5000/predict_multiple", {
          method: "post",
          mode: "cors",
          body: data
        })
        .then((response) => response.json())
        .then((json) => {
          let new_data = json.new_sample_list;
          self.setStore(new_data);
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
