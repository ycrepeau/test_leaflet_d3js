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

## Fichers du DGEQ (Directeur Général des Élections du Québec)

Les fichiers de données sont dans le dossier /public du projet.

provinces.geojson permettent d'afficher les frontières entre les provinces canadiennes et/ou les états des USA. (Source: Natural Earth). J'ai utilisé les fichier de type ESRI-Shapefiles que j'ai converti en geojson puis en topojson.

mtl.json est un fichier topjson contenant plusieurs topologies dont les limites entre les circonscriptions et les limites des sections de vote dans plusieurs circonscriptons. J'ai utilisé des fichiers ESRI-Shapefiles fournis par le DGEQ pour extraire les données pertinentes et les organiser afin de minimiser le volume du fichier.

resultats.json est un fichier geojson donnant les résultats pour les les 125 circonscriptions et je crois que je l'ai utilisé tel que fourni par le DGEQ.

Le sous-répertoire '2014-04-07' contient une série de fichiers donnant les résultats par section de vote circonscription par circonsriptions. Ces fichiers
ont été modifiés comme suits:

Nom original: nom_circonscription.csv
Nom intermédiaire: zxxx.csv

Où xxx est le numéro (code d'identification) de la circonscription.

Conversion de l'encodage du fichier de ISO-8859-1 (zxxx.csv) vers un encodage UTF-8.

# From SHP to Topojson

See: http://www.electionsquebec.qc.ca/francais/provincial/carte-electorale/geometrie-des-circonscriptions-provinciales-du-quebec-2014.php to get the appropriate zip file containing the ESRI Shapefile files. Once unzipped, run the following commands to get the topojson file used in the project. Move the
resulting file into the /public directory.

Two (2) zip files must be downloaded and treated. The 2011 section contains constituencies (circonscriptions or comtés in French) shapes and the 2014 section goes inside each constituency with the shapefile of every voting section.

The last section (not used in this project), labeled 2012, contains the voting section used on the September 4th. 2012 general elections.

````bash
export SHAPE_ENCODING="ISO-8859-1"
ogr2ogr -f GeoJSON -where "CO_CEP = '433'" -overwrite -t_srs EPSG:4326 json/433.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '381'" -overwrite -t_srs EPSG:4326 json/381.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '387'" -overwrite -t_srs EPSG:4326 json/387.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '429'" -overwrite -t_srs EPSG:4326 json/429.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '373'" -overwrite -t_srs EPSG:4326 json/373.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '377'" -overwrite -t_srs EPSG:4326 json/377.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '423'" -overwrite -t_srs EPSG:4326 json/423.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '383'" -overwrite -t_srs EPSG:4326 json/383.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '421'" -overwrite -t_srs EPSG:4326 json/421.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '379'" -overwrite -t_srs EPSG:4326 json/379.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '393'" -overwrite -t_srs EPSG:4326 json/393.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '389'" -overwrite -t_srs EPSG:4326 json/389.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '427'" -overwrite -t_srs EPSG:4326 json/427.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '623'" -overwrite -t_srs EPSG:4326 json/623.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '633'" -overwrite -t_srs EPSG:4326 json/633.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '643'" -overwrite -t_srs EPSG:4326 json/643.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '603'" -overwrite -t_srs EPSG:4326 json/603.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '653'" -overwrite -t_srs EPSG:4326 json/653.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8
ogr2ogr -f GeoJSON -where "CO_CEP = '639'" -overwrite -t_srs EPSG:4326 json/639.json Sections\ de\ Vote\ Elections\ 2014_04_07.shp -lco ENCODING=UTF-8

geo2topo -o ../mtl.json -q 1e6 373.json 377.json 379.json 381.json 383.json 387.json 389.json 393.json 421.json 423.json 427.json 429.json 433.json 603.json 623.json 633.json 639.json 643.json 653.json /Users/ycrepeau/SpiderOak\ Hive/mapMaker/electionsQC.json

````

# Copyright notice

(C) Copyright 2017 by Yanik Crépeau, All right reserved.

You are granted permission to copy the code, explore it,
re-use it at your convinience with the following limitations:

- This Copyright notice must remain
- If you use the data files provited by the Directeur Général de Élection du Québec, the copyright notice/usage permission and limitation must remain.
