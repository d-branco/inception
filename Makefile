#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Makefile                             :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/07 14:33:04      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/15 18:31:35     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

## Variables to load environment variables from .env file
include srcs/.env
export $(shell sed 's/=.*//' srcs/.env)

###################################################################### Targets #

all: build
	@\
	echo "$(GRAY)Status:$(RESET)			Run 'make up' to start."

build: headers
	@\
	echo "$(GRAY)Building services:$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml build && \
	echo "$(GRAY)Status:$(RESET)			Build complete."

prepare:
	@echo "$(GRAY)Creating data directories in:$(RESET) $(DATA_PATH)"
	@
	@

up: prepare
	@\
	mkdir -p $(DATA_PATH)/mariadb && \
	mkdir -p $(DATA_PATH)/wordpress && \
	echo "$(GRAY)Starting services:$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml up --detach && \
	echo "$(GRAY)Status:$(RESET)			Link https://127.0.0.1"

stop:
	@\
	echo "$(GRAY)Stopping services:$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml stop

down:
	@echo "$(GRAY)Cleaning containers:$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml down

status:
	@\
	echo "$(PURPLE)    Project Status:$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml ps ; \
	echo "\n$(GRAY)    Containers:$(RESET)" ; \
	sudo docker ps -a ; \
	echo "\n$(GRAY)    images:$(RESET)" ; \
	sudo docker image ls ; \
	echo "\n$(GRAY)    Volumes:$(RESET)" ; \
	sudo docker volume ls ; \
	echo "\n$(PURPLE)    Project network:$(RESET)" ; \
	sudo docker network ls --filter "name=inception-network" ; \
	echo "\n$(GRAY)    Networks:$(RESET)" ; \
	sudo docker network ls

logs:
	@\
	sudo docker compose -f srcs/docker-compose.yml logs -f

fclean:
	@\
	echo "$(GRAY)Full cleanup (images/volumes):$(RESET)" ; \
	sudo docker compose -f srcs/docker-compose.yml down --rmi all --volumes --remove-orphans

re: fclean all

.PHONY: all build up stop down status logs fclean re
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
