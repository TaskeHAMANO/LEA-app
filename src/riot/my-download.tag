<my-download>
  <button type="button" name="download" onclick="{click_png}" class="btn btn-primary btn-block">Download as PNG</button>
  <button type="button" name="download" onclick="{click_svg}" class="btn btn-primary btn-block">Download as SVG</button>

  <script>
    this.click_png = function(){
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

    this.click_svg = function(){
      let svg = (new XMLSerializer).serializeToString(document.getElementById("map_svg"));
      let blob = new Blob([svg], { 'type': 'image/svg+xml' });

      window.URL = window.URL || window.webkitURL;
      let link = document.createElement('a');
          link.href = window.URL.createObjectURL(blob);
          link.download = (new Date).getTime().toString(16) + '.svg';
      link.click();
    }
  </script>
</my-download>
