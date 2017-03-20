//= require teact
//= require_tree ./components
// Setup app into global name space for server rendering
var app = window.app = global.app = {};

// Component::Manifest
var HelloMessage = require('./components/hello_message.js.coffee');

// Include into app namespace
app.HelloMessage = HelloMessage;

