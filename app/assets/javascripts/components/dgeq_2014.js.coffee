{Component} = require 'react'
{p, h4, div, text, crel} = require '../teact'


class CardMessage extends Component
  render: =>
    div '.columns.small-4.flex-container', =>
      div '.card', =>
        div '.card-divider', =>
          text this.props.titre
        div '.card-section', =>
          h4 {}, 'This is a card'
          p {}, this.props.message

#Base class
class MapBase extends Component
  @defaultProps = {
    minZoom: 13,
    maxZoom: 16,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialPoint: [45.512, -73.558],
    initialZoom: 14
  }
  


  render: =>
    div '.map-wrap', =>
      h4 {}, "Elections Générales du 7 avril 2014"
      p {}, "Résultats par sections de vote dans #{@props.titre}"
      div { id: "map_#{@props.codeCirconscription}", className:'aMap'}, ''

  componentDidMount: =>
    #console.log "Map id: map_#{@props.codeCirconscription}"

    svg                   = null
    path                  = null
    mymap                 = null
    gdata                 = null
    features              = null
    circonscriptions      = null
    comte                 = null
    g                     = null
    noms                  = null
    codeCirconscription   = @props.codeCirconscription
    lcandidats            = @props.candidats

    mymap = L.map "map_#{@props.codeCirconscription}", {
      zoom:       @props.zoom,
      minZoom:    @props.minZoom,
      maxZoom:    @props.maxZoom,
      maxBounds:  @props.maxBounds,
    }

    #Get a background map using tiles // Esri.WorldStreetMap
    L.tileLayer.provider 'OpenStreetMap.BlackAndWhite' 
    .addTo(mymap)

    #Il reste toujour un autre bug...
    mymap.setView @props.initialPoint, @props.initialZoom, reset: true

    #Ajout d'une couche svg et d'un élément central (g) dans svg
    svg       = d3.select(mymap.getPanes().overlayPane).append 'svg'
    g         = svg.append('g').attr('class', 'leaflet-zoom-hide')


    #Utilisé pour transformer les coordonnés d'un point
    #de Lat/Long au système de coordonné local en pixel
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

      g.attr("transform", "translate(" + -topLeft[0] + "," + -topLeft[1] + ")") if g?
      features.attr("d", path) if features?
      circonscriptions.attr("d", path) if circonscriptions?
      comte.attr("d", path) if comte?
      
      # Le nom de chaque circonscription représente un défi particulier.
      # Chaque circonscription a une superficie particulière et celle-ci
      # est représentée par une surface variable à l'écran. Il faut donc
      # adapter la taille du nom de la circonscription à l'espace disponible
      # compte tenu de l'espace disponible (qui varie selon le zoom)
      if noms?
        noms.attr "transform", (d) ->
          centroid = mymap.latLngToLayerPoint(d.latLng)
          "translate(#{centroid.x}, #{centroid.y})"
        
        noms.attr "district_area", (d) -> path.area(d)

        noms.attr "visibility", (d) ->
          rep = "novalue"

          #Ne pas afficher le nom s'il s'agit de la circonscription cible
          #console.log "d.id: #{d.properties.CO_CEP}  #{d.properties.NM_CEP} codeCirconscription: #{codeCirconscription}"
          if path.area(d) < 20000.0 || d.properties.CO_CEP ==  "#{codeCirconscription}"
            rep = "hidden"
          else
            rep = "inherit"

        noms.style "font-size", (d) ->
          #console.log "#{d.properties.CO_CEP}  #{d.properties.NM_CEP} area: #{path.area(d)}"
          rep = "3pt"
          if path.area(d) >= 90000.0
            rep = "18pt"
          else if path.area(d)>35000.0
            rep = "12pt"
          else
            rep = "6pt"



    drawMap = (error, data, dgeq, resultats) ->
      if error
        console.log("got #{error}")
      else
        #console.log('got data')

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

      
        # La carte électorale du Québec
        electionsQC = dgeq.objects['electionsQC']
        voisines = topojson.feature(dgeq, electionsQC)
        circonscriptions = g.selectAll(".district")
          .data(voisines.features)
          .enter()
          .append "path"
            .attr "id", (d) -> "#{codeCirconscription}-#{d.properties.CO_CEP}"
            .attr "class", (d) -> "district d" + d.properties.CO_CEP
            .attr "name", (d) -> d.properties.NM_CEP + " QC"
            .attr "data-centroid", (d) ->
              centroid = mymap.layerPointToLatLng(path.centroid(d))
              "#{centroid.lat}, #{centroid.lng}"


        #Les résultats dans les différentes circonscriptions
        res2014 = resultats.circonscriptions
        for circonscription, i in res2014
          numero = circonscription.numeroCirconscription
          if numero == codeCirconscription
            repere = "path\##{codeCirconscription}-#{numero}"
            $(repere).attr "class", "district d#{numero} target"
            continue
          candidats = circonscription.candidats
          partiElu = candidats[0].numeroPartiPolitique
          switch partiElu
            when 6 then classeParti = "plq"   #ces numéros sont attribués par le DGEQ
            when 8 then classeParti = "pq"    #et leur attribution est présente dans le fichier JSON
            when 11 then classeParti = "qs"
            when 27 then classeParti = "caq"
            else classeParti = "autreParti"
          repere =  "path\##{codeCirconscription}-#{numero}"
          $(repere).attr "class", "district d#{numero} elu #{classeParti}"

        # Ajoutons le nom des circonscriptions
        noms = g.selectAll("text.nom")
          .data(voisines.features)
          .enter()
          .append("text")
            .attr("id", (d) ->
              "n#{codeCirconscription}-" + d.properties.CO_CEP)   #je précède le numéro de circonscription de "n"
                      #afin qu'il n'y ait pas deux object avec le même id.
            .text((d) ->
              d.properties.NM_CEP)
            .attr("district_area", "nil")
            .attr("class", "nom")
            .attr("text-anchor", "middle")
            .attr("transform", (d) ->
              centroid = path.centroid(d)           #je trouve le centroid de la circonscription
              d.latLng = mymap.layerPointToLatLng(centroid )  #que je traduit dans le système de référence Leaflet
              "translate(#{centroid[0]}, #{centroid[1]})")  #et je l'enregistre avec 'd'. Et je déplace le nom au bon endroit

        # Ajoutons maintenant la circonscription
        #Les sections de vote dans la circonsription

        sc = dgeq.objects["#{codeCirconscription}"]
        sections = topojson.feature(dgeq, sc)
        comte = g.selectAll ".section"
          .data sections.features
          .enter()
          .append "path"
            .attr "class", (d) -> "section s#{codeCirconscription}-#{d.properties.NO_SV}"
            .attr 'id', (d) -> "s#{codeCirconscription}-#{d.properties.NO_SV}"

        # Résultats par section de vote au sein de la circonscription
        results_by_section_file = "/2014-04-07/#{codeCirconscription}.csv"
        if sessionStorage.getItem(results_by_section_file)?
          console.log("Using sessionStorage with key: #{results_by_section_file}")
          colorSections(sessionStorage.getItem(results_by_section_file))
        else
          d3.text results_by_section_file, (error, csv2014) ->
            if error
              console.log "Error reading /2014-04-07/#{codeCirconscription}.csv"
            else
              console.log "Donnees resultats pour /2014-04-07/#{codeCirconscription}.csv reçues"
              sessionStorage.setItem(results_by_section_file, csv2014)
              colorSections(csv2014)



        #préparer le reset
        gdata = data
        mymap.on('zoomend', reset)
        reset()

    colorSections = (csv2014) =>
      dsv = d3.dsvFormat(";")

      res = dsv.parse csv2014
      clefs = lcandidats.reduce ((memo, c) ->
                    memo.push c.clef
                    memo
                  ), []

      partis = lcandidats.reduce ((memo, c) ->
                    memo.push c.abreviation
                    memo
                  ), []

      console.log "Columns: #{res.columns[7]}"
      for rs, j in res
        vote_max = 0
        i_max = -1
        sv = rs['S.V.']
        
        svn = /(\d+)A/.exec(sv)
        if (svn != null)
          #console.log "Match! #{svn[1]}"
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
        
        #console.log "#{sv} #{partis[i_max]}  #{vote_max}"
        repere = "path\#s#{codeCirconscription}-#{sv}"
        $(repere).addClass "#{partis[i_max]}"
        if (vote_max/rs['B.V.'] < 0.50)
          $(repere).addClass "faible"
        else if vote_max/rs['B.V.'] < 0.65
          $(repere).addClass "moyen"
        else
          $(repere).addClass "fort"


    dispatchData = (e) =>
      console.log("DispatchData  called for #{this.props.codeCirconscription}")
      topo = JSON.parse(sessionStorage.provinces)
      data = topojson.feature(topo, topo.objects.provinces)
      dgeq = JSON.parse(sessionStorage.dgeq)
      resultats = JSON.parse(sessionStorage.resultats)
      drawMap(null,data,dgeq,resultats)


    captureData = (error, data, dgeq, resultats) =>
      if error
        console.log "loading -> null  for #{@props.codeCirconscription}"
        sessionStorage.data_loaded = null
      else
        sessionStorage.data_loaded = "ok"
        console.log "loading -> ok for #{@props.codeCirconscription}"
        sessionStorage.provinces = JSON.stringify(data)
        sessionStorage.dgeq = JSON.stringify(dgeq)
        sessionStorage.resultats = JSON.stringify(resultats)

        window.dispatchEvent(new Event('d3_data_loaded'))


    #Entry point
    if !sessionStorage.data_loaded?
      console.log "null -> loading for #{@props.codeCirconscription}"
      sessionStorage.data_loaded = "loading"
      # Request data files
      d3.queue()
        .defer d3.json, '/provinces.topojson'
        .defer d3.json, '/mtl.json'
        .defer d3.json, '/resultats.json'
        .await captureData
      window.addEventListener('d3_data_loaded', dispatchData, false)
    else if sessionStorage.data_loaded == 'loading'
      console.log "* data loading for #{@props.codeCirconscription}"
      window.addEventListener('d3_data_loaded', dispatchData, false)

    else if sessionStorage.data_loaded == 'ok'
      console.log "** data ok for #{@props.codeCirconscription}"
      dispatchData()

    else
      console.log "***sessionStorage.data_loaded: #{sessionStorage.data_loaded}"
      
    #
    # sessionStorage.provinces = JSON.stringify(data)
    # data = JSON.parse(sessionStorage.provinces)

