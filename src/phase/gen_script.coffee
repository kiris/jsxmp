_ = require 'underscore'
Helper = require('../helper')
Const = require('../const')
Phase = require('./phase').Phase

class GenScript extends Phase
  PARSER: "function(k,v){return typeof(v)==='function'?String(v):v;}"

  constructor: (context) ->
    super context, 'generate-script'

  preCondition: ->
    Helper.assert @context.annotations?
    Helper.assert @context.errors?

  postCondition: ->
    if not @context.env.showScript
      Helper.assert @context.script?

  execute: ->
    script = @generate_ @context.content, @context.annotations
    if @context.env.showScript
      @context.content = script
      @context.script = ''
    else
      @context.script = script

  generate_: (content, annotations) ->
    script = content.split '\n'

    annotations.forEach (annotation, index) =>
      if annotation.body?
        @transformTo_ script, index, annotation.body.end
        @transformFrom_ script, index, annotation.body.start

    script.join '\n'

  transformFrom_: (script, index, line:lineNo, column: columnNo) ->
    line = script[lineNo]
    [before, body] = Helper.splitAt line, columnNo
    script[lineNo] = "#{before}console.log('#{Const.ANNOTATION_PREFIX}#{index}=' + JSON.stringify(#{body}"

  transformTo_: (script, index, line:lineNo, column: columnNo) ->
    line = script[lineNo]
    [body, after] = Helper.splitAt line, columnNo
    script[lineNo] = "#{body},#{@PARSER}))#{after}"

exports.factory = (context) ->
  new GenScript context
