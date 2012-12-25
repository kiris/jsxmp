_ = require 'underscore'
Helper = require('./helper')

class Xmp
  constructor: (@env) ->

  run: ->
    context = @executeProcess()
    # if context.env.phase?
    #   context.result += JSON.stringify context, null, 4)
    @write context
    context.status

  buildProcess: ->
    [
      require('./phase/read')
      require('./phase/parse')
      require('./phase/pre_transform')
      require('./phase/gen_script')
      require('./phase/evaluate')
      require('./phase/parse_result')
      require('./phase/transform')
    ]

  executeProcess: (process = @buildProcess()) ->
    context = @makeContext()

    try
      for Phase in process
        phase = Phase.factory context
        phase.invariant()
        phase.preCondition()

        context = _.extend context, phase.run()

        phase.postCondition()
        phase.invariant()

        if (context.env.phase == phase.name)
          break

    catch error
      context.status = -1
      context.error += "[ERROR] #{error.message} #{error.stack}"

    context

  makeContext: ->
    env: @env
    status: 0
    result: ''
    error: ''
    content: null
    script: null
    annotations: null
    errors: null

    options: {}

  write: (context) ->
    @writeCode context.content
    @writeResult context.result
    @writeError context.error

    if context.env.debug
      @writeDebug context.debug

  writeCode: (content) ->
    console.log content if content?

  writeResult: (result) ->
    console.log result.replace(/^/gm, '// >> ') if result? && result != ''

  writeError: (error) ->
    console.log error.replace(/^/gm, '// ~> ') if error? && error != ''

  writeDebug: (debug) ->
    console.log debug.replace(/^/gm, '// ?> ') if debug? && debug != ''


exports.Xmp = Xmp