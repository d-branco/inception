#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/01/20 16:32:35      #+#         #+#      +#+        #+#     #
#    Updated: 2026/01/24 13:10:14     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

EXPOSE 80

RUN apk update && apk upgrade && \
    apk add --no-cache --purge -uU \
        apache2 \
        php83-apache2 \
        acl \
        curl \
        bzip2 \
        gzip \
        php83-session \
        php83-bz2 \
        php83-mysqli \
        php83-mysqlnd \
        php83-pgsql \
        php83-pdo_pgsql \
        php83-sqlite3 \
        php83-pdo_sqlite \
        php83-zip \
        sqlite \
        unzip \
        xz 

RUN rm -f /var/www/localhost/htdocs/index.html

COPY --chmod=644 index.php /var/www/localhost/htdocs/index.php

CMD ["httpd", "-D", "FOREGROUND"]
