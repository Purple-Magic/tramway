install:
	bundle install
	bundle exec appraisal install
	bundle exec appraisal rails -C spec/dummy db:prepare
	lefthook install
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/

test:
	bundle exec appraisal rspec
