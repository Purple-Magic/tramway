#!/bin/bash

set -e

bundle install --binstubs="$BUNDLE_BIN" --gemfile=./Gemfile

cd spec/dummy && bundle exec rails db:create db:migrate
cd ../..

exec "$@"
