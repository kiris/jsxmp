// Generated by CoffeeScript 1.4.0
var Const, GenScript, Helper, Phase, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore');

Helper = require('../Helper');

Const = require('../Const');

Phase = require('./Phase').Phase;

GenScript = (function(_super) {

  __extends(GenScript, _super);

  function GenScript(context) {
    GenScript.__super__.constructor.call(this, context, 'generate-script');
  }

  GenScript.prototype.preCondition = function() {
    Helper.assert(this.context.annotations != null);
    return Helper.assert(this.context.errors != null);
  };

  GenScript.prototype.postCondition = function() {
    if (!this.context.env.showScript) {
      return Helper.assert(this.context.script != null);
    }
  };

  GenScript.prototype.execute = function() {
    var script;
    script = this.generate_(this.context.content, this.context.annotations);
    if (this.context.env.showScript) {
      this.context.content = script;
      return this.context.script = '';
    } else {
      return this.context.script = script;
    }
  };

  GenScript.prototype.generate_ = function(content, annotations) {
    var script,
      _this = this;
    script = content.split('\n');
    annotations.forEach(function(annotation, index) {
      if (annotation.body != null) {
        _this.transformTo_(script, index, annotation.body.end);
        return _this.transformFrom_(script, index, annotation.body.start);
      }
    });
    return script.join('\n');
  };

  GenScript.prototype.transformFrom_ = function(script, index, _arg) {
    var before, body, columnNo, line, lineNo, _ref;
    lineNo = _arg.line, columnNo = _arg.column;
    line = script[lineNo];
    _ref = Helper.splitAt(line, columnNo), before = _ref[0], body = _ref[1];
    return script[lineNo] = "" + before + "console.log('" + Const.ANNOTATION_PREFIX + "." + index + "=' + JSON.stringify(" + body;
  };

  GenScript.prototype.transformTo_ = function(script, index, _arg) {
    var after, body, columnNo, line, lineNo, _ref;
    lineNo = _arg.line, columnNo = _arg.column;
    line = script[lineNo];
    _ref = Helper.splitAt(line, columnNo), body = _ref[0], after = _ref[1];
    return script[lineNo] = "" + body + "))" + after;
  };

  return GenScript;

})(Phase);

exports.factory = function(context) {
  return new GenScript(context);
};