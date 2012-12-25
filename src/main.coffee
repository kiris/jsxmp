Const = require('./const')

class Main
  options: ->
    [
      {
        'short'       : 'f'
        'long'        : 'file'
        'description' : 'Load a file.'
        'value'       : true
        'required'    : true
      }
      # modes
      {
        'short'       : 'a'
        'long'        : 'annotations'
        'group'       : 'he'
        'description' : 'Mode: Annotate code (default)'
      }
      {
        'short'       : 'j'
        'long'        : 'jasmine'
        'description' : 'Mode: Complete Jasmine expectations.'
      }
      {
        'short'       : 'u'
        'long'        : 'qunit'
        'description' : 'Mode: Complete QUnit expectations.'
      }

      # Evaluate Environment
      {
        'short'       : 'n'
        'long'        : 'nodejs'
        'description' : 'Evaluate Environment: Node (default)'
      }
      {
        'short'       : 'p'
        'long'        : 'phantomjs'
        'description' : 'Evaluate Environment: PhantomJS (Not Implements)'
      }
      {
        'short'       : 'r'
        'long'        : 'rhino'
        'description' : 'Evaluate Environment: Rhino (Not Implments)'
      }

      # # file formats
      # {
      #   'short'       : 'A'
      #   'long'        : 'auto-format'
      #   'description' : 'File type is auto(default).'
      # }
      # {
      #   'short'       : 'J'
      #   'long'        : 'File type is javascript'
      #   'description' : 'javascript.'
      # }

      # misc
      {
        'short'       : 'v'
        'long'        : 'version'
        'description' : 'Print product version and exit.'
        'callback'    : =>
          console.log "jsxmp #{Const.VERSION}"
          process.exit 1
      }
      {
        'short'       : 'd'
        'long'        : 'debug'
        'description' : 'Run with the debug mode.'
      }
      {
        'long'        : 'Xphase'
        'description' : 'Dump context to <value> phase.'
        'value'       : true
      }

      {
        'long'        : 'Xshow-script'
        'description' : 'Show script for evaluate phase.'
      }
    ]

  run: ->
    Xmp = require('./xmp').Xmp
    env = @makeEnv()

    xmp = new Xmp env
    xmp.run()

  makeEnv: ->
    opts = require 'opts'
    opts.parse @options(), true

    file:
      opts.get 'file'
    mode:
      if opts.get 'annotations'
        'annotations'
      else if opts.get 'jasmine'
        'jasmine'
      else if opts.get 'qunit'
        'qunit'
      else
        'annotations' # defaults
    evaluateBy:
      if opts.get 'nodejs'
        'nodejs'
      else if opts.get 'phantomjs'
        'phantomjs'
      else if opts.get 'rhino'
        'rhino'
      else
        'nodejs'

    phase:
      opts.get 'Xphase'
    showScript:
      opts.get 'Xshow-script'
    debug:
      opts.get 'debug'

main = new Main
main.run()