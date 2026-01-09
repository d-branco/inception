#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Makefile                             :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/07 15:27:57      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/09 17:33:48     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

IMAGE_NAME		:= playground-nginx
CONTAINER_NAME	:= playground-nginx-container
PORT			:= 8080

###################################################################### Targets #
all: build run
	@echo "$(GRAY)Status:$(RESET)			All done." 

build: headers
	@\
	echo "$(GRAY)Building image:$(RESET)	$(IMAGE_NAME)" ; \
	docker build --tag $(IMAGE_NAME) . && \
	echo "$(GRAY)Image built:$(RESET)	$(IMAGE_NAME)"

run:
	@\
	echo "$(GRAY)Starting:$(RESET)		$(CONTAINER_NAME)" ; \
	docker run --detach --name $(CONTAINER_NAME) --publish $(PORT):443 $(IMAGE_NAME) && \
	echo "$(GRAY)Container:$(RESET)		Started" ;\
	echo "$(GRAY)Available:$(RESET)		http://127.0.0.1:$(PORT)" 

stop:
	@\
	echo "$(GRAY)Stopping:$(RESET)		$(CONTAINER_NAME)" ; \
	docker stop $(CONTAINER_NAME) 2>/dev/null && \
	echo "$(GRAY)Status:$(RESET)			Container stopped"

clean: stop
	@\
	echo "$(GRAY)Removing:$(RESET)		$(CONTAINER_NAME)" ; \
	docker rm $(CONTAINER_NAME) 2>/dev/null && \
	echo "$(GRAY)Status:$(RESET)			Container removed"

fclean: clean
	@\
	echo "$(GRAY)Removing image:$(RESET)	$(IMAGE_NAME)" ; \
	docker rmi $(IMAGE_NAME) 2>/dev/null && \
	echo "$(GRAY)Status:$(RESET)			Image removed"

re: fclean all

status:
	@\
	echo "$(PURPLE)Status:$(RESET)			$(CONTAINER_NAME)" ; \
	docker ps -a | grep $(CONTAINER_NAME) || echo "Container not found"

restart: stop all

.PHONY: all build run stop clean fclean re status restart

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
			if [ "$$first_line" != "<!--*************************************************************************-->" ]; then 	\
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
