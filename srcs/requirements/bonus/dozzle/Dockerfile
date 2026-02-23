#  **************************************************************************  #
#                                           ::::::::    ::::::::   :::::::::   #
#    Dockerfile                           :+:    :+:  :+:    :+:  :+:          #
#                                              +:+         :+:   :+:           #
#    github.com/d-branco                    +#+         +#+      +#+#+#+       #
#                                        +#+         +#+              +#+      #
#    Created: 2026/02/22 16:36:29      #+#         #+#      +#+        #+#     #
#    Updated: 2026/02/23 13:04:11     #########  #########  ###      ###       #
#                                                             ########         #
#  **************************************************************************  #

FROM alpine:3.22

# Install curl and tar to download and extract Dozzle
RUN apk add --no-cache curl tar wget

# Download the pre-compiled Dozzle binary (linux-amd64) from GitHub releases
# Using version v8.13.14 which provides the tar.gz we expect
RUN curl -sL https://github.com/amir20/dozzle/releases/download/v8.13.14/dozzle-linux-amd64.tar.gz -o dozzle.tar.gz \
    && tar -xzf dozzle.tar.gz \
    && mv dozzle /usr/local/bin/dozzle \
    && rm dozzle.tar.gz

# Dozzle listens on port 8080 by default
EXPOSE 8080

# Run Dozzle as PID 1
ENTRYPOINT ["dozzle"]
