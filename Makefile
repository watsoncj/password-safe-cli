PATH := ./node_modules/.bin:${PATH}

.PHONY: all test clean

dist: clean init test build

init:
	npm install
	npm link

clean:
	rm -rf dist/
	rm -rf lib/

build:
	coffee -o lib/ -c src/

test:
	mocha src/{,**}/*.spec.coffee

publish: dist
	npm publish
