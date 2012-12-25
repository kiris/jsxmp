Xmp = require('../src/xmp').Xmp

exports.exec = (file, mode, phase, evaluateBy = 'nodejs') ->
  xmp = new Xmp
    file: 'examples/' + file
    phase: phase
    mode: mode
    evaluateBy: evaluateBy
    debug: false

  xmp.executeProcess()
