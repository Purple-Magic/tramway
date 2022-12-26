test:
	docker-compose up --build --abort-on-container-exit

rubocop:
	docker pull kalashnikovisme/docker-rubocop:ruby-2.7.7
	docker run --rm --volume "${PWD}:/app" kalashnikovisme/docker-rubocop:ruby-2.7.7
