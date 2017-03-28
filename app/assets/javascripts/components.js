//= require teact
//= require_tree ./components
// Setup app into global name space for server rendering
console.log("components.js loaded");
var app = window.app = global.app = {};
//var app = window.app  = {};

// Component::Manifest
var dgeq_2014 = require('./components/dgeq_2014.js.coffee');

// Include into app namespace
// dgeq_2014 Rosemont, HoMa, SainteMarieSaintJacques,Mercier,LaurierDorion,Gouin
app.HelloMessage            = dgeq_2014.HelloMessage;
app.Rosemont                = dgeq_2014.Rosemont;
app.HoMa                    = dgeq_2014.HoMa;
app.SainteMarieSaintJacques = dgeq_2014.SainteMarieSaintJacques;
app.Mercier                 = dgeq_2014.Mercier;
app.LaurierDorion           = dgeq_2014.LaurierDorion;
app.Gouin                   = dgeq_2014.Gouin;