#Gouin 381
class Gouin extends MapBase
  @defaultProps = {
    codeCirconscription: 381,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialPoint: [45.54, -73.60],
    minZoom: 13,
    maxZoom: 16,
    initialZoom: 14,
    candidats: [
      {
        clef: "Auguste-Constant Cheraquie P.L.Q./Q.L.P."
        nom: "Cheraquie Auguste-Constant"
        parti:"Parti Libéral du Québec"
        abreviation: 'plq'
      },
      {
        clef: "Boulanger Marc P.N."
        nom: "Marc Boulanger"
        parti:"Parti Nul"
        abreviation: 'pn'
      },
      {
        clef: "David Françoise Q.S."
        nom: "Françoise David"
        parti:"Québec solidaire"
        abreviation: 'qs'
      },
      {
        clef: "Franche Paul C.A.Q.-É.F.L."
        nom: "Paul Franche"
        parti:"Coallition Avenir-Québec"
        abreviation: 'caq'
      },
      {
        clef: "Lacelle Olivier O.N. - P.I.Q."
        nom: "Olivier Lacelle"
        parti:"Option Nationale - Parti Indépendantiste du Québec"
        abreviation: 'on'
      },
      {
        clef: "Mailloux Louise P.Q."
        nom: "Louise Mailloux"
        parti:"Parti Québécois"
        abreviation: 'pq'
      }]
    }
  
