#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Makefile                             :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/07 15:27:57      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/13 09:26:42     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

###################################################################### Targets #

all: build
	@\
	echo "$(GRAY)Status:$(RESET)			Run 'make up' to start."

build: headers
	@\
	echo "$(GRAY)Building services:$(RESET)" ; \
	docker compose build && \
	echo "$(GRAY)Status:$(RESET)			Build complete."

up:
	@\
	echo "$(GRAY)Starting services:$(RESET)" ; \
	docker compose up --detach && \
	echo "$(GRAY)Status:$(RESET)			Link https://127.0.0.1"

stop:
	@\
	echo "$(GRAY)Stopping services:$(RESET)" ; \
	docker compose stop

clean:
	@\
	echo "$(GRAY)Cleaning containers:$(RESET)" ; \
	docker compose down

fclean:
	@\
	echo "$(GRAY)Full cleanup (images/volumes):$(RESET)" ; \
	docker compose down --rmi all --volumes --remove-orphans

re: fclean all

status:
	@\
	echo "$(PURPLE)Project Status:$(RESET)" ; \
	docker compose ps

shell:
	docker compose exec nginx sh

.PHONY: all build up stop clean fclean re status logs shell

####################################################################### Colors #
RESET	:= \033[0m
PURPLE	:= \033[1;35m
GRAY	:= \033[1;90m
YELLOW	:= \033[1;93m
BLUE	:= \033[1;96m

###################################################################### Headers #
headers:
	@\
	for file in $$(find . -name "Makefile"); do 							\
		if [ -f "$$file" ]; then 											\
			first_line=$$(head -n 1 "$$file"); 								\
			if [ "$$first_line" != "#  **************************************************************************  #" ]; then 			\
				echo	"#  **************************************************************************  #" > temp.txt ; 				\
				echo	"#                                           ::::::::    ::::::::   :::::::::   #" >> temp.txt ; 				\
				echo	"#    Makefile                             :+:    :+:  :+:    :+:  :+:          #" >> temp.txt ; 				\
				echo	"#                                              +:+         :+:   :+:           #" >> temp.txt ; 				\
				echo	"#    github.com/d-branco                    +#+         +#+      +#+#+#+       #" >> temp.txt ; 				\
				echo	"#                                        +#+         +#+              +#+      #" >> temp.txt ; 				\
				echo	"#    Created: $$(date '+%Y/%m/%d %H:%M:%S')      #+#         #+#      +#+        #+#     #" >> temp.txt ; 		\
				echo	"#    Updated: $$(date '+%Y/%m/%d %H:%M:%S')     #########  #########  ###      ###       #" >> temp.txt ; 		\
				echo	"#                                                             ########         #" >> temp.txt ; 				\
				echo	"#  **************************************************************************  #" >> temp.txt ; 				\
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
				echo "<!--*************************************************************************-->" > temp.txt ; 				\
				echo "<!--                                        ::::::::    ::::::::   ::::::::: -->" >> temp.txt ;				\
				printf "<!-- %-34.34s   :+:    :+:  :+:    :+:  :+:        -->\n" "$$(basename $$file)" >> temp.txt; 				\
				echo "<!--                                           +:+         :+:   :+:         -->" >> temp.txt ; 				\
				echo "<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->" >> temp.txt ; 				\
				echo "<!--                                     +#+         +#+              +#+    -->" >> temp.txt ; 				\
				echo "<!-- Created: $$(date '+%Y/%m/%d %H:%M:%S')      #+#         #+#      +#+        #+#   -->" >> temp.txt ; 	\
				echo "<!-- Updated: $$(date '+%Y/%m/%d %H:%M:%S')     #########  #########  ###      ###     -->" >> temp.txt ; 	\
				echo "<!--                                                          ########       -->" >> temp.txt ; 				\
				echo "<!--*************************************************************************-->" >> temp.txt ; 				\
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
