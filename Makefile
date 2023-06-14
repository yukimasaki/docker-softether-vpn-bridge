up:
	docker compose up -d --build
attach:
	docker attach sebridge
stop:
	docker stop $(docker ps -aq)
rm:
	docker rm $(docker ps -aq)
rmi:
	docker rmi $(docker images -aq)