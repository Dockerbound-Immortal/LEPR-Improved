FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN apk update apk add --no-cache \
    curl \
    vim \
    wget \
    bash \
    libonig-dev \
    libqd-dev \
    libpq-dev \
    pdo_mysqli

RUN set -ex \
    && apk --no-cache add \
    postgresql-dev

RUN apk --no-cache --update --repository http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/ add \
    autoconf \
    build-base \
    ca-certificates 

RUN apk --no-cache --update --repository http://dl-3.alpinelinux.org/alpine/v3.5/main/ add \
    curl \
    openssl \
    openssl-dev \
    libtool \
    icu \
    icu-libs \
    icu-dev \
    libwebp \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    imagemagick-dev \
    imagemagick 

RUN apk --no-cache --update --repository http://dl-3.alpinelinux.org/alpine/v3.5/community/ add \
    php7-gd \
    php7-sockets \
    php7-zlib \
    php7-intl \
    php7-opcache \
    php7-bcmath 

RUN docker-php-ext-configure intl \
    && docker-php-ext-configure gd 

RUN  docker-php-ext-install \
     pdo \
     pdo_pgsql \
     pgsql \
     mysqli \
     pdo_mysql \
     sockets \
     opcache \
     bcmath \
     && apk --no-cache add pcre-dev ${PHPIZE_DEPS} \ 
     && pecl install \
     xdebug \ 
     pgsql 
  
RUN docker-php-ext-enable \
  xdebug \
  pdo \
  pdo_pgsql \
  pgsql \
  mysqli \
  pdo_mysql \
  && apk del pcre-dev ${PHPIZE_DEPS}

CMD ["php-fpm"]