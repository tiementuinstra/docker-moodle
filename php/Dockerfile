FROM php:7.4-fpm-alpine3.12 AS base

WORKDIR /var/www/html

FROM base AS extensions

RUN set -xe \
    && apk update \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .build-dependencies autoconf freetype-dev icu-dev libffi-dev libjpeg-turbo-dev libmcrypt-dev libmemcached-dev libpng-dev libxml2-dev libzip-dev \
    && docker-php-source extract \
    && pecl install xdebug mcrypt-1.0.3 memcached-3.1.5 \
    && docker-php-ext-enable mcrypt memcached opcache xdebug \
    && docker-php-source delete \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) exif intl gd mysqli soap xml xmlrpc zip \
    && cd / && rm -fr /usr/src /usr/share \
    && apk del .build-dependencies .phpize-deps \
    && rm -rf /tmp/*

FROM base AS development

RUN apk --no-cache add freetype icu libjpeg-turbo libmcrypt libmemcached libpng libzip findutils
RUN addgroup -g 1000 -S app \
    && adduser -u 1000 -S app -G app \
    && mkdir -p /var/www/sitedata \
    && chown -R app:app /var/www/sitedata

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/exif.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/exif.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-exif.ini /usr/local/etc/php/conf.d/docker-php-ext-exif.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/gd.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-gd.ini /usr/local/etc/php/conf.d/docker-php-ext-gd.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/intl.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/opcache.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/opcache.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/mcrypt.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/mcrypt.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/mysqli.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/mysqli.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/memcached.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/memcached.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/soap.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/soap.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-soap.ini /usr/local/etc/php/conf.d/docker-php-ext-soap.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/sodium.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/sodium.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini

#COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so
#COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xml.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xml.so

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xmlrpc.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xmlrpc.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-xmlrpc.ini /usr/local/etc/php/conf.d/docker-php-ext-xmlrpc.ini

COPY --from=extensions /usr/local/lib/php/extensions/no-debug-non-zts-20190902/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/zip.so
COPY --from=extensions /usr/local/etc/php/conf.d/docker-php-ext-zip.ini /usr/local/etc/php/conf.d/docker-php-ext-zip.ini

COPY --from=composer:1.9.0 /usr/bin/composer /usr/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

USER app
EXPOSE 9000
CMD ["php-fpm"]
