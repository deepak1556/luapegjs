BIN = ./node_modules/.bin/
NODE ?= node
TEST = $(shell find test -name "*.js")

build:
	@mkdir -p build
	@$(BIN)pegjs src/grammar.pegjs build/grammar.js

test:
	@$(NODE) $(TEST)

clean:
	@rm -rf build

.PHONY: test clean