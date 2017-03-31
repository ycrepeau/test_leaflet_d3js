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

# Copyright notice

(C) Copyright 2017 by Yanik Crépeau, All right reserved.

You are granted permission to copy the code, explore it,
re-use it at your convinience with the following limitations:

- This Copyright notice must remain
- If you use the data files provited by the Directeur Général de Élection du Québec, the copyright notice/usage permission and limitation must remain.
