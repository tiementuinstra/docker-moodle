FROM php:7.2.23-fpm-alpine3.10 AS base

WORKDIR /var/www/html

FROM base AS extensions

RUN set -xe \
    && apk update \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .build-dependencies curl-dev freetype-dev icu-dev libffi-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libxml2-dev zlib-dev \
    && docker-php-source extract \
    && pecl install xdebug redis mcrypt-1.0.1 \
    && docker-php-ext-enable opcache mcrypt redis xdebug \
    && docker-php-source delete \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) curl intl gd mysqli soap xml xmlrpc zip \
    && cd / && rm -fr /usr/src /usr/share \
    && apk del .build-dependencies .phpize-deps \
    && rm -rf /tmp/*


FROM base AS development

RUN apk --no-cache add freetype icu libjpeg-turbo libmcrypt libpng findutils
RUN addgroup -g 1000 -S app \
    && adduser -u 1000 -S app -G app \
    && mkdir -p /var/www/moodledata \
    && chown -R app:app /var/www/moodledata

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/curl.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/curl.so

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/gd.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-gd.ini /usr/local/etc/php/conf.d/docker-php-ext-gd.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/intl.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/opcache.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/opcache.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mcrypt.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mcrypt.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mysqli.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mysqli.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/redis.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/redis.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-redis.ini /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/soap.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/soap.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-soap.ini /usr/local/etc/php/conf.d/docker-php-ext-soap.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/sodium.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/sodium.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini

#COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so
#COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xml.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xml.so

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xmlrpc.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xmlrpc.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-xmlrpc.ini /usr/local/etc/php/conf.d/docker-php-ext-xmlrpc.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-zip.ini /usr/local/etc/php/conf.d/docker-php-ext-zip.ini

COPY --from=composer:1.9.0 /usr/bin/composer /usr/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

USER app
EXPOSE 9000
CMD ["php-fpm"]
