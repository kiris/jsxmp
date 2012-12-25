// basic pattern

// support types
1.2345;        // =>
"string";      // =>
1 + 2 + 3;     // =>
new Date();    // =>
[1, 2, 3];     // =>
var obj = { foo: 1, bar: { baz: "baz" } };
obj;           // =>
null;          // =>
undefined;     // =>
Math.random(); // =>

// unsupport types
var func = function() { console.log(''); };
func;          // =>
/.+/g;         // =>
this;          // =>

// standard output
console.log('stdout');
