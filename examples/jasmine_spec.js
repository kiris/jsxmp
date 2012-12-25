var Helper = require('../lib/jsxmp/helper');

describe('Helper', function() {

  describe('#splitAt', function() {

    it('split string at index', function() {
      Helper.splitAt('string', 0); // =>
      Helper.splitAt('string', 1); // =>
      Helper.splitAt('string', 2); // =>
      Helper.splitAt('string', 6); // =>
    });

    it('split string at index', function() {
      Helper.splitAt('string',  6); // =>
    });
    it('split string at index', function() {
      Helper.splitAt('string', 2, 4); // =>
      Helper.splitAt('string', 3, 6); // =>
      Helper.splitAt('string', 1, 2, 3, 4, 5); // =>
    });
  });
});
