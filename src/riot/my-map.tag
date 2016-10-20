import SampleIDStore    from "Store/SampleIDStore"
import SampleIDAction   from "Action/SampleIDStoreAction"
import SampleListStore  from "Store/SampleListStore"

<my-map>
  <div class="d3-chart"></div>
  <style scoped>
    .d3-chart {
      background-color:#000;
    }
    .dot {
      cursor: pointer;
    }
  </style>

  <script type="text/javascript">
    var self = this;

    function initialize_map(){
      d3.queue()
        .defer(d3.csv, "data/data.csv")
        .defer(d3.csv, "data/topics.csv")
        .await((error, data, topic_data) =>{
          if (error) throw error
          //Convert type to number
          data.forEach((d) => {
            d.x = +d.x;
            d.y = +d.y;
          });
          topic_data.forEach((d) => {
              d.x = +d.x;
              d.y = +d.y;
          });

          let zoomBehavior = d3.zoom()
              .on("zoom", zoom)
              .scaleExtent([1, 10]);

          let chart_div = d3.select(".d3-chart")
              .style("min-width", "100%")
              .style("min-height", "100%");
          let svg_width = chart_div.node().getBoundingClientRect().width;
          let svg_height = chart_div.node().getBoundingClientRect().height;
          let svg = chart_div.append("svg")
              .attr("width", svg_width)
              .attr("height", svg_height)
            .append("g")
              .call(zoomBehavior)
            .append("g");

          let margin = { top: 0, right: 0, bottom: 0, left: 0},
            topic_width = 60,
            topic_height = 60;

          let x = d3.scaleLinear()
            .range([0, svg_width]).nice();
          let y = d3.scaleLinear()
            .range([svg_height, 0]).nice();

          let xMax = d3.max(data, (d) => d.x ) * 1.10,
              xMin = d3.min(data, (d) => d.x ) * 1.10,
              yMax = d3.max(data, (d) => d.y ) * 1.10,
              yMin = d3.min(data, (d) => d.y ) * 1.10;

          x.domain([xMin, xMax]);
          y.domain([yMin, yMax]);

          // topicを追加する
          let topics = svg.append("g")
              .classed("topics", true)
              .attr("width", "100%")
              .attr("height", "100%");

          topics.selectAll(".topicimage")
              .data(topic_data)
            .enter().append("image")
              .classed("topicimage", true)
              .attr("xlink:href", (d) => d.src)
              .attr("width", topic_width)
              .attr("height", topic_height)
              .attr("transform", transform_topic)

          // sampleを追加する
          let samples = svg.append("g")
              .classed("samples", true)
              .attr("width", "100%")
              .attr("height", "100%");

          samples.selectAll(".dot")
              .data(data)
            .enter().append("circle")
              .classed("dot", true)
              .attr("r", 2)
              .attr("transform", transform_sample)
              .style("fill", (d) => d.color )
              .on("click", (d) => self.setStore(d.SampleID))

          function zoom() {
            svg.attr("transform", d3.event.transform);
          }
          function transform_sample(d) {
            return "translate(" + x(d.x) + "," + y(d.y) + ")";
          }
          function transform_topic(d) {
            return "translate(" + (x(d.x) - topic_height/2) + "," + (y(d.y) - topic_height/2) + ")";
          }
      });
    }

    // original_colorを持っていたら、それをcolorへ代入する
    // 持っていなかったら、現在のcolorを代入する
    function initialize_color(){
     d3.selectAll(".dot")
       .each((d) => {
         if(typeof d.__original_color !== "undefined"){
          d.color = d.__original_color ;
         }else{
          d.__original_color = d.color ;
         }
       })
    }

    this.on("mount", ()=>{
      const sampleIDAction = new SampleIDAction();
      // D3の図形を描画する
      initialize_map()

      // SampleIDをStoreへ代入する挙動を設定する
      self.setStore = (sample_id) =>{
        sampleIDAction.setStore(sample_id);
      }
      sampleIDAction.resetStore();

      // SampleListのStoreが変更された際の挙動を記述
      SampleListStore.on(SampleListStore.ActionTypes.changed, ()=>{
        let sample_list = SampleListStore.sample_list;
        let candidate = sample_list.map((d)=>d.sample_id);
        // 色を戻す
        initialize_color();

        if(candidate.length !== 0){
          d3.selectAll(".dot")
            .filter((d) => candidate.includes(d.SampleID))
            .transition()
            .duration(1000)
            .style("fill", (d) => {
              return d3.color(d.color).brighter(8)
            })
            .style("opacity", 1.0)
          ;
          d3.selectAll(".dot")
            .filter((d) => !(candidate.includes(d.SampleID)))
            .transition()
            .duration(1000)
            .style("fill", (d) => {
              return d3.color(d.color).darker(8)
            })
            .style("opacity", 0.05)
          ;
        }else{
          d3.selectAll(".dot")
            .transition()
            .duration(1000)
            .style("fill", (d) => d3.color(d.color))
            .style("opacity", 1.0 )
          ;
        }
      })
    })
  </script>
</my-map>

