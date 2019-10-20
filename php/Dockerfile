FROM php:7.0.33-fpm-alpine3.7 AS base

WORKDIR /var/www/html

RUN set -xe \
    && apk update \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .build-dependencies freetype-dev icu-dev libffi-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libxml2-dev zlib-dev \
    && docker-php-source extract \
    && pecl install xdebug redis \
    && docker-php-ext-enable opcache redis xdebug \
    && docker-php-source delete \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install intl gd mcrypt mysqli soap xmlrpc zip \
    && cd / && rm -fr /usr/src /usr/share \
    && apk del .build-dependencies .phpize-deps \
    && rm -rf /tmp/*

RUN apk --no-cache add freetype icu libjpeg-turbo libmcrypt libpng findutils
RUN addgroup -g 1000 -S app \
    && adduser -u 1000 -S app -G app \
    && mkdir -p /var/www/moodledata \
    && chown -R app:app /var/www/moodledata

COPY --from=composer:1.9.0 /usr/bin/composer /usr/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

USER app
EXPOSE 9000
CMD ["php-fpm"]
