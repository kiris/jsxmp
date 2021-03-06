// Generated by CoffeeScript 1.4.0

exports.assert = function(condition, message) {
  if (message == null) {
    message = "";
  }
  if (!condition) {
    throw new Error('ASSERT: ' + message);
  }
};

exports.debug = function(message) {
  return console.log(message);
};

exports.splitAt = function(string) {
  var indexs, prev, r;
  indexs = Array.prototype.slice.call(arguments, 1);
  prev = 0;
  r = indexs.map(function(i) {
    if (i > prev) {
      r = string.slice(prev, i);
      prev = i;
      return r;
    } else {
      return "";
    }
  });
  return r.concat(string.slice(prev));
};
