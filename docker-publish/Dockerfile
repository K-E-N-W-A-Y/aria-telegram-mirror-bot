FROM node:alpine3.10

WORKDIR /bot/

RUN chmod 777 /bot

RUN apk add --no-cache --update \
      ca-certificates \
      git \
      bash \
      aria2 \
      wget \
      unzip \
      curl \
      unrar

COPY . .

RUN mv src/.constants.js.example src/.constants.js && \
    npm i -g typescript && \
    yarn && \
    tsc && \
    rm -rf src/.constants.js && \
    rm -rf out/.constants.js
