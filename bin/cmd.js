#!/usr/bin/env node

var fs = require('fs');
var through = require('through');

var minimist = require('minimist');
var argv = minimist(process.argv.slice(2), {
	boolean: [ 't', 'c' ],
	alias: { o: 'output', t: 'ast', c: 'compress' },
	default: { t: false, c: false }
});

if (argv.h || argv.help) {
	fs.createReadStream(__dirname + '/usage.txt').pipe(process.stdout);
	return;
}

var parser = require('../build/grammar');
/* Can wait till i get to point of using escodegen
var output = process.stderr;
if (argv.o === '-' || argv.o === '@1') {
	output = process.stdout;
}else if (argv.o && argv.o !== '@2') {
	output = fs.createWriteStream(argv.o);
}
*/
var input = fs.readFileSync(argv._[0], 'utf-8');

if (argv.ast) {
	var ast = parser.parse(input);
	process.stdout.write(ast);
}

process.on('exit', function (code) {
	if (code === 0) return;
	process.exit(1);
});