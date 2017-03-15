import SelectInfoAction     from "Action/SelectInfoStoreAction"
import TabAction            from "Action/TabStoreAction"
import SampleListStore      from "Store/SampleListStore"
import UserSampleListStore  from "Store/UserSampleListStore"

<my-map>
  <div class="d3-map">
    <svg id="map_svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="100%" height="100%">
      <g>
        <rect fill="black" width="100%" height="100%"></rect>
        <g class="topics"></g>
        <g class="samples"></g>
        <g class="user_samples" width="100%" height="100%"></g>
      </g>
    </svg>
  </div>

  <style scoped>
    .d3-map{
      background-color: black ;
      width: 100% ;
      height: 100% ;
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
      initialize_map()
    })

    const selectInfoAction = new SelectInfoAction() ;
    const tabAction = new TabAction() ;
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
      let user_sample_list_cor = user_sample_list.reduce((object, d, index) => {
        object["x"].push(d["x"]) ;
        object["y"].push(d["y"]) ;
        return object
      }, {"x":[], "y":[]})
      let user_sample_list_center_cor = [
        user_sample_list_cor["x"].reduce((sum, d, index) => {
          sum += d ;
          return sum
        }, 0) / user_sample_list_cor["x"].length,
        user_sample_list_cor["y"].reduce((sum, d, index) => {
          sum += d ;
          return sum
        }, 0) / user_sample_list_cor["y"].length
      ]
      let svg = d3.select("#map_svg")
      let samples = svg.select(".user_samples").selectAll(".user")
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
      if(user_sample_list.length !== 0){
        d3.selectAll(".dot")
          .style("fill", (d) => d3.color(d.color).darker(5))
        ;
        let t = d3.zoomIdentity.translate(self.svg_width/2 - self.x(user_sample_list_center_cor[0]), self.svg_height/2 - self.y(user_sample_list_center_cor[1]))
        svg.transition()
          .duration(750)
          .call(self.zoom.transform, t) ;
      }else{
        svg.transition()
          .duration(750)
          .call(self.zoom.transform, d3.zoomIdentity) ;
        d3.selectAll(".dot")
          .style("fill", (d) => d.color)
          .style("visibility", "visible") ;
      }
    })

    // Procedure for searched samples
    SampleListStore.on(SampleListStore.ActionTypes.changed, ()=>{
      let sample_list = SampleListStore.sample_list ;
      let candidate = sample_list.map((d) => d.sample_id) ;
      let sample_value = sample_list.reduce((object, d, index)=>{
        object[d.sample_id] = d.value ;
        return object
      }, {})
      let color = d3.scaleSequential((t) => d3.rgb(t*255, t*255, t*255) + "" ) ;
      color.domain([0,1])
      let svg = d3.select("#map_svg") ;
      if(candidate.length !== 0){
        let top_sample_id = candidate[0] ;
        let top_sample_data = self.sample_data.find(x => x["sample_id"] == top_sample_id) ;
        let top_sample_cor = [self.svg_width / 2 - self.x(top_sample_data["x"]), self.svg_height / 2 - self.y(top_sample_data["y"])] ;
        d3.selectAll(".dot")
          .filter((d) => candidate.includes(d.sample_id))
          .style("fill", (d) => color(sample_value[d.sample_id]))
          .style("visibility", "visible") ;
        d3.selectAll(".dot")
          .filter((d) => !(candidate.includes(d.sample_id)))
          .style("visibility", "hidden") ;
        d3.selectAll(".cross")
          .style("visibility", "hidden") ;
        let t = d3.zoomIdentity.translate(self.svg_width/2, self.svg_height/2).scale(4).translate(-self.x(top_sample_data["x"]), -self.y(top_sample_data["y"]))
        svg.transition()
          .duration(750)
          .call(self.zoom.transform, t) ;
      }else{
        svg.transition()
          .duration(750)
          .call(self.zoom.transform, d3.zoomIdentity) ;
        d3.selectAll(".dot")
          .style("fill", (d) => d3.color(d.color))
          .style("visibility", "visible") ;
        d3.selectAll(".cross")
          .style("visibility", "visible") ;
      }
    })

    function initialize_map(){
      d3.queue()
        .defer(d3.json, "http://localhost:5000/sample/location")
        .defer(d3.json, "http://localhost:5000/topic/location")
        .awaitAll((error, result) =>{
          if (error) throw error

          // data processing
          self.sample_data = result[0].sample_list ;
          self.topic_data = result[1].topic_list ;
          let current_url = window.location.href ;
          let current_domain = current_url.replace(/index.html/g, "data") ;
          self.sample_data.forEach((d) => {
            d.x = +d.x ;
            d.y = +d.y ;
          });
          self.topic_data.forEach((d) => {
              d.x = +d.x ;
              d.y = +d.y ;
              d.href = `${current_domain}/${d.topic_id}.png` ;
              console.log(d.href) ;
          });

          let chart_div = d3.select(".d3-map") ;
          self.svg_width = chart_div.node().getBoundingClientRect().width ;
          self.svg_height = chart_div.node().getBoundingClientRect().height ;
          self.zoom = d3.zoom()
              .scaleExtent([1, 10])
              .on("zoom", zoomed) ;
          let g = chart_div.select("#map_svg")
                .call(self.zoom)
              .select("g") ;

          // assign scale
          let xMax = d3.max(self.sample_data, (d) => d.x ) * 1.10,
              xMin = d3.min(self.sample_data, (d) => d.x ) * 1.10,
              yMax = d3.max(self.sample_data, (d) => d.y ) * 1.10,
              yMin = d3.min(self.sample_data, (d) => d.y ) * 1.10 ;
          self.x = d3.scaleLinear()
            .range([0, self.svg_width])
            .nice() ;
          self.y = d3.scaleLinear()
            .range([self.svg_height, 0])
            .nice() ;
          self.x.domain([xMin, xMax]) ;
          self.y.domain([yMin, yMax]) ;

          // visualize topics
          let topic_width  = 30,
              topic_height = 30 ;
          g.select(".topics")
            .selectAll(".topicimage")
              .data(self.topic_data)
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

          // visualize samples
          g.select(".samples")
            .selectAll(".dot")
              .data(self.sample_data)
            .enter().append("circle")
              .classed("dot", true)
              .attr("r", 1)
              .attr("transform", transform_sample)
              .style("fill", (d) => d.color )
              .on("click", (d) => {
                self.setTabStore("info")
                self.setSelectInfoStore({"sample_id": d.sample_id})
              }) ;

          function zoomed() {
            g.attr("transform", d3.event.transform) ;
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
