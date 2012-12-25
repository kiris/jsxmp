exec = require('./test_helper').exec

describe 'Xmp', ->

  describe 'success', ->
    describe 'annotations mode', ->
      context = exec 'basic.js', 'annotations'

      it 'status is 0', ->
        expect(context.status).toEqual 0

      it 'no error', ->
        expect(context.error).toEqual ""

      it 'content is annotate', ->
        content = context.content

        contentLines = content.split '\n'
        expect(contentLines.length).toEqual 11
        expect(contentLines[0]).toEqual "// basic pattern"
        expect(contentLines[3]).toEqual "1;                      // => 1"
        expect(contentLines[4]).toEqual "null;                   // => null"
        expect(contentLines[6]).toEqual "  'loop ' + i;          // => \"loop 0\", \"loop 1\", \"loop 2\""
        expect(contentLines[9]).toEqual "var x = 1;              // =>"

      it 'result is stdout', ->
        result = context.result
        expect(result).not.toContain "!JSXMP:"
        expect(result).not.toContain "old"

        resultLines = result.split('\n')
        expect(resultLines.length).toEqual 1
        expect(resultLines[0]).toEqual "stdout"

    # describe 'jasmine mode', ->
    #   context = exec 'basic.js', 'jasmine'

    #   it 'status is 0', ->
    #     expect(context.status).toEqual 0

    #   it 'content is jasmine expects', ->
    #     content = context.content

    #     contentLines = content.split '\n'
    #     expect(contentLines.length).toEqual 11
    #     expect(contentLines[0]).toEqual "// basic pattern"
    #     expect(contentLines[3]).toEqual "expect(1).toEqual(1);"
    #     expect(contentLines[4]).toEqual "expect(null).toEqual(null);"
    #     expect(contentLines[6]).toEqual "  expect('loop ' + i).toContain([\"loop 0\", \"loop 1\", \"loop 2\"]);"
    #     expect(contentLines[9]).toEqual "var x = 1;              // =>"

  describe 'file not found', ->
    context = exec 'notfound.js', 'annotations'

    it 'status is -1', ->
      expect(context.status).toEqual -1

    it 'has error', ->
      expect(context.error).not.toEqual ""

    it 'hasn\'t content', ->
      expect(context.content).toEqual null

  describe 'syntax error', ->
    context = exec 'syntax-error.js', 'annotations'

    it 'status is -1', ->
      expect(context.status).toEqual -1

    it 'has error', ->
      expect(context.error).not.toEqual ""

    it 'content is not annotate', ->
        content = context.content

        contentLines = content.split '\n'
        expect(contentLines.length).toEqual 6
        expect(contentLines[0]).toEqual "// syntax error"
        expect(contentLines[2]).toEqual "'before syntax error'; // =>"
        expect(contentLines[3]).toEqual "var = 'syntax error';"
        expect(contentLines[4]).toEqual "'after syntax error';  // =>"

  describe 'runtime error', ->
    context = exec 'runtime-error.js', 'annotations'

    it 'status is 0', ->
      expect(context.status).toEqual 0

    it 'has error', ->
      expect(context.error).not.toEqual ""

    it 'content is annotate before runtime error', ->
        content = context.content

        contentLines = content.split '\n'
        expect(contentLines.length).toEqual 6
        expect(contentLines[0]).toEqual "// runtime error"
        expect(contentLines[2]).toEqual "'before runtime error'; // => \"before runtime error\""
        expect(contentLines[3]).toEqual "xxx.xxx = 'runtime error';"
        expect(contentLines[4]).toEqual "'after runtime error';  // =>"

  describe 'command not found', ->
