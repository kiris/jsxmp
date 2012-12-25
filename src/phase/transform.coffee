Phase = require('./phase').Phase
Helper = require('../helper')

class AbstractTransform extends Phase
  constructor: (context) ->
    super context, 'transform'

  preCondition: ->
    Helper.assert @context.annotations?, "empty annotations"
    @context.annotations.forEach (annotation, i) ->
      Helper.assert annotation.line?, "empty annotation#{i}.line"
      Helper.assert annotation.column?, "empty annotation#{i}.column"
      Helper.assert annotation.value?, "empty annotation#{i}.value"

    Helper.assert @context.errors?, "empty errors"
    Helper.assert @context.content?, "empty content"

  postCondition: ->
    Helper.assert @context.content?, "empty content"

  execute: ->
    content: @transform @context.content, @context.annotations, @context.errors

  transform: (content, annotations, errors) ->
    lines = content.split '\n'

    annotations.forEach (annotation) =>
      @transformLine lines, annotation

    lines.join '\n'

  # @abstract
  transformLine: null

class AnnotationsTransform extends AbstractTransform
  transformLine: (lines, { line: lineNo, value: value }) ->
    line = lines[lineNo]
    lines[lineNo] = "#{line} #{value.join(', ')}"


class JasmineTransform extends AbstractTransform
  transformLine: (lines, { value: value, line:lineNo, column: columnNo, body: { start: start, end: end } }) ->
    match =
      if value.length > 1
        "toContain([#{value.join(', ')}])"
      else
        "toEqual(#{value[0]})"

    @removeAnnotate_ lines, lineNo, columnNo
    @transformTo_ lines, match, end
    @transformFrom_ lines, start

  removeAnnotate_: (lines, lineNo, columnNo) ->
    line = lines[lineNo]
    [body, annotate] = Helper.splitAt line, columnNo
    lines[lineNo] = "#{body}"

  transformFrom_: (lines, line:lineNo, column: columnNo) ->
    line = lines[lineNo]
    [before, body] = Helper.splitAt line, columnNo
    lines[lineNo] = "#{before}expect(#{body}"

  transformTo_: (lines, match, line:lineNo, column: columnNo) ->
    line = lines[lineNo]
    [body, after] = Helper.splitAt line, columnNo
    lines[lineNo] = "#{body}).#{match};"

exports.factory = (context) ->
  switch context.env.mode
    when 'annotations'
      new AnnotationsTransform context
    when 'jasmine'
      new JasmineTransform context
    when 'qunit'
      Helper.assert false
    else
      Helper.assert false, "unknown mode=#{context.env.mode}"
