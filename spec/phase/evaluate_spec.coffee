exec = require('../test_helper').exec

describe 'Evaluate phase', ->
  it 'returns context on success', ->
    context = exec 'basic.js', 'annotations', 'evaluate'

    expect(context.status).toEqual 0
    expect(context.script.split('\n')[0]).toEqual "// basic pattern"
    expect(context.error).toEqual ""

    lines = context.result.split('\n')
    expect(lines).toContain "stdout"
    expect(lines).toContain "!JSXMP:0=1"
    expect(lines).toContain "!JSXMP:1=null"
    expect(lines).toContain "!JSXMP:2=\"loop 0\""
    expect(lines).toContain "!JSXMP:2=\"loop 1\""
    expect(lines).toContain "!JSXMP:2=\"loop 2\""

  it 'returns context on runtime error', ->

    context = exec 'runtime-error.js', 'annotations', 'evaluate'

    expect(context.status).toEqual 0
    expect(context.script.split('\n')[0]).toEqual "// runtime error"
    expect(context.error).not.toEqual ""

    lines = context.result.split('\n')
