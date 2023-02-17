test:
	docker-compose up --build --abort-on-container-exit

rubocop:
	docker pull kalashnikovisme/docker-rubocop:ruby-3.2.1
	docker run --rm --volume "${PWD}:/app" kalashnikovisme/docker-rubocop:ruby-3.2.1

attach:
	sh ./docker_attach_web_container.sh
