1. Run `lefthook run pre-commit` before finishing of every task. If it returns an error, fix it and run the command again until it passes.
2. Change `README.md` when the task changes a user-visible workflow or setup step.
3. Run `bundle exec appraisal rails-8.1 bundle exec rspec` and fix failures until the suite passes.
4. Keep Tailwind classes aligned with `config/tailwind.config.js`.
5. If a Tramway change requires host application wiring or generated files to change, update the `tramway:install` generator and its specs so host apps stay in sync after installation or upgrade.
