# test_leaflet_d3js

Testing leaflet and d3.js (version 4) with Ruby on
Rails 5.

It also uses React with Broserify. Two buildpack have
been added to Heroku to acheive this. The javascript
classes handled by Browserify are built with a node 
process then the Rails built process is launched.

## JavaScript library used (from the Bowerfile)

* 'jquery'
* 'jquery-ujs'
* 'font-awesome'
* 'jquery-tokeninput'
* 'foundation-sites'
* 'leaflet'
* 'leaflet-providers'
* 'leaflet-ajax'
* 'd3'
* 'topojson'

## Notes:

* The SASS file used the .sass and not the .scss extention
* The Javascript file is written using the CoffeeScript dialect
* The Html is written using HAML.
* The project uses Zurb Foundation 6 framework as CSS Framework
* It uses semantic css (with haml it makes clean code)

##Fichers du DGEQ (Directeur Général des Élections du Québec)

Les fichiers de données sont dans le dossier /public du projet.

provinces.geojson permettent d'afficher les frontières entre les provinces canadiennes et/ou les états des USA. (Source: Natural Earth). J'ai utilisé les fichier de type ESRI-Shapefiles que j'ai converti en geojson puis en topojson.

mtl.json est un fichier topjson contenant plusieurs topologies dont les limites entre les circonscriptions et les limites des sections de vote dans plusieurs circonscriptons. J'ai utilisé des fichiers ESRI-Shapefiles fournis par le DGEQ pour extraire les données pertinentes et les organiser afin de minimiser le volume du fichier.

resultats.json est un fichier geojson donnant les résultats pour les les 125 circonscriptions et je crois que je l'ai utilisé tel que fourni par le DGEQ.

Le sous-répertoire '2014-04-07' contient une série de fichiers donnant les résultats par section de vote circonscription par circonsriptions.

# Copyright notice

(C) Copyright 2017 by Yanik Crépeau, All right reserved.

You are granted permission to copy the code, explore it,
re-use it at your convinience with the following limitations:

- This Copyright notice must remain
- If you use the data files provited by the Directeur Général de Élection du Québec, the copyright notice/usage permission and limitation must remain.