# Laurier-Dorion 423
class LaurierDorion extends MapBase
  @defaultProps = {
    codeCirconscription: 423,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialPoint: [45.54, -73.63],
    minZoom: 13,
    maxZoom: 16,
    initialZoom: 14,
    candidats: [
      {
        clef: "Assouline Valérie C.A.Q.-É.F.L."
        nom: "Valérie Assouline"
        parti:"Coallition Avenir-Québec"
        abreviation: 'caq'
      },
      {
        clef: "Céré Pierre P.Q."
        nom: "Pierre Céré"
        parti:"Parti Québécois"
        abreviation: 'pq'
      },
      {
        clef: "Fontecilla Andrés Q.S."
        nom: "Andrés Fontecilla"
        parti:"Québec solidaire"
        abreviation: 'qs'
      },
      {
        clef: "Macrisopoulos Peter P.M.L.Q."
        nom: "Françoise David"
        parti:"Parti Marxiste-Léniniste du Québec"
        abreviation: 'pmlq'
      },
      {
        clef: "Sklavounos Gerry P.L.Q./Q.L.P."
        nom: "Gerry Sklavounos"
        parti:"Parti Libéral du Québec"
        abreviation: 'plq'
      },
      {
        clef: "St-Onge Hugô B.P."
        nom: "Hugo St-Onge"
        parti:"Bloc Pot"
        abreviation: 'bp'
      },
      {
        clef: "Tessier Jeremy P.V.Q./G.P.Q."
        nom: "Jeremy Tessier"
        parti:"Parti vert"
        abreviation: 'pvq'
      },
      {
        clef: "Tremblay Miguel O.N. - P.I.Q."
        nom: "Miguel Tremblay"
        parti:"Option Nationale"
        abreviation: 'on'
      }]
    }

