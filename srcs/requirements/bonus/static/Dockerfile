#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/02/22 15:15:48      #+#         #+#      +#+        #+#     #
#    Updated: 2026/02/22 15:30:45     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

RUN apk update && apk add --no-cache python3

WORKDIR /var/www/static
COPY html/ /var/www/static/

# Entrypoint script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/setup.sh"]
