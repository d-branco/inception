#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Makefile                             :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/07 14:33:04      #+#         #+#      +#+        #+#     #
#    Updated: 2026/02/22 22:24:49     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

include srcs/.env
export $(shell sed 's/=.*//' srcs/.env)

###################################################################### Targets #
all: build up

build: headers
	@\
	echo "$(GRAY)Building services:$(RESET)" ; \
	docker compose -f srcs/docker-compose.yaml build && \
	echo "$(GRAY)Status:$(RESET)			Build complete."

up:
	@\
	sudo mkdir -p $(DATA_PATH)/mariadb ; \
	sudo mkdir -p $(DATA_PATH)/wordpress ; \
	sudo chmod 777 $(DATA_PATH)/mariadb ; \
	sudo chmod 777 $(DATA_PATH)/wordpress ; \
	\
	if ! grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts && \
		echo "$(GRAY)Added $(DOMAIN_NAME) to /etc/hosts$(RESET)"; \
	else \
		echo "$(GRAY)Domain $(DOMAIN_NAME) in /etc/hosts$(RESET)" ; \
	fi ; \
	\
	echo "$(GRAY)Starting services:$(RESET)" ; \
	docker compose -f srcs/docker-compose.yaml up --detach && \
	echo "$(GRAY)Status:$(RESET)			Link https://$(DOMAIN_NAME)"

stop:
	@\
	echo "$(GRAY)Stopping services:$(RESET)" ; \
	docker compose -f srcs/docker-compose.yaml stop

clean:
	@\
	echo "$(GRAY)Cleaning containers:$(RESET)" ; \
	docker compose -f srcs/docker-compose.yaml down

fclean: clean
	@\
	echo "$(GRAY)Cleaning containers, images and volumes:$(RESET)" ; \
	docker compose -f srcs/docker-compose.yaml down --rmi all --volumes --remove-orphans

oblivion: fclean
	@\
	echo "$(GRAY)Permanently deleting all docker data$(RESET)" ; \
	docker stop $$(docker ps -qa) 2>/dev/null || true ; \
	docker system prune --all --volumes --force ; \
	sudo rm -rf $(DATA_PATH) ; \
	echo "$(GRAY)Oblivion achieved.$(RESET)"

re: fclean all

status:
	@\
	echo "$(GRAY)    Containers:$(RESET)" ; \
	docker ps -a ; \
	echo "$(GRAY)    Images:$(RESET)" ; \
	docker image ls ; \
	echo "$(GRAY)    Volumes:$(RESET)" ; \
	docker volume ls ; \
	echo "$(GRAY)    Networks:$(RESET)" ; \
	docker network ls

shell:
	docker compose -f srcs/docker-compose.yaml exec nginx sh

permissions:
	sudo chown -R $$USER:$$USER ~/data_inception
	sudo chmod -R 777 ~/data_inception

bonus:
	@\
	sudo docker exec redis redis-cli ping >/dev/null 2>&1 && echo "$(BLUE) OK $(RESET)Redis" || echo "$(YELLOW)Redis FAIL$(RESET)" ; \
	lftp -c "open -u pera,roberto localhost; ls" >/dev/null 2>&1 && echo "$(BLUE) OK $(RESET)FTP" || echo "$(YELLOW)FTP FAIL$(RESET)" ; \
	curl -s -o /dev/null -w "%{http_code}" http://localhost:225 | grep -q "200" && echo "$(BLUE) OK $(RESET)Static" || echo "$(YELLOW)Static FAIL$(RESET)" ; \
	curl -s -o /dev/null -w "%{http_code}" http://localhost:8084 | grep -q "200" && echo "$(BLUE) OK $(RESET)Adminer" || echo "$(YELLOW)Adminer FAIL$(RESET)" ; \
	curl -s -o /dev/null -w "%{http_code}" http://localhost:8085 | grep -q "200" && echo "$(BLUE) OK $(RESET)Dozzle" || echo "$(YELLOW)Dozzle FAIL$(RESET)"

