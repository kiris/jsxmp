Helper = require('../src/helper')

describe 'Helper', ->

  describe '#splitAt', ->

    it 'split string at index', ->
      expect(Helper.splitAt('string', 0)).toEqual ['', 'string']
      expect(Helper.splitAt('string', 1)).toEqual ['s', 'tring']
      expect(Helper.splitAt('string', 2)).toEqual ['st', 'ring']
      expect(Helper.splitAt('string', 6)).toEqual ['string', '']

    # it 'split string at index', ->
    #   expect(Helper.splitAt('string', -1)).toEqual ['strin', 'g']
    #   expect(Helper.splitAt('string', -2)).toEqual ['stri', 'ng']
    #   expect(Helper.splitAt('string', -6)).toEqual ['', 'string']

    it 'split string at index', ->
      expect(Helper.splitAt('string',  6)).toEqual ['string', '']
      # expect(Helper.splitAt('string', -6)).toEqual ['', 'string']

    it 'split string at index', ->
      expect(Helper.splitAt('string', 2, 4)).toEqual ['st', 'ri', 'ng']
      expect(Helper.splitAt('string', 3, 6)).toEqual ['str', 'ing', '']
      expect(Helper.splitAt('string', 1, 2, 3, 4, 5)).toEqual ['s', 't', 'r', 'i', 'n', 'g']
      # expect(Helper.splitAt('string', -6)).toEqual ['', 'string']
