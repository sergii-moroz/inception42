COMPOSE_FILE		=	./srcs/docker-compose.yml
USER				=	smoroz

all:	up

up:
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down

%_log:
	docker compose -f $(COMPOSE_FILE) logs $*

%_it:
	docker compose -f $(COMPOSE_FILE) exec $* /bin/ash

clean:
	@docker compose -f $(COMPOSE_FILE) down
	@docker system prune -a -f
	@docker image prune -a -f
	@docker volume prune -f

fclean: clean
	rm -rf /home/$(USER)/data/mariadb
	rm -rf /home/$(USER)/data/wordpress

re: fclean all

ps:
	@docker compose -f ./srcs/docker-compose.yml ps

# pass:
# 	if [ ! -d "secrets2" ]; then
# 		mkdir secrets
# 		LC_ALL=C tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10 > ./secrets2/db_root_password.txt
# 		LC_ALL=C tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10 > ./secrets2/wp_admin_password.txt
# 		LC_ALL=C tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10 > ./secrets2/wp_user_password.txt
# 	fi

PHONY: all up down clean fclean re
