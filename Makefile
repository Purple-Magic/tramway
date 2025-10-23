install:
	bundle
	bundle exec appraisal install
	bundle exec ruby bin/prepare_dummy_test_db
	lefthook install
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/

test:
	bundle exec appraisal rspec
