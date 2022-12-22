install:
	cd spec/dummy && rails g tramway:install

test:
	cd spec/dummy && rails db:create db:migrate
	bundle exec rake

rubocop:
	bundle exec rubocop -A
