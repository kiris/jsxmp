exports.assert = (condition, message = "") ->
  throw new Error('ASSERT: ' + message) unless condition

exports.debug = (message) ->
  console.log message

exports.splitAt = (string) ->
  indexs = Array.prototype.slice.call(arguments, 1)

  prev = 0
  r = indexs
    .map (i) ->
      if i > prev
        r = string[prev...i]
        prev = i
        r
      else
        ""

  r.concat string[prev..]
