exec = require('../test_helper').exec

describe 'GenScript phase', ->
  it 'returns context on success', ->
    context = exec 'basic.js', 'annotations', 'generate-script'

    expect(context.status).toEqual 0
    expect(context.script.split('\n')[0]).toEqual "// basic pattern"
    expect(context.result).toEqual ""
    expect(context.error).toEqual ""

    lines = context.script.split('\n')
    expect(lines[3]).toEqual "console.log('!JSXMP:0=' + JSON.stringify(1));                      // =>"
    expect(lines[4]).toEqual "console.log('!JSXMP:1=' + JSON.stringify(null));                   // =>"
    expect(lines[6]).toEqual "  console.log('!JSXMP:2=' + JSON.stringify('loop ' + i));          // =>"
    expect(lines[9]).toEqual "var x = 1;              // =>"
