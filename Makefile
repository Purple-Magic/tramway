install:
	cd spec/dummy && rails g tramway:install

test:
	docker-compose up --build --abort-on-container-exit

rubocop:
	bundle exec rubocop -A
