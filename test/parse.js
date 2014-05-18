var parser = require('../build/grammar');
var test = require('tape');

var parse = function (input, options) {
	var opts = options || {};
	return parser.parse(input, opts);
};

test('empty program', function (t) {
	t.throws(parse(''));
	t.end();
})
