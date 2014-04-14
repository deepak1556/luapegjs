{
    function partition(n, coll) {
      if (coll.length % n !== 0) {
        throw Error('Uneven number of elements.');
      }

      if (coll.length === 0) {
        return [];
      }

      return [coll.slice(0, n)].concat(partition(n, coll.slice(n)));
    }

    function processCallExpression(s) {
      var callee = first(s),
          args = rest(s);

      args = map(function(s) {
        if (s.expression && s.expression.type === 'CallExpression') {
          return s.expression;
        } else {
          return s;
        }
      }, args);

      return {
        type: 'ExpressionStatement',
        expression: {
          type: 'CallExpression',
          callee: callee,
          'arguments': args
        }
      };
    }

    function genericArithmeticOperation(operator) {
      return function(s) {
        if (s.length === 2) {
          return {
            type: 'BinaryExpression',
            operator: operator,
            left: first(s),
            right: first(rest(s))
          };
        }

        if (s.length === 1) {
          return first(s);
        }

        return {
          type: 'BinaryExpression',
          operator: operator,
          left: first(s),
          right: genericArithmeticOperation(operator)(rest(s))
        };
      };
    }

    var builtins = {
      '+': genericArithmeticOperation('+'),
      '-': genericArithmeticOperation('-'),
      '*': genericArithmeticOperation('*'),
      '/': genericArithmeticOperation('/'),
      'local': function(s) {
        var args = partition(2, first(s).elements),
            exprs = rest(s),
            body = [];
        body.push({
          type: 'VariableDeclaration',
          declarations: map(makeDeclaration, args),
          kind: 'var'
        });

        if (exprs.length > 1) {
          var initial = init(exprs);
          for (var i = 0; i < initial.length; i++) {
            body.push(initial[i])
          }
        }

        body.push({
          type: 'ReturnStatement',
          argument: last(exprs)[0].expression
        });

        return {
          type: 'CallExpression',
          callee: {
            type: 'FunctionExpression',
            id: null,
            params: [],
            body: {
              type: 'BlockStatement',
              body: body
            }
          },
          'arguments': []
        };
      }
    };

    function makeDeclaration(s) {
      var name = s[0],
          value = s[1];

      return {
        type: 'VariableDeclarator',
        id: name,
        init: value.expression ? value.expression : value
      };
    }

    function makeStr(s) {
      return map(function(i) {
        return i[1];
      }, n).join("");
    }

    function map(fn, arr) {
      var result = [];

      for (var i = 0; i < arr.length; i++) {
        result.push(fn(arr[i]));
      }

      return result;
    }

	function numberify(n) {
	  return parseInt(n.join(""), 10);
	}

	function first(a) {
	  if (a.length > 0) {
	    return a[0];
	  } else {
	    return null;
	  }
	}

	function init(a) {
	  return a.slice(0, -1);
	}

	function rest(a) {
	  return a.slice(1);
	}

	function returnStatement(a) {
	  s = first(a);
	  return [{
	    type: 'ReturnStatement',
	    argument: s.expression ? s.expression : s
	  }];
	}

	function last(a) {
	  return a.slice(-1);
	}
}

program = 
    _ s:sexp+ "\n"* { return {
        type: 'Program',
        body: s
    };}

sexp = 
    _ a:atom _ { return a; }
  / _ l:list _ { return l; }

atom = 
    d:[0-9]+ _ { return {type: 'Literal', value: numberify(d)}; }
  / '"' d:(!'"' sourcechar)* '"' _ { return {type: 'Literal', value: makeStr(d) }} 
  / s:[-+/*_<>a-zA-Z\.!]+ _ { return {type: 'Identifier', name: s.join("")}; }

list = 
    _ "(" s:sexp+ ")" _ {
        if (first(s).name === 'function') {
            return {
                type: 'FunctionExpression',
                id: null,
                params: s[1].elements ? s[1].elements : s[1],
                body: {
                    type: 'BlockStatement',
                    body: init(rest(rest(s))).concat(returnStatement(last(rest(s))))
                }
            };
        }

        if (Object.keys(builtins).indexOf(first(s).name) > -1) {
            return builtins[first(s).name](rest(s));
        }

        return processCallExpression(s);
    }

sourcechar = 
    .    

comment =
    "--" s:(!"\n" sourcechar)* "\n"

__ =
    [\n, ]

_ = 
    (__ / comment)*