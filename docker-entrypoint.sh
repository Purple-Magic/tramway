#!/bin/bash

set -e

bundle install --binstubs="$BUNDLE_BIN" --gemfile=./Gemfile

cd spec/dummy
bundle exec rails db:create
bundle exec rails g tramway:install
bundle exec rails db:migrate
cd ../..

exec "$@"