.PHONY: all build up stop clean fclean re status shell oblivion
###################################################################### Colors #
RESET	:= \033[0m
PURPLE	:= \033[1;35m
GRAY	:= \033[1;90m
YELLOW	:= \033[1;93m
BLUE	:= \033[1;96m

###################################################################### Headers #
headers:
	@\
	for file in $$(find . -name "Makefile" -o -name "Dockerfile" -o -name ".env"); do 		\
		if [ -f "$$file" ]; then 											\
			first_line=$$(head -n 1 "$$file"); 								\
			if [ "$$first_line" != "#  **************************************************************************  #" ]; then 		\
				echo	"#  **************************************************************************  #" > temp.txt ; 			\
				echo	"#                                           ::::::::    ::::::::   :::::::::   #" >> temp.txt ; 			\
				printf	"#    %-34.34s   :+:    :+:  :+:    :+:  :+:          #\n" "$$(basename $$file)" >> temp.txt; 				\
				echo	"#                                              +:+         :+:   :+:           #" >> temp.txt ; 			\
				echo	"#    github.com/d-branco                    +#+         +#+      +#+#+#+       #" >> temp.txt ; 			\
				echo	"#                                        +#+         +#+              +#+      #" >> temp.txt ; 			\
				echo	"#    Created: $$(date '+%Y/%m/%d %H:%M:%S')      #+#         #+#      +#+        #+#     #" >> temp.txt ; 	\
				echo	"#    Updated: $$(date '+%Y/%m/%d %H:%M:%S')     #########  #########  ###      ###       #" >> temp.txt ; 	\
				echo	"#                                                             ########         #" >> temp.txt ; 			\
				echo	"#  **************************************************************************  #" >> temp.txt ; 			\
				echo "" >> temp.txt ; 										\
				cat $$file >> temp.txt; 									\
				cat temp.txt > $$file; 										\
				rm -f temp.txt; 											\
				echo "$(GRAY)Header create:$(RESET) $$file"; 				\
			else 															\
				header_date=$$(sed -n '8p' "$$file" | 						\
					sed 's/.*Updated: \([0-9/: ]*\).*/\1/'); 				\
																			\
				header_epoch=$$(date -d "$$header_date" +%s 2>/dev/null || echo 0); \
																			\
				file_epoch=$$(stat -c %Y "$$file"); 						\
																			\
				if [ $$file_epoch -gt $$header_epoch ]; then 				\
					echo "$(GRAY)Header update:$(RESET) $$file"; 			\
					update_date=$$(date '+%Y/%m/%d %H:%M:%S'); 				\
					sed -i "8s|.*|#    Updated: $$update_date     #########  #########  ###      ###       #|" "$$file"; \
				fi; 														\
																			\
			fi; 															\
		fi; 																\
	done;																	\
																			\
	for file in $$(find . -name "*.md"); do 								\
		if [ -f "$$file" ]; then 											\
			first_line=$$(head -n 1 "$$file"); 								\
			if [ "$$first_line" != "<!--*************************************************************************-->" ]; then 		\
				echo	"<!--*************************************************************************-->" > temp.txt ; 			\
				echo	"<!--                                        ::::::::    ::::::::   ::::::::: -->" >> temp.txt ;			\
				printf	"<!-- %-34.34s   :+:    :+:  :+:    :+:  :+:        -->\n" "$$(basename $$file)" >> temp.txt; 				\
				echo	"<!--                                           +:+         :+:   :+:         -->" >> temp.txt ; 			\
				echo	"<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->" >> temp.txt ; 			\
				echo	"<!--                                     +#+         +#+              +#+    -->" >> temp.txt ; 			\
				echo	"<!-- Created: $$(date '+%Y/%m/%d %H:%M:%S')      #+#         #+#      +#+        #+#   -->" >> temp.txt ; 	\
				echo	"<!-- Updated: $$(date '+%Y/%m/%d %H:%M:%S')     #########  #########  ###      ###     -->" >> temp.txt ; 	\
				echo	"<!--                                                          ########       -->" >> temp.txt ; 			\
				echo	"<!--*************************************************************************-->" >> temp.txt ; 			\
				echo "" >> temp.txt ; 										\
				cat $$file >> temp.txt; 									\
				cat temp.txt > $$file; 										\
				rm -f temp.txt; 											\
				echo "$(GRAY)Header create:$(RESET) $$file"; 				\
			else 															\
				header_date=$$(sed -n '8p' "$$file" | 						\
					sed 's/.*Updated: \([0-9/: ]*\).*/\1/'); 				\
																			\
				header_epoch=$$(date -d "$$header_date" +%s 2>/dev/null || echo 0); \
																			\
				file_epoch=$$(stat -c %Y "$$file"); 						\
																			\
				if [ $$file_epoch -gt $$header_epoch ]; then 				\
					echo "$(GRAY)Header update:$(RESET) $$file"; 			\
					update_date=$$(date '+%Y/%m/%d %H:%M:%S'); 				\
					sed -i "8s|.*|<!-- Updated: $$update_date     #########  #########  ###      ###     -->|" "$$file"; \
				fi; 														\
																			\
			fi; 															\
		fi; 																\
	done
