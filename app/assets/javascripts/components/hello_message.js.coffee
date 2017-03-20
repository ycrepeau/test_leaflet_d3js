{Component} = require 'react'
{p, h4, div, text, crel} = require 'teact'

class CardMessage extends Component
  render: =>
    div '.card', =>
      div '.card-divider', =>
        text this.props.titre
      div '.card-section', =>
        h4 {}, 'This is a card'
        p {}, this.props.message


class HelloMessage extends Component

	render: ->
    div '.react-component', =>
      crel CardMessage, {titre: this.props.titre, message: 'The quick brown fox jumped over the lazydog '}
      crel CardMessage, {titre: this.props.titre, message: 'The quick brown fox jumped over the lazydog '}
      crel CardMessage, {titre: this.props.titre, message: 'The quick brown fox jumped over the lazydog '}
      crel CardMessage, {titre: this.props.titre, message: 'The quick brown fox jumped over the lazydog '}
      crel CardMessage, {titre: this.props.titre, message: 'The quick brown fox jumped over the lazydog '}
      crel CardMessage, {titre: this.props.titre, message: 'bonjour'}
      



module.exports = HelloMessage

