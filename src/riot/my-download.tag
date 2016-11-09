import UserSampleListStore from "Store/UserSampleListStore"
import UserSampleListAction from "Action/UserSampleListStoreAction"

<my-download>
  <h3>Download</h3>
  <button type="button" name="down_png" onclick="{click_png}" class="btn btn-primary btn-block">Download as PNG</button>
  <button type="button" name="down_svg" onclick="{click_svg}" class="btn btn-primary btn-block">Download as SVG</button>
  <h3>Upload</h3>
  <form onSubmit={submit_single}>
    <h4>Upload cluster file</h4>
    <input type="file" id="up_single">
    <button type="submit">Submit</button>
  </form>
  <form onSubmit={submit_multi}>
    <h4>Upload compressed cluster file</h4>
    <input type="file" id="up_multi">
    <button type="submit">Submit</button>
  </form>

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
        let input_file = document.getElementById("up_single") ;
        let files = input_file.files ;
        let data = new FormData() ;
        data.append("cluster_file", files[0]) ;
        fetch("http://localhost:5000/predict_single", {
          method:"post",
          mode: "cors",
          headers: new Headers({
            "Content-Type":"text/plain"
          }),
          body:data
        })
        .then((response) => response.json())
        .then((json) => {
          console.log(json);
          let new_data = json.new_sample_list;
          self.setStore(new_data);
        })
      }

      self.submit_multi= function(){
        let input_multi_files = document.getElementById("up_multi")
        let files = input_multi_files.files ;
        let data = new FormData() ;
        data.append("cluster_targz_file", files[0]) ;
        fetch("http://localhost:5000/predict_multiple", {
          method:"post",
          mode: "cors",
          headers: new Headers({
            "Content-Type":"application/x-tar"
          }),
          body:data
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
</my-download>
