Helper = require('../helper')

class Phase
  constructor: (@context, @name) ->

  run: ->
    @debug "execute #{@name}"
    @execute()

  execute: ->

  preCondition: ->

  postCondition: ->

  invariant: ->
    Helper.assert @context?
    Helper.assert @context.env?

  writeResult: (message) ->
    @context.result += message

  writelnResult: (message) ->
    @writeResult message + '\n'

  writeError: (message) ->
    @context.error += message

  writelnError: (message) ->
    @writeError message + '\n'

  debug: (message) ->
    if @context.env.debug
      @writeResult "[DEBUG] #{message}\n"

exports.Phase = Phase
