<my-map>
  <div class="d3-chart"></div>
  <style scoped>
    .d3-chart {
      background-color:#000;
    }
  </style>

  <script type="text/javascript">
    this.on("mount", ()=>{
      var self = this;

      d3.queue()
        .defer(d3.csv, "data/data.csv")
        .defer(d3.csv, "data/topics.csv")
        .await((error, data, topic_data) =>{
          //Convert type to number
          data.forEach(function(d) {
            d.x = +d.x;
            d.y = +d.y;
          });
          topic_data.forEach(function(d){
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

          let xMax = d3.max(data, function(d) { return d.x; }) * 1.10,
              xMin = d3.min(data, function(d) { return d.x; }) * 1.10,
              yMax = d3.max(data, function(d) { return d.y; }) * 1.10,
              yMin = d3.min(data, function(d) { return d.y; }) * 1.10;

          x.domain([xMin, xMax]);
          y.domain([yMin, yMax]);

          let topics = svg.append("g")
              .classed("topics", true)
              .attr("width", "100%")
              .attr("height", "100%");

          topics.selectAll(".topicimage")
              .data(topic_data)
            .enter().append("image")
              .classed("topicimage", true)
              .attr("xlink:href", function(d) { return d.src; })
              .attr("width", topic_width)
              .attr("height", topic_height)
              .attr("transform", transform_topic)

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
              .style("fill", function(d) { return d.color; })

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
    })
  </script>
</my-map>

