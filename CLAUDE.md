1. Run `lefthook run pre-commit` before finishing of every task. In case it returns an error, fix it and run the command again until it returns no errors.
2. Change `README.md` file for every task when it is needed. It should contain a description of changed or added functionality, and instructions on how to use it if needed.
3. Run `bundle exec appraisal rails-8.1 bundle exec rspec` to check that all tests are passing. If there are any failing tests, fix them and run the command again until all tests are passing. Do not run tests without appraisal.
4. Everytime you use tailwind classes, make sure there are present inside the `config/tailwind.config.js` file.
5. Do not use `rubocop:disable` or `rubocop:enable` comments to silence offenses. Fix the underlying code, split methods or classes when needed, and keep the linters green without bypasses.
6. Commit every time you change something (after `lefthook run pre-commit` and the test suite pass). Create a new commit per logical change instead of batching unrelated changes together.

@.agents/create-instruction.md
@.agents/infra-dependent-features.md
@.agents/releases.md
