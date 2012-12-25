exec = require('../test_helper').exec

describe 'Parse phase', ->

  it 'returns context on success', ->
    context = exec 'basic.js', 'annotations', 'parse'

    expect(context.status).toEqual 0
    expect(context.content.split('\n')[0]).toEqual "// basic pattern"
    expect(context.result).toEqual ""
    expect(context.error).toEqual ""

    expect(context.annotations.length).toEqual 4
    expect(context.annotations[0]).toEqual({"line":3,"column":24,"body":{"start":{"line":3,"column":0},"end":{"line":3,"column":1}}});
    expect(context.annotations[1]).toEqual({"line":4,"column":24,"body":{"start":{"line":4,"column":0},"end":{"line":4,"column":4}}});
    expect(context.annotations[2]).toEqual({"line":6,"column":24,"body":{"start":{"line":6,"column":2},"end":{"line":6,"column":13}}});
    expect(context.annotations[3]).toEqual({"line":9,"column":24,"body":null});

  it 'returns context when invalid javascript file', ->
    context = exec 'syntax-error.js', 'annotations', 'parse'

    expect(context.status).toEqual -1
    expect(context.content.split('\n')[0]).toEqual "// syntax error"
    expect(context.result).toEqual ""
    expect(context.error).not.toEqual ""

    expect(context.annotations).toEqual null