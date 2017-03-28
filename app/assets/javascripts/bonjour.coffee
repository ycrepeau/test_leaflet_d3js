$ ->
  if $('#map').length == 0
    console.log 'No #map. Stopping script'
    return

  svg               = null
  path              = null
  mymap	            = null
  gdata             = null
  features          = null
  circonscriptions  = null
  gouin             = null
  g                 = null

  #create the map object.
  mymap = L.map 'map', {
    zoom:14,
    minZoom:13,
    maxZoom:16,
    maxBounds: [[45.5,-74], [45.7, -73.4]],
  }

  #Get a background map using tiles //Esri.WorldStreetMap
  L.tileLayer.provider 'OpenStreetMap.BlackAndWhite'
  .addTo(mymap)

  #There is always another bug
  mymap.setView [45.54, -73.60], 14, reset: true



  svg       = d3.select(mymap.getPanes().overlayPane).append 'svg'
  g         = svg.append('g').attr('class', 'leaflet-zoom-hide')


  #Utilisé pour transformer les coordonnés d'un point
  #de Lat/Long au système de coordonné local
  projectPoint = (x, y) ->
    point = mymap.latLngToLayerPoint(new L.LatLng(y, x))
    this.stream.point(point.x, point.y)


  transform = d3.geoTransform({point: projectPoint})
  path = d3.geoPath().projection(transform)

  reset = () ->

    bounds = path.bounds(gdata)
    topLeft = bounds[0]
    bottomRight = bounds[1]
    svg.attr("width", bottomRight[0] - topLeft[0])
      .attr("height", bottomRight[1] - topLeft[1])
      .style("left", topLeft[0] + "px")
      .style("top", topLeft[1] + "px")

    g.attr("transform", "translate(" + -topLeft[0] + "," + -topLeft[1] + ")")
    features.attr("d", path)
    circonscriptions.attr("d", path)
    gouin.attr("d", path)




  drawMap = (error, data, dgeq, resultats) ->
    if error
      console.log("got #{error}")
    else
      # Les limites territoriales des provinces et des états
      features = g.selectAll('.state')
        .data(data.features)
        .enter()
        .append('path')
          .attr 'id', (d) ->
            d.properties.iso_3166_2
          .attr 'class', (d) ->
            'state s' + d.properties.iso_3166_2
          .attr 'name', (d) ->
            d.properties.name

        #Les circonscriptions de la région
        voisines = topojson.feature(dgeq, dgeq.objects.electionsQC3)
        circonscriptions = g.selectAll(".district")
          .data(voisines.features)
          .enter()
          .append "path"
            .attr "id", (d) -> d.properties.CO_CEP
            .attr "class", (d) -> "district d" + d.properties.CO_CEP
            .attr "name", (d) -> d.properties.NM_CEP + " QC"

        #Les résultats dans les différentes circonscriptions
        res2014 = resultats.circonscriptions
        for circonscription, i in res2014
          numero = circonscription.numeroCirconscription
          continue if numero == 381
          candidats = circonscription.candidats
          partiElu = candidats[0].numeroPartiPolitique
          switch partiElu
            when 6 then classeParti = "plq"   #ces numéros sont attribués par le DGEQ
            when 8 then classeParti = "pq"    #et leur attribution est présente dans le fichier JSON
            when 11 then classeParti = "qs"
            when 27 then classeParti = "caq"
            else classeParti = "autreParti"
          repere = "path\##{numero}"
          $(repere).attr "class", "district d#{numero} elu #{classeParti}"

        #Les sections de vote dans Gouin
        sections = topojson.feature(dgeq, dgeq.objects.gouin)
        gouin = g.selectAll ".section"
          .data sections.features
          .enter()
          .append "path"
            .attr "class", (d) -> "section s#{d.properties.NO_SV}"
            .attr 'id', (d) -> "s#{d.properties.NO_SV}"

        # Résultats par sections se vote
        dsv = d3.dsvFormat(";", "text/plain; charset=ISO-8859-1")
        d3.text 'gouin.csv', (error, gouin2014) ->
          if error
            alert("Données pour Gouin non disponible")
          else
            console.log "Donnés reçues pour Gouin"
            res = dsv.parse gouin2014
            clefs = [
              'Auguste-Constant Cheraquie P.L.Q./Q.L.P.',
              'Boulanger Marc P.N.',
              'David Françoise Q.S.',
              'Franche Paul C.A.Q.-É.F.L.',
              'Lacelle Olivier O.N. - P.I.Q.',
              'Mailloux Louise P.Q.'
            ]

            partis = [
              'plq',
              'pn',
              'qs',
              'caq',
              'on',
              'pq'
            ]

            console.log "Columns: #{res.columns[7]}"
            for rs, j in res
              vote_max = 0
              i_max = -1
              sv = rs['S.V.']
              
              svn = /(\d+)A/.exec(sv)
              if (svn != null)
                console.log "Match! #{svn[1]}"
                sv = svn[1]
                rs['B.V.'] += res[j+1]['B.V.']
                for clef, i in clefs
                  rs[clef] += res[j+1][clef]

              for clef, i in clefs
                #console.log ">> #{rs['S.V.']} #{partis[i]} #{clef} #{rs[clef]}"ax
                if rs[clef]? && +rs[clef] > vote_max
                  #console.log "#{partis[i]} (#{rs[clef]}) > #{partis[i_max]} (#{vote_max})"
                  vote_max = +rs[clef]
                  i_max = +i
              
              console.log "#{sv} #{partis[i_max]}  #{vote_max}"
              repere = "path\#s#{sv}"
              $(repere).addClass "#{partis[i_max]}"
              if (vote_max/rs['B.V.'] < 0.50)
                $(repere).addClass "faible"
              else if vote_max/rs['B.V.'] < 0.65
                $(repere).addClass "moyen"
              else
                $(repere).addClass "fort"
                


        #préparer le reset
        gdata = data
        mymap.on('zoomend', reset)
  		  reset()




  d3.queue()
    .defer d3.json, '/provinces.json'
    .defer d3.json, '/gouin_mtl.json'
    .defer d3.json, '/resultats.json'
    .await drawMap
