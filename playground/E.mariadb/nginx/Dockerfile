#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/13 09:59:26      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/17 11:01:59     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

RUN apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=PT/ST=Porto/L=Porto/O=42/OU=42Porto/CN=abessa-m.42.fr"

	RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
