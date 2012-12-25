fs = require('fs')
UUID = require('node-uuid')
execSync = require('exec-sync')
Helper = require('../helper')
Phase = require('./phase').Phase

class Evaluate extends Phase
  constructor: (context) ->
    super context, 'evaluate'

  preCondition: ->
    Helper.assert @context.script?

  execute: ->
    @exec @context, @context.script, @context.env

  exec: (context, script, env) ->
    filename = @getName_ env.file
    @createFile_ script, filename
    try
      cmd = @execCmd(context, filename)
      { stdout: stdout, stderr: stderr } = execSync cmd, true
      @writeResult stdout if stdout? && stdout != ''
      @writeError stderr if stderr? && stderr != ''
    catch error
      @context.status = -1
      throw error
    finally
      @deleteFile_ filename

  getName_: (path) ->
    uuid = UUID.v1()
    [dir, basename] = Helper.splitAt path, (path.lastIndexOf '/') + 1
    "#{dir}__JSXMP__#{uuid}#{basename}"

  createFile_: (script, filename) ->
    fs.writeFileSync filename, script

  deleteFile_: (filename) ->
    fs.unlinkSync filename

class NodeEvaluate extends Evaluate
  execCmd: (context, filename) ->
    "node #{filename}"

class JasmineNodeEvaluate extends Evaluate
  execCmd: (context, filename) ->
    "jasmine-node --noColor #{filename}"

class PhantomJSEvaluate extends Evaluate
  execCmd: (context, filename) ->
    "phantomjs #{filename}"

exports.factory = (context) ->
  switch context.env.evaluateBy
    when 'nodejs'
      if context.env.mode == 'jasmine'
        new JasmineNodeEvaluate context
      else
        new NodeEvaluate context

    when 'phantomjs'
      new PhantomJSEvaluate context
    else
      Helper.assert false, "unknown mode=#{context.env.mode}"
