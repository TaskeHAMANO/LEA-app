<my-bar>
  <div id={opts.chart_id}>
    <div class="d3-chart"></div>
    <div class="d3-tooltip"></div>
  </div>

  <style scoped>
    div.d3-chart {
      z-index:0 ;
    }
    div.d3-tooltip {
      z-index:1 ;
      box-sizing: border-box;
      display: inline;
      text-align: center;
      padding: 2px;
      font: 12px sans-serif;
      inline-height: 1;
      background: black;
      color: white;
      position: absolute ;
      border-radius: 2px;
      pointer-events: none;
    }
  </style>

  <script>
    var self = this;
    this.on("mount", ()=>{
      let data = opts.data ;
      let element_name = opts.element_name ;
      let chart_id = opts.chart_id ;
      let color = opts.color ;
      visualize_bar_chart(data, element_name, chart_id, color);

      self.on("updated", () => {
        let data = opts.data ;
        let element_name = opts.element_name ;
        let chart_id = opts.chart_id
        let color = opts.color ;
        d3.select(`#${chart_id} .d3-chart svg`).remove()
        visualize_bar_chart(data, element_name, chart_id, color);
      })
    })

    function get_color_scale(color, element_list){
      if(typeof color == "undefined"){
        let z = d3.scaleOrdinal(d3.schemeCategory20b);
        z.domain(element_list);
        return z
      }else{
        let z = (d) => color[d] ;
        return z
      }
    }
    function visualize_bar_chart(data, element_name, chart_id, color){
      let chart_div = d3.select(`#${chart_id} .d3-chart`);
      let content = d3.select(".content")
      let svg_width = content.node().getBoundingClientRect().width / 2 - 30;
      let svg_height = content.node().getBoundingClientRect().height - d3.select(".row-metadata").node().getBoundingClientRect().height - 52 - 10 ;
      let bar_width  = svg_width * 0.9 ;
      let bar_height = svg_height * 0.9;
      let margin = {top:10, bottom:0, left:30, right:0}
      let svg = chart_div.append("svg")
          .attr("width", svg_width)
          .attr("height", svg_height)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top +")");
      let sample_list = []
      for (let key in data){
        sample_list.push(key)
      }
      let element_list = data[sample_list[0]].map((e) => e[element_name])

      let x = d3.scaleBand()
        .rangeRound([0, bar_width])
        .padding(0.1)
        .align(0.1);
      x.domain(sample_list);
      let y = d3.scaleLinear()
        .rangeRound([bar_height, 0]);
      y.domain([0, 0.99 * d3.max(sample_list.map((key) => d3.sum(data[key].map((obj) => obj.value))))]).nice();
      let z = get_color_scale(color, element_list);
      data = sample_list.map((key) =>{
        let obj = {sample_id: key}
        data[key].forEach((e)=>{
          obj[e[element_name]] = e["value"];
        })
        return obj;
      })
      let stack = d3.stack()
        .keys(element_list) ;

      let tip = d3.select(`#${chart_id} .d3-tooltip`)
        .style("visibility", "hidden");

      svg.selectAll(".serie")
        .data(stack(data))
        .enter()
        .append("g")
          .attr("class", "serie")
          .attr("fill", (d) => z(d.key))
          .on("mouseover", (d) =>{
            tip.style("visibility", "visible")
              .style("left", (d3.event.layerX)+"px")
              .style("top", (d3.event.layerY)+"px")
              .html(() => `<p>${element_name}: ${d.key}</p>`) ;
          })
          .on("mouseout", (d) =>{
            tip.style("visibility", "hidden")
          })
        .selectAll("rect")
        .data((d)=>d)
        .enter()
        .append("rect")
          .attr("x", (d) => x(d.data.sample_id))
          .attr("y", (d) => y(d[1]))
          .attr("height", (d) => (y(d[0]) - y(d[1])))
          .attr("width", x.bandwidth())
          ;

      svg.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0, " + bar_height + ")")
        .call(d3.axisBottom(x)) ;

      svg.append("g")
        .attr("class", "axis axis--y")
        .call(d3.axisLeft(y))
      .append("text")
        .attr("x", 2)
        .attr("y", y(y.ticks(10).pop()))
        .attr("dy", "0.35em")
        .attr("text-anchor", "start")
        .attr("fill", "#000")
        .text("Abundance") ;
    }
  </script>
</my-bar>
