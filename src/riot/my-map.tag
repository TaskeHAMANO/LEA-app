import SelectInfoAction     from "Action/SelectInfoStoreAction"
import TabAction            from "Action/TabStoreAction"
import SampleListStore      from "Store/SampleListStore"
import UserSampleListStore  from "Store/UserSampleListStore"

<my-map>
  <div class="d3-map">
    <svg id="map_svg" xmlnx="http://www.w3.org/2000/svg" xlink="http://www.w3.org/1999/xlink" version="1.1">
      <g>
        <rect fill="black"></rect>
      </g>
    </svg>
  </div>

  <style scoped>
    .d3-map{
      background-color: black ;
      min-width: 100% ;
      min-height: 100% ;
    }
    .dot {
      cursor: pointer ;
    }
    .topics {
      cursor: pointer ;
    }
    .cross {
      cursor: pointer ;
    }
  </style>

  <script>
    var self = this;
    self.on("mount", ()=>{
      const selectInfoAction = new SelectInfoAction() ;
      const tabAction = new TabAction() ;

      initialize_map()

      self.setSelectInfoStore = (select_info) =>{
        selectInfoAction.setStore(select_info) ;
      } ;
      self.setTabStore = (tab) => {
        tabAction.setStore(tab)
      } ;
      selectInfoAction.resetStore() ;

      // Procedure for uploaded samples
      UserSampleListStore.on(UserSampleListStore.ActionTypes.changed, ()=>{
        let user_sample_list = UserSampleListStore.user_sample_list ;
        let svg = d3.select(".d3-map svg g") ;
        let samples = svg.append("g")
          .classed("user_samples", true)
          .attr("width", "100%")
          .attr("height", "100%")
          .selectAll(".user")
          .data(user_sample_list) ;

        samples.enter()
          .append("path")
            .classed("cross", true)
            .classed("user", true)
            .attr("d", d3.symbol().size(30).type(d3.symbolCross))
            .attr("transform", (d) => `translate(${self.x(d.x)},${self.y(d.y)})`)
            .style("fill", "white")
            .on("click", (d) => {
              self.setTabStore("info")
              self.setSelectInfoStore({"sample_id": d.sample_id, "project_id": d.project_id})
            }) ;
        samples.exit()
          .remove() ;
      })

      // Procedure for searched samples
      SampleListStore.on(SampleListStore.ActionTypes.changed, ()=>{
        let sample_list = SampleListStore.sample_list ;
        let candidate = sample_list.map((d)=>d.sample_id) ;
        let sample_value = sample_list.reduce((object, d, index)=>{
          object[d.sample_id] = d.value ;
          return object
        }, {})

        let color = d3.scaleSequential((t) => d3.rgb(t*255, t*255, t*255) + "" ) ;
        color.domain([0,1])

        if(candidate.length !== 0){
          d3.selectAll(".dot")
            .filter((d) => candidate.includes(d.sample_id))
            .style("fill", (d) => color(sample_value[d.sample_id]))
            .style("visibility", "visible") ;
          d3.selectAll(".dot")
            .filter((d) => !(candidate.includes(d.sample_id)))
            .style("visibility", "hidden") ;
          d3.selectAll(".cross")
            .style("visibility", "hidden") ;
        }else{
          d3.selectAll(".dot")
            .style("fill", (d) => d3.color(d.color))
            .style("visibility", "visible") ;
          d3.selectAll(".cross")
            .style("visibility", "visible") ;
        }
      })
    })

    function initialize_map(){
      d3.queue()
        .defer(d3.json, "http://localhost:5000/sample/location")
        .defer(d3.json, "http://localhost:5000/topic/location")
        .await((error, data, topic_data) =>{
          if (error) throw error

          // data processing
          let current_url = window.location.href ;
          let current_domain = current_url.replace(/index.html/g, "/data") ;
          data = data.sample_list ;
          topic_data = topic_data.topic_list ;
          data.forEach((d) => {
            d.x = +d.x ;
            d.y = +d.y ;
          });
          topic_data.forEach((d) => {
              d.x = +d.x ;
              d.y = +d.y ;
              d.href = `${current_domain}/${d.topic_id}.png` ;
          });

          let chart_div = d3.select(".d3-map") ;
          let svg_width = chart_div.node().getBoundingClientRect().width ;
          let svg_height = chart_div.node().getBoundingClientRect().height ;
          let zoomBehavior = d3.zoom()
              .on("zoom", zoom)
              .scaleExtent([1, 10]) ;
          let svg = chart_div.select("svg")
                .attr("width", svg_width)
                .attr("height", svg_height)
                .call(zoomBehavior)
                .call(drag)
              .select("g") ;
          svg.select("rect")
            .attr("width", "100%")
            .attr("height", "100%") ;

          // assign scale
          self.x = d3.scaleLinear()
            .range([0, svg_width]).nice() ;
          self.y = d3.scaleLinear()
            .range([svg_height, 0]).nice() ;
          let xMax = d3.max(data, (d) => d.x ) * 1.10,
              xMin = d3.min(data, (d) => d.x ) * 1.10,
              yMax = d3.max(data, (d) => d.y ) * 1.10,
              yMin = d3.min(data, (d) => d.y ) * 1.10 ;
          self.x.domain([xMin, xMax]) ;
          self.y.domain([yMin, yMax]) ;

          let topic_width  = 30,
              topic_height = 30 ;

          svg.append("g")
              .classed("topics", true)
            .selectAll(".topicimage")
              .data(topic_data)
            .enter().append("image")
              .classed("topicimage", true)
              .attr("xlink:href", (d) => d.href)
              .attr("width", topic_width)
              .attr("height", topic_height)
              .attr("transform", transform_topic)
              .on("click", (d) => {
                self.setTabStore("info")
                self.setSelectInfoStore({"topic_id": d.topic_id})
              }) ;

          svg.append("g")
              .classed("samples", true)
            .selectAll(".dot")
              .data(data)
            .enter().append("circle")
              .classed("dot", true)
              .attr("r", 1)
              .attr("transform", transform_sample)
              .style("fill", (d) => d.color )
              .on("click", (d) => {
                self.setTabStore("info")
                self.setSelectInfoStore({"sample_id": d.sample_id})
              }) ;

          function zoom() {
            svg.attr("transform", d3.event.transform) ;
          }

          function drag() {
            d3.drag()
              .on("drag",(d,i) => {
                d.x += d3.event.dx
                d.y += d3.event.dy
                d3.select(this)
                  .attr("transform", (d,i) => {
                    return "translate(" + [d.x, d.y ] + ")"
                  })
              }) ;
          }

          function transform_sample(d) {
            return "translate(" + self.x(d.x) + "," + self.y(d.y) + ")";
          }

          function transform_topic(d) {
            return "translate(" + (self.x(d.x) - topic_height/2) + "," + (self.y(d.y) - topic_height/2) + ")";
          }
      }) ;
    }
  </script>
</my-map>
