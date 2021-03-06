// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets REA DME (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require turbolinks
//= require leaflet/dist/leaflet
//= require leaflet-providers/leaflet-providers
//= require jquery-tokeninput/src/jquery.tokeninput
//= require rails.validations
//= require rails.validations.simple_form
//= require foundation-sites/dist/js/foundation
//= require d3/d3
//= require d3-queue/d3-queue
//= require topojson/topojson
//= require react
//= require react_ujs
//= require components
//= require_tree .


var React = window.React = global.React = require('react');
var ReactDOM= window.ReactDOM = global.ReactDOM = require('react-dom');
//window.$ = window.jQuery = require('jquery')
//require('jquery-ujs')


jQuery(function(){
  jQuery(document).foundation();

});