# Mercier 383
class Mercier extends MapBase
  @defaultProps = {
    codeCirconscription: 383,
    zoom: 14,
    minZoom: 13,
    maxZoom: 16,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialPoint: [45.53, -73.58],
    initialZoom: 14,    
    candidats: [
      {
        clef: "Clavet Alain C.A.Q.-É.F.L."
        abreviation: 'caq'
      },
      {
        clef: "Deslandes Hate's B.P."
        abreviation: 'bp'
      },
      {
        clef: "Hughes Roger Ind"
        abreviation: 'ind'
      },
      {
        clef: "Khadir Amir Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Legault Sylvie P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Sagala Richard P.L.Q./Q.L.P."
        abreviation: 'plq'
      },
      {
        clef: "Servant Martin O.N. - P.I.Q."
        abreviation: 'on'
      },
    ]
  }

#Sainte-Marie — Saint-Jacques 389
class SainteMarieSaintJacques extends MapBase
  @defaultProps = {
    codeCirconscription: 389,
    initialPoint: [45.512, -73.558],
    initialZoom: 13,    
    minZoom: 6,
    maxZoom: 16,
    maxBounds: [[45.4,-74], [48.7, -70.4]],
    candidats: [
      {
        clef: "Bissonnette Marc B.P."
        nom: "Marc Bissonnette"
        parti:"Bloc Pot"
        abreviation: 'bp'
      },
      {
        clef: "Breton Daniel P.Q."
        nom: "Daniel Breton"
        parti:"Parti Québécois"
        abreviation: 'pq'
        
      },
      {
        clef: "Klisko Anna P.L.Q./Q.L.P."
        nom: "Anna Klisko"
        parti: "Parti Libéral du Québec"
        abreviation: 'plq'
        
      },
      {
        clef: "Lachapelle Serge P.M.L.Q."
        nom: "Serge Lachapelle"
        parti:"Parti Marxiste-Léniniste"
        abreviation: 'pmlq'
        
      },
      {
        clef: "Massé Manon Q.S."
        nom: "Manon Massé"
        parti: "Québec solidaire"
        abreviation: 'qs' 
      },
      {
        clef: "Payne Nic O.N. - P.I.Q."
        nom: "Nic Payne"
        parti: "Option Nationale, Parti Indépendantiste du Québec"
        abreviation: 'onPiq'
        
      },
      {
        clef: "Thauvette Patrick C.A.Q.-É.F.L."
        nom: "Patrick Thauvette"
        parti: "Coallition Avenir-Québec / Équipe François Legault"
        abreviation: 'caq'
        
      },
      {
        clef: "Wiseman Stewart P.V.Q./G.P.Q."
        nom: "Stewart Wiseman"
        parti: "Parti Vert du Québec"
        abreviation: 'pvq'
        
      }
    ]
  }

# Homa 387
class HoMa extends MapBase
  @defaultProps = {
    codeCirconscription: 387,
    initialPoint: [45.555, -73.52],
    minZoom: 13,
    maxZoom: 16,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialZoom: 13,
    candidats: [
      {
        clef: "Canning Justin P.N."
        abreviation: 'pn'
      },
      {
        clef: "Dandenault Christine P.M.L.Q."
        abreviation: 'pmlq'
      },
      {
        clef: "Leduc Alexandre Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Lewis-Richmond Malcolm P.V.Q./G.P.Q."
        abreviation: 'pvq'
      },
      {
        clef: "Mallette Etienne B.P."
        abreviation: 'bp'
      },
      {
        clef: "Marchand Simon O.N. - P.I.Q."
        abreviation: 'on'
      },
      {
        clef: "Poirier Carole P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Provencher David P.L.Q./Q.L.P."
        abreviation: 'plq'
      },
      {
        clef: "Walsh Brendan C.A.Q.-É.F.L."
        abreviation: 'caq'
      }
    ]
  }  

