install:
	bundle
	bundle exec appraisal install
	bundle exec appraisal rake -f spec/dummy/Rakefile db:test:prepare
	lefthook install
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/

test:
	bundle exec appraisal rspec
