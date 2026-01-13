#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/13 09:59:26      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/13 14:54:46     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

RUN apk update && \
    apk add --no-cache nginx && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /run/nginx
COPY html/ /var/www/html/
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
