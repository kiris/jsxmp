// Generated by CoffeeScript 1.4.0
var AbstractTransform, AnnotationsTransform, Helper, JasmineTransform, Phase,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Phase = require('./phase').Phase;

Helper = require('../helper');

AbstractTransform = (function(_super) {

  __extends(AbstractTransform, _super);

  function AbstractTransform(context) {
    AbstractTransform.__super__.constructor.call(this, context, 'transform');
  }

  AbstractTransform.prototype.preCondition = function() {
    Helper.assert(this.context.annotations != null, "empty annotations");
    this.context.annotations.forEach(function(annotation, i) {
      Helper.assert(annotation.line != null, "empty annotation" + i + ".line");
      Helper.assert(annotation.column != null, "empty annotation" + i + ".column");
      return Helper.assert(annotation.value != null, "empty annotation" + i + ".value");
    });
    Helper.assert(this.context.errors != null, "empty errors");
    return Helper.assert(this.context.content != null, "empty content");
  };

  AbstractTransform.prototype.postCondition = function() {
    return Helper.assert(this.context.content != null, "empty content");
  };

  AbstractTransform.prototype.execute = function() {
    return {
      content: this.transform(this.context.content, this.context.annotations, this.context.errors)
    };
  };

  AbstractTransform.prototype.transform = function(content, annotations, errors) {
    var lines,
      _this = this;
    lines = content.split('\n');
    annotations.forEach(function(annotation) {
      return _this.transformLine(lines, annotation);
    });
    return lines.join('\n');
  };

  AbstractTransform.prototype.transformLine = null;

  return AbstractTransform;

})(Phase);

AnnotationsTransform = (function(_super) {

  __extends(AnnotationsTransform, _super);

  function AnnotationsTransform() {
    return AnnotationsTransform.__super__.constructor.apply(this, arguments);
  }

  AnnotationsTransform.prototype.transformLine = function(lines, _arg) {
    var line, lineNo, value;
    lineNo = _arg.line, value = _arg.value;
    line = lines[lineNo];
    return lines[lineNo] = "" + line + " " + (value.join(', '));
  };

  return AnnotationsTransform;

})(AbstractTransform);

JasmineTransform = (function(_super) {

  __extends(JasmineTransform, _super);

  function JasmineTransform() {
    return JasmineTransform.__super__.constructor.apply(this, arguments);
  }

  JasmineTransform.prototype.transformLine = function(lines, _arg) {
    var columnNo, end, lineNo, match, start, value, _ref;
    value = _arg.value, lineNo = _arg.line, columnNo = _arg.column, (_ref = _arg.body, start = _ref.start, end = _ref.end);
    match = value.length > 1 ? "toContain([" + (value.join(', ')) + "])" : "toEqual(" + value[0] + ")";
    this.removeAnnotate_(lines, lineNo, columnNo);
    this.transformTo_(lines, match, end);
    return this.transformFrom_(lines, start);
  };

  JasmineTransform.prototype.removeAnnotate_ = function(lines, lineNo, columnNo) {
    var annotate, body, line, _ref;
    line = lines[lineNo];
    _ref = Helper.splitAt(line, columnNo), body = _ref[0], annotate = _ref[1];
    return lines[lineNo] = "" + body;
  };

  JasmineTransform.prototype.transformFrom_ = function(lines, _arg) {
    var before, body, columnNo, line, lineNo, _ref;
    lineNo = _arg.line, columnNo = _arg.column;
    line = lines[lineNo];
    _ref = Helper.splitAt(line, columnNo), before = _ref[0], body = _ref[1];
    return lines[lineNo] = "" + before + "expect(" + body;
  };

  JasmineTransform.prototype.transformTo_ = function(lines, match, _arg) {
    var after, body, columnNo, line, lineNo, _ref;
    lineNo = _arg.line, columnNo = _arg.column;
    line = lines[lineNo];
    _ref = Helper.splitAt(line, columnNo), body = _ref[0], after = _ref[1];
    return lines[lineNo] = "" + body + ")." + match + ";";
  };

  return JasmineTransform;

})(AbstractTransform);

exports.factory = function(context) {
  switch (context.env.mode) {
    case 'annotations':
      return new AnnotationsTransform(context);
    case 'jasmine':
      return new JasmineTransform(context);
    case 'qunit':
      return Helper.assert(false);
    default:
      return Helper.assert(false, "unknown mode=" + context.env.mode);
  }
};