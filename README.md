luapegjs
========

Lua2Js [WIP] . It uses [Peg.js](https://github.com/dmajda/pegjs) to generate Mozilla parser compatible AST which is transformed to JS via [escodegen](https://github.com/Constellation/escodegen)

## Usage

```
usage: luapegjs OPTIONS

OPTIONS are:

  -t, --ast

    Print AST to stdout

  -c, --compress

    Minify the JS ouput using uglify-js

  -o FILE, --output FILE

    Print generated JS data to FILE. USE "@2" for stderr and 
    "@1" or "-" for stdout.
```

To build the parser

```
make build
```

Or To build examples

```
make examples
```

## What has been implemented

* `+`, `-`, `*`, `/`, `=`, `>=`, `<=`, `!=`, `>`, `<`
*  `local`
*  `--` comments
*  `if else` statment
*  `function` partial done
