FROM httpd:2.4.41-alpine

RUN apk --no-cache add openssl
COPY generate-ssl.sh /root

RUN ash /root/generate-ssl.sh \
  && chmod 600 /usr/local/apache2/conf/server.key /usr/local/apache2/conf/server.crt

# Enable some Apache modules
RUN sed -i '/LoadModule deflate_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule proxy_fcgi_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule proxy_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule socache_shmcb_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule ssl_module/s/^#//g' /usr/local/apache2/conf/httpd.conf; \
 sed -i '/LoadModule slotmem_shm_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy apache vhost file & common config
COPY default.vhost.conf /usr/local/apache2/conf/default.vhost.conf
COPY common.conf /usr/local/apache2/conf/common.conf

# Add default.vhost.conf as last line in httpd.conf
RUN echo "Include /usr/local/apache2/conf/default.vhost.conf" >> /usr/local/apache2/conf/httpd.conf
