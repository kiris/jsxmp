exec = require('../test_helper').exec

describe 'Read phase', ->
  it 'returns context on success', ->
    context = exec 'basic.js', 'annotations', 'read'

    expect(context.status).toEqual 0
    expect(context.content.split('\n')[0]).toEqual "// basic pattern"
    expect(context.result).toEqual ""
    expect(context.error).toEqual ""

  it 'returns context when file not exists', ->
    context = exec 'notfound.js', 'annotations', 'read'

    expect(context.status).toEqual -1
    expect(context.content).toEqual null
    expect(context.result).toEqual ""
    expect(context.error).not.toEqual ""
