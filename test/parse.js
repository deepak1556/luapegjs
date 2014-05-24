var parser = require('../build/grammar');
var test = require('tape');
var rocambole = require('rocambole');

var parse = function (input, options) {
	var opts = options || {};
	return parser.parse(input, opts);
};

test('empty program', function (t) {
	t.throws(parse(''));
	t.end();
})

test('parse functions', function (t) {
	var ast = parse("v()");
	rocambole.recursive(ast, function (node) {
		if (node.type == "CallExpression") {
			t.equal(node.callee.name, 'v');
		}
	});
	t.end();
})
