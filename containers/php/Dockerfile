ARG ARG_PHP_VERSION=${ARG_PHP_VERSION}
FROM php:${ARG_PHP_VERSION}

# clean up before injecting data and create the log directory junction
RUN rm -rf /etc/apache2/sites-available/*

# copy everything from data to container root
COPY data /

# user creation
ARG ARG_USER_ID=${ARG_USER_ID}
ARG ARG_GROUP_ID=${ARG_GROUP_ID}
RUN if ! getent group ${ARG_GROUP_ID} &> /dev/null; then groupadd -g ${ARG_GROUP_ID} development; fi \
 && useradd -u ${ARG_USER_ID} -g ${ARG_GROUP_ID} -G 100,27,33 -m -d /home/development -s /bin/bash development \
 && echo 'development:development' | chpasswd

# install a sane shell
RUN apt-get update \
 && apt-get install -y --no-install-recommends bash \
 && rm -f /bin/sh \
 && ln -s /bin/bash /bin/sh

# gitting guud
RUN apt-get update \
 && apt-get install -y git zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install required modules
ARG ARG_PHP_MODULES=${ARG_PHP_MODULES}
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions \
 && sync \
 && install-php-extensions ${ARG_PHP_MODULES}

# set apache user to system user
RUN echo "export APACHE_RUN_USER=development"  >> /etc/apache2/envvars \
 && echo "export APACHE_RUN_GROUP=development" >> /etc/apache2/envvars \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
 && chown -R development:development /var/www \
 && chmod -R 2774 /var/www

EXPOSE 443

RUN a2enmodconflist
