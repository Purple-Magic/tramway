1. Run `lefthook run pre-commit` before finishing of every task. In case it returns an error, fix it and run the command again until it returns no errors.
2. Change README.md file for every task when it is needed. It should contain a description of changed or added functionality, and instructions on how to use it if needed.
3. Run `bundle exec appraisal rails-8.1 bundle exec rspec` to check that all tests are passing. If there are any failing tests, fix them and run the command again until all tests are passing. Do not run tests without appraisal.
4. Everytime you use tailwind classes, make sure there are present inside the config/tailwind.config.js file.
