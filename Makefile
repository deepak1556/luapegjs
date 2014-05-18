BIN = $(npm)
NODE ?= node
SRC = $(wildcard examples/*.lua)
EX = $(SRC:examples/%.lua=build/%.js)

build:
	@mkdir -p build
	@$(BIN)pegjs src/grammar.pegjs build/grammar.js

examples: $(EX)

build/%.js: examples/%.lua
	@$(NODE) bin/cmd.js $< -o $@

test:
	@$(BIN)tape test/*.js	

clean:
	@rm -rf build

.PHONY: test clean
