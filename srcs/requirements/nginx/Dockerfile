#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/13 09:59:26      #+#         #+#      +#+        #+#     #
#    Updated: 2026/02/23 13:04:11     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

RUN apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
