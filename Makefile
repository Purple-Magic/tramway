install:
	bundle
	bundle exec appraisal install
	lefthook install
	bundle exec appraisal rspec
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/
