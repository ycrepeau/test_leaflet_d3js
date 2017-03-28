# Be sure to restart your server when you modify this file.

# ApplicationController.renderer.defaults.merge!(
#   http_host: 'example.org',
#   https: false
# ),

#Rails.application.config.sass.preferred_syntax = :sass
Rails.application.config.browserify_rails.commandline_options = ["-t [coffeeify] --extension=\".js.coffee\""]

#babelify --plugins [ transform-es2015-shorthand-properties ],
