_ = require 'underscore'
Helper = require('../helper')
Phase = require('./phase').Phase

class Parse extends Phase
  constructor: (context) ->
    super context, 'parse'

class EsprimaParse extends Parse
  ESPRIMA_OPTIONS:
    loc: true
    comment: true

  preCondition: ->
    Helper.assert @context.content?

  postCondition: ->
    Helper.assert @context.annotations?
    Helper.assert @context.errors?

  execute: ->
    annotations = @makeAnnotations_ @context.content
    {
      annotations: annotations
      errors: []
    }

  makeAnnotations_: (content) ->
    esprima = require 'esprima'

    { body: body, comments:comments } =
      esprima.parse content, @ESPRIMA_OPTIONS

    lines = content.split '\n'
    annotations = @collectAnnotations_ comments

    @travarse_ body, (node, path) =>
      annotation =
        _.find annotations, (line: line) ->
          node.loc.start.line - 1 <= line <= node.loc.end.line - 1

      return unless annotation?
      return unless node.type == 'ExpressionStatement'

      endColumn =
        if lines[node.loc.end.line - 1][node.loc.end.column - 1] == ';'
          node.loc.end.column - 1
        else
          node.loc.end.column

      annotation.body =
        start:
          line: node.loc.start.line - 1
          column: node.loc.start.column
        end:
          line: node.loc.end.line - 1
          column: endColumn

    annotations

  collectAnnotations_: (comments) ->
    regexp = /^ *=>.*$/
    comments
      .filter (v) ->
        v.type == 'Line' && regexp.test v.value
      .map (v) ->
        line: v.loc.start.line - 1
        column: v.loc.start.column
        body: null

  travarse_: (node, fn, path = []) ->
    if node instanceof Array
      _.each node, (child) =>
        @travarse_ child, fn, path
    else if node.type
      fn node, path

      path = path.concat node
      _.each node, (child, key) =>
        if child instanceof Object && child?
          @travarse_ child, fn, path

exports.factory = (context) ->
  new EsprimaParse context
