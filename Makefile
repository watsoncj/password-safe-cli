PATH := ./node_modules/.bin:${PATH}

.PHONY: all test clean

init:
	npm install

clean:
	rm -rf dist/
	rm -rf lib/

build:
	coffee -o lib/ -c test/setup.coffee
	coffee -o lib/ -c src/

test: clean build
	mocha lib/{,**}/*.spec.js

dist: clean init build test

publish: dist
	npm publish
