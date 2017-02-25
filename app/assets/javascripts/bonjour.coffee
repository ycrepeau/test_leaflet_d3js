$ ->
  if $('#map').length == 0
    console.log 'No #map. Stopping script'
    return

  console.log 'launching map creation'

  svg = null
  path = null
  mymap	= null
  features = null
  g = null

  #create the map object.
  mymap = L.map 'map'

  #Get a background map using tiles
  L.tileLayer.provider "Stamen.TonerLite"
  .addTo(mymap)

  #There is always another bug
  mymap.setView [45.52, -73.55], 7, reset: true


  #Utilisé pour transformer les coordonnés d'un point
  #de Lat/Long au système de coordonné local
  projectPoint = (x, y) ->
    point = mymap.latLngToLayerPoint(new L.LatLng(y, x))
    this.stream.point(point.x, point.y)


  svg = d3.select(mymap.getPanes().overlayPane).append("svg")
  g   = svg.append("g").attr("class", "leaflet-zoom-hide")

  console.log 'calling d3.json /province.json'


  d3.json "/provinces.json", (error, data) ->
    if error
      console.log("got #{error}")
    else
      console.log "got data"

      transform = d3.geoTransform({point: projectPoint})
      path = d3.geoPath().projection(transform)

      reset = () ->
        console.log('reset called')

        bounds = path.bounds(data)
        console.log "path.bounds(df): #{bounds}"
        topLeft = bounds[0]
        bottomRight = bounds[1]
        svg.attr("width", bottomRight[0] - topLeft[0])
          .attr("height", bottomRight[1] - topLeft[1])
          .style("left", topLeft[0] + "px")
          .style("top", topLeft[1] + "px")

        g.attr("transform", "translate(" + -topLeft[0] + "," + -topLeft[1] + ")")
        features.attr("d", path)



      features = g.selectAll(".state")
        .data(data.features)
        .enter()
        .append('path')
          .attr "id", (d) ->
            d.properties.iso_3166_2
          .attr "class", (d) ->
            "state s" + d.properties.iso_3166_2
          .attr "name", (d) ->
            d.properties.name

      mymap.on("viewreset", reset)			#git in
			  reset()							#et j'appelle manuellement ce 'handler' pour parfaire le visuel


  console.log "Fin du script"

###
$(window).on 'resize', (e) ->
  h = $('#map').height()
  w = $('#map').width()


  if (error)
    console.log("error loading data ")
    alert("Probème de réception des fichiers de contours")
    return
  else
    console.log('/provinces.json reçu. ')

###
