// Generated by CoffeeScript 1.4.0
var Const, Main, main;

Const = require('./const');

Main = (function() {

  function Main() {}

  Main.prototype.options = function() {
    var _this = this;
    return [
      {
        'short': 'f',
        'long': 'file',
        'description': 'Load a file.',
        'value': true,
        'required': true
      }, {
        'short': 'a',
        'long': 'annotations',
        'group': 'he',
        'description': 'Mode: Annotate code (default)'
      }, {
        'short': 'j',
        'long': 'jasmine',
        'description': 'Mode: Complete Jasmine expectations.'
      }, {
        'short': 'u',
        'long': 'qunit',
        'description': 'Mode: Complete QUnit expectations.'
      }, {
        'short': 'n',
        'long': 'nodejs',
        'description': 'Evaluate Environment: Node (default)'
      }, {
        'short': 'p',
        'long': 'phantomjs',
        'description': 'Evaluate Environment: PhantomJS (Not Implements)'
      }, {
        'short': 'r',
        'long': 'rhino',
        'description': 'Evaluate Environment: Rhino (Not Implments)'
      }, {
        'short': 'v',
        'long': 'version',
        'description': 'Print product version and exit.',
        'callback': function() {
          console.log("jsxmp " + Const.VERSION);
          return process.exit(1);
        }
      }, {
        'short': 'd',
        'long': 'debug',
        'description': 'Run with the debug mode.'
      }, {
        'long': 'Xphase',
        'description': 'Dump context to <value> phase.',
        'value': true
      }, {
        'long': 'Xshow-script',
        'description': 'Show script for evaluate phase.'
      }
    ];
  };

  Main.prototype.run = function() {
    var Xmp, env, xmp;
    Xmp = require('./xmp').Xmp;
    env = this.makeEnv();
    xmp = new Xmp(env);
    return xmp.run();
  };

  Main.prototype.makeEnv = function() {
    var opts;
    opts = require('opts');
    opts.parse(this.options(), true);
    return {
      file: opts.get('file'),
      mode: opts.get('annotations') ? 'annotations' : opts.get('jasmine') ? 'jasmine' : opts.get('qunit') ? 'qunit' : 'annotations',
      evaluateBy: opts.get('nodejs') ? 'nodejs' : opts.get('phantomjs') ? 'phantomjs' : opts.get('rhino') ? 'rhino' : 'nodejs',
      phase: opts.get('Xphase'),
      showScript: opts.get('Xshow-script'),
      debug: opts.get('debug')
    };
  };

  return Main;

})();

main = new Main;

main.run();