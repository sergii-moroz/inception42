COMPOSE_FILE		=	./srcs/docker-compose.yml
USER				=	smoroz

all:	up

up:
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down

%_log:
	@docker compose -f $(COMPOSE_FILE) logs $*

%_it:
	@docker compose -f $(COMPOSE_FILE) exec $* /bin/ash

clean:
	@docker compose -f $(COMPOSE_FILE) down
	@docker system prune -a -f
	@docker image prune -a -f
	@docker network prune -f

fclean: clean
	@docker volume rm mariadb wordpress
	@rm -rf /home/$(USER)/data/mariadb/*
	@rm -rf /home/$(USER)/data/wordpress/*

re: fclean all

ps:
	@docker compose -f ./srcs/docker-compose.yml ps

volume:
	@docker volume list

network:
	@docker network list

PHONY: all up down clean fclean re
