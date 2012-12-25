_ = require 'underscore'

Helper = require('../helper')
Const = require('../const')
Phase = require('./phase').Phase

class ParseResult extends Phase
  RESULT_REGEXP: new RegExp "#{Const.ANNOTATION_PREFIX}(\\d+)=(.+)$"
  CLEAR_REGEXP:  new RegExp "(\n#{Const.ANNOTATION_PREFIX}.+|#{Const.ANNOTATION_PREFIX}.+\n?)", "mg"

  constructor: (context) ->
    super context, 'parse-result'

  preCondition: ->
    Helper.assert @context.annotations?

  postCondition: ->
    Helper.assert @context.annotations?

  execute: ->
    @parse @context.annotations, @context.result

  parse: (annotations, result) ->
    lines = result.split '\n'
    matches = lines.filter (line) =>
      @RESULT_REGEXP.test line

    matches
      .map (line) =>
        line.match @RESULT_REGEXP
      .forEach ([m, index, result]) =>
        annotation = annotations[index]
        if annotation.value?
          annotation.value.push result
        else
          annotation.value = [result]

    annotations: annotations.filter (a) -> a.value?
    result: result.replace @CLEAR_REGEXP, ''
    # result: _.difference(lines, matches).join '\n'

exports.factory = (context) ->
  new ParseResult context