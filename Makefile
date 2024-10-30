up:
	@docker-compose -f srcs/docker-compose.yml up --build -d --remove-orphans

down:
	@docker-compose -f ./srcs/docker-compose.yml down -v --remove-orphans

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

clean: del_data
	@docker-compose -f ./srcs/docker-compose.yml down -v --remove-orphans
	@docker system prune -a -f
	@docker image prune -a -f
	@docker volume prune -f

del_data:
	rm -rf ./srcs/requirements/mariadb/db-data
	rm -rf ./srcs/requirements/wordpress/wp-data

re: down up
cre: down clean up

PHONY: up down re cre logs clean