# Rosemont 379
class Rosemont extends MapBase
  @defaultProps = {
    codeCirconscription: 379
    initialPoint: [45.555, -73.55],
    minZoom: 13,
    maxZoom: 16,
    maxBounds: [[45.4,-74], [45.7, -73.4]],
    initialZoom: 13,
    candidats: [
      {
        clef: "Babin Matthew B.P."
        abreviation: 'bp'
      },
      {
        clef: "Chénier Stéphane P.M.L.Q."
        abreviation: 'pmlq'
      },
      {
        clef: "Dubois Carl C.A.Q.-É.F.L."
        abreviation: 'caq'
      },
      {
        clef: "Labelle Sophie-Geneviève O.N. - P.I.Q."
        abreviation: 'on'
      },
      {
        clef: "Lisée Jean-François P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Svetoushkina Ksenia P.V.Q./G.P.Q."
        abreviation: 'pvq'
      },
      {
        clef: "Trudelle Jean Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Valade Thiery P.L.Q./Q.L.P."
        abreviation: 'plq'
      },
      
    ]
  }  

# Jean-Lesage 623
class JeanLesage extends MapBase
  @defaultProps = {
    codeCirconscription: 623
    initialPoint: [46.847, -71.22],
    minZoom: 10,
    maxZoom: 16,
    maxBounds: [[46,-72], [48, -70.5]],
    initialZoom: 13,
    candidats: [
      {
        clef: "Bouchard Sébastien Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Breton José Ind"
        abreviation: 'ind'
      },
      {
        clef: "Châteauvert Pierre P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Drolet André P.L.Q./Q.L.P."
        abreviation: 'plq'
      },
      {
        clef: "Dumais Sébastien P.N."
        abreviation: 'pn'
      },
      {
        clef: "Foster Émilie C.A.Q.-É.F.L."
        abreviation: 'caq'
      },
      {
        clef: "Garcia Andrés É.A.P. - P.C.Q."
        abreviation: 'pcq'
      },
      {
        clef: "Moreau Claude P.M.L.Q."
        abreviation: 'pmlq'
      },
      {
        clef: "Zanetti Sol O.N. - P.I.Q."
        abreviation: 'on'
      }
    ]
  }

# Taschereau 633
class Taschereau extends MapBase
  @defaultProps = {
    codeCirconscription: 633
    initialPoint: [46.81, -71.22],
    minZoom: 10,
    maxZoom: 16,
    maxBounds: [[46,-72], [48, -70.5]],
    initialZoom: 13,
    candidats: [
      {
        clef: "Boivin Guy É.A."
        abreviation: 'ea'
      },
      {
        clef: "Brabant Steve C.A.Q.-É.F.L."
        abreviation: 'caq'
      },
      {
        clef: "Deblois Anne É.A.P. - P.C.Q."
        abreviation: 'pcq'
      },
      {
        clef: "Dorion Catherine O.N. - P.I.Q."
        abreviation: 'on'
      },
      {
        clef: "Drolet Sylvain P.S.P."
        abreviation: 'psp'
      },
      {
        clef: "Duchesne Marie-Ève Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Maltais Agnès P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Savard Jean-Luc P.N."
        abreviation: 'qs'
      },
      {
        clef: "Tanlet Florent P.L.Q./Q.L.P."
        abreviation: 'plq'
      }
    ]
  }


# Labelle 545
###
;;;;;R;
###
class Labelle extends MapBase
  @defaultProps = {
    codeCirconscription: 545
    initialPoint: [46.83246, -75.13701],
    minZoom: 9,
    maxZoom: 16,
    maxBounds: [[46,-76], [48, -73]],
    initialZoom: 11,
    candidats: [
      {
        clef: "Dagenais Gabriel Q.S."
        abreviation: 'qs'
      },
      {
        clef: "Lacroix Christian P.L.Q./Q.L.P."
        abreviation: 'plq'
      },
      {
        clef: "Pagé Sylvain P.Q."
        abreviation: 'pq'
      },
      {
        clef: "Remy-Quevedo Cedrick C.A.Q.-É.F.L."
        abreviation: 'caq'
      },
      {
        clef: "Richard-Léonard Philippe O.N. - P.I.Q."
        abreviation: 'on'
      }
    ]
  }



# Entry point
class HelloMessage extends Component

	render: ->
    div '', =>
      crel LaurierDorion
      



module.exports = {HelloMessage, Labelle, Rosemont, HoMa, SainteMarieSaintJacques,Mercier,LaurierDorion,Gouin, JeanLesage, Taschereau}

