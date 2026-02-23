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

RUN apk update && apk upgrade && \
    apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-phar \
    php83-iconv \
    php83-mbstring \
    php83-tokenizer \
    php83-ctype \
    php83-session \
    php83-dom \
    php83-xml \
    php83-zip \
    php83-curl \
    php83-pecl-redis \
    redis \
    mariadb-client \
    curl \
    unzip


# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM
RUN mkdir -p /var/www/html /run/php && \
    adduser -u 82 -D -S -G www-data www-data && \
    chown -R www-data:www-data /var/www/html /run/php

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
