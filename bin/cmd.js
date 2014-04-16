#!/usr/bin/env node

var fs = require('fs');
var escodegen = require('escodegen');

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

var output = process.stderr;
if (argv.o === '-' || argv.o === '@1') {
	output = process.stdout;
}else if (argv.o && argv.o !== '@2') {
	output = fs.createWriteStream(argv.o);
}

var input = fs.readFileSync(argv._[0], 'utf-8');

var ast = parser.parse(input);
var js = escodegen.generate(ast);

if (argv.ast) {
	process.stdout.write(ast);
}

if (argv.o) {
	output.write(js);
}

process.on('exit', function (code) {
	if (code === 0) return;
	process.exit(1);
});