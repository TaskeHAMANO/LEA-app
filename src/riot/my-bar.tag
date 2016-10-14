<my-bar>
  <div id="d3-chart"></div>

  <script>
    this.on("mount", ()=>{
      let chart_div = d3.select("#d3-chart");
      // 大きさの取得のためにcontentのDOMを指定
      let content = d3.select(".content")
      // 大きさの指定
      let svg_width = content.node().getBoundingClientRect().width / 2 - 30;
      let svg_height = content.node().getBoundingClientRect().height - d3.select(".row-metadata").node().getBoundingClientRect().height;
      let margin = {top:0, bottom:0, left:0, right:0}
      // svg領域の付加
      let svg = chart_div.append("svg")
          .attr("width", svg_width)
          .attr("height", svg_height)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top +")");
      let x = d3.scaleBand()
        .rangeRound([0, svg_width])
        .padding(0.1)
        .align(0.1);
      let y = d3.scaleLinear()
        .rangeRound([svg_height, 0]);
      let z = d3.scaleOrdinal(d3.schemeCategory10);
      let data = opts.data;
      x.domain(Object.keys(data));
      // 得られたJSONから、valueの最大値を取得するためにループを回す
      y.domain([0, d3.max(Object.keys(data).map((key) => d3.max(data[key].map((obj) => obj.value))))]).nice();
      z.domain(Array.from(Array(50).keys()));
      // dataをd3.stackを使える形式に変換する
      data = Object.keys(data).map((key) =>{
        let obj = {sample_id: key}
        data[key].forEach((e)=>{
          obj[e["topic_id"]] = e["value"];
        })
        return obj;
      })
      // stackの様式を設定する
      let stack = d3.stack()
        .keys(Array.from(Array(50).keys()))

      // 積み上げ棒グラフの作成
      svg.selectAll(".serie")
        .data(stack(data))
        .enter()
        .append("g")
          .attr("class", "serie")
          .attr("fill", (d) => z(d.key))
        .selectAll("rect")
        .data((d)=>d)
        .enter()
        .append("rect")
          .attr("x", (d) => x(d.data.sample_id))
          .attr("y", (d) => y(d[1]))
          .attr("height", (d) => (y(d[0]) - y(d[1])))
          .attr("width", x.bandwidth());
    })
  </script>
</my-bar>
