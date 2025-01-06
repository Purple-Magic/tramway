install:
	bundle
	bundle exec appraisal install
	lefthook install
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/

test:
	bundle exec appraisal rspec
