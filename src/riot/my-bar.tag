import RiotControl    from 'riotcontrol'
import SampleTopicAction from "Action/SampleTopicStoreAction"
import SampleTopicStore from 'Store/SampleTopicStore'

<my-bar>
  <div id="d3-chart"></div>

  <script>
    this.on("mount", ()=>{
      RiotControl.on(SampleTopicStore.ActionTypes.changed, ()=>{
        this.topic_data = SampleTopicStore.topic_data;
        d3.select("#d3-chart svg").remove();
        visualize_bar_chart(this.topic_data);
      })
    })

    function visualize_bar_chart(){
      let chart_div = d3.select("#d3-chart");
      // 大きさの取得のためにcontentのDOMを指定
      let content = d3.select(".content")
      // 大きさの指定
      let svg_width = content.node().getBoundingClientRect().width / 2 - 30;
      let svg_height = content.node().getBoundingClientRect().height - d3.select(".row-metadata").node().getBoundingClientRect().height;
      let bar_width = svg_width * 0.9 ;
      let bar_height = svg_height * 0.9;
      let margin = {top:30, bottom:0, left:30, right:0}
      // svg領域の付加
      let svg = chart_div.append("svg")
          .attr("width", svg_width)
          .attr("height", svg_height)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top +")");
      // 軸の大きさの指定
      let x = d3.scaleBand()
        .rangeRound([0, bar_width])
        .padding(0.1)
        .align(0.1);
      let y = d3.scaleLinear()
        .rangeRound([bar_height, 0]);
      let z = d3.scaleOrdinal(d3.schemeCategory10);
      let data = opts.data ;
      let element_name = opts.element_name ;
      let sample_list = []
      for (let key in data){
        sample_list.push(key)
      }
      let element_list = data[sample_list[0]].map((e) => e[element_name])

      x.domain(sample_list);
      // 得られたJSONから、valueの最大値を取得す
      y.domain([0, d3.max(sample_list.map((key) => d3.sum(data[key].map((obj) => obj.value))))]).nice();
      z.domain(element_list);
      // dataをd3.stackを使える形式に変換する
      data = sample_list.map((key) =>{
        let obj = {sample_id: key}
        data[key].forEach((e)=>{
          obj[e[element_name]] = e["value"];
        })
        return obj;
      })
      // stackの様式を設定する
      let stack = d3.stack()
        .keys(element_list) ;

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
          .attr("width", x.bandwidth()) ;

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
