_ = require 'underscore'
Helper = require('../helper')
Phase = require('./phase').Phase

class PreTransform extends Phase
  constructor: (context) ->
    super context, 'pretransform'

  preCondition: ->
    Helper.assert @context.annotations?
    Helper.assert @context.errors?
    Helper.assert @context.content?

  postCondition: ->
    Helper.assert @context.content?

  execute: ->
    content: @clearOldResutls_ @context.content, @context.annotations

  clearOldResutls_: (content, annotations) ->
    content = content.replace /\n?\/\/ (>>|~>|\?>?) .*$/gm, ''
    lines = content.split '\n'

    annotations.forEach ({ line: lineNo, column: columnNo }) =>
      line = lines[lineNo]
      [body, comment] = Helper.splitAt line, columnNo
      comment = comment.replace /^(\/\/ *?=>).*$/, '$1'
      lines[lineNo] = "#{body}#{comment}"

    lines.join '\n'


exports.factory = (context) ->
  new PreTransform context
