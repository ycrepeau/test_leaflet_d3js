React = require 'react'
dsv = require 'd3-dsv'

elements =
  # Valid HTML 5 elements requiring a closing crel.
  # Note: the `var` element is out for obvious reasons, please use `crel 'var'`.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp script section
 select small span strong sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul video'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'

# Create a unique list of element names merging the desired groups.
merge_elements = (args...) ->
  result = []
  for a in args
    for element in elements[a].split ' '
      result.push element unless element in result
  result


class Teact
  constructor: ->
    @stack = null
    console.log "constructor #{JSON.stringify React}"

  resetStack: (stack = null) ->
    previous = @stack
    @stack = stack
    return previous

  isSelector: (string) ->
    string.length > 1 and string.charAt(0) in ['#', '.']

  parseSelector: (selector) ->
    id = null
    classes = []
    for token in selector.split '.'
      token = token.trim()
      if id
        classes.push token
      else
        [klass, id] = token.split '#'
        classes.push token unless klass is ''
    return { id, classes }

  normalizeArgs: (args) ->
    attrs = {}
    selector = null
    contents = null

    for arg, index in args when arg?
      switch typeof arg
        when 'string'
          if index is 0 and @isSelector(arg)
            selector = arg
            parsedSelector = @parseSelector(arg)
          else
            contents = arg
        when 'function', 'number', 'boolean'
          contents = arg
        when 'object'
          if arg.constructor == Object and not React.isValidElement arg
            attrs = Object.keys(arg).reduce(
              (clone, key) -> clone[key] = arg[key]; clone
              {}
            )
          else
            contents = arg
        else
          contents = arg

    if parsedSelector?
      { id, classes } = parsedSelector
      attrs.id = id if id?
      if classes?.length
        if attrs.className
          classes.push attrs.className
        attrs.className = classes.join(' ')

    # Expand data attributes
    dataAttrs = attrs.data
    if typeof dataAttrs is 'object'
      delete attrs.data
      for k, v of dataAttrs
        attrs["data-#{k}"] = v

    return { attrs, contents, selector }

  crel: (tagName, args...) ->
    unless tagName?
      throw new Error "Element type is invalid: expected a string (for built-in components) or a class/function (for composite components) but got: #{tagName}"
    { attrs, contents } = @normalizeArgs args

    switch typeof contents
      when 'function'
        previous = @resetStack []
        contents()
        children = @resetStack previous
      else
        children = contents

    if children?.splice
      el = React.createElement tagName, attrs, children...
    else
      el = React.createElement tagName, attrs, children

    @stack?.push el
    return el

  pureComponent: (contents) ->
    teact = @
    return ->
      previous = teact.resetStack null
      children = contents.apply teact, arguments
      teact.resetStack previous
      return children

  selfClosingTag: (tagName, args...) ->
    { attrs, contents } = @normalizeArgs args
    if contents
      throw new Error "Teact: <#{tagName}/> must not have content.  Attempted to nest #{contents}"
    @crel tagName, attrs

  text: (s) ->
    return s unless s?.toString
    @stack?.push(s.toString())
    return s.toString()

  #
  # Plugins
  #
  use: (plugin) ->
    plugin @

  #
  # Binding
  #
  tags: ->
    bound = {}

    boundMethodNames = [].concat(
      'ie normalizeArgs script crel pureComponent text use'.split(' ')
      merge_elements 'regular', 'obsolete', 'void', 'obsolete_void'
    )
    for method in boundMethodNames
      do (method) =>
        bound[method] = (args...) => @[method].apply @, args

    bound.crel.text = bound.text
    return bound

for tagName in merge_elements 'regular', 'obsolete'
  do (tagName) ->
    Teact::[tagName] = (args...) -> @crel tagName, args...

for tagName in merge_elements 'void', 'obsolete_void'
  do (tagName) ->
    Teact::[tagName] = (args...) -> @selfClosingTag tagName, args...

if module?.exports
  module.exports = new Teact().tags()
  module.exports.Teact = Teact
