PATH := ./node_modules/.bin:${PATH}

.PHONY: all test clean

init:
	npm install

clean:
	rm -rf dist/
	rm -rf lib/

build:
	coffee -o lib/ -c src/

test: clean
	mocha src/{,**}/*.spec.coffee

dist: clean init test build

publish: dist
	npm publish
