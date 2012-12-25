// output stdout
console.log('stdout');

// basic
null;                   // =>

undefined;              // =>

'string';               // =>

'multi\nline string';   // =>

1;                      // => old value

'multi ' +              // =>
'line';                 // =>

var obj = {
    prop: 'prop'        // =>
};
obj;                    // =>
obj.prop;               // =>

// loop
for (var i = 0; i < 3; i++) {
  'loop ' + i;          // =>
}

// if
if (true) {
  'then';               // =>
} else {
  'else';               // =>
}

if (false) {
  'then';               // =>
} else {
  'else';               // =>
}

true ? 'then' : 'else'; // =>

// function
function func(arg) {
  arg;                  // =>
  return 'return value';
};

func('arg1');           // =>
func('arg2');           // =>

// >> old result1
// >> old result2
// ~> old error1
// ~> old error2
// ?> old debug1
// ?> old debug2