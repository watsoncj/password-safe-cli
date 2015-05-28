PATH := ./node_modules/.bin:${PATH}

.PHONY: all test clean

init:
	npm install

clean:
	rm -rf dist/

build:
	coffee -o lib/ -c test/setup.coffee
	coffee -o lib/ -c src/

test:
	mocha lib/*Spec.js

dist: clean init build test

publish: dist
	npm publish
