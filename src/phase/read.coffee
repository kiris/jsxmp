Helper = require('../helper')
Phase = require('./phase').Phase

class Read extends Phase
  constructor: (context) ->
    super context, 'read'

  preCondition: ->
    Helper.assert not @context.content?

  postCondition: ->
    Helper.assert @context.content?

  execute: ->
    content: @readFile_ @context.env.file

  readFile_: (file) ->
    fs = require 'fs'
    fs.readFileSync file, 'utf-8'

exports.factory = (context) ->
  new Read context