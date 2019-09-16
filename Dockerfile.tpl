FROM php:${PHP_VERSION}
MAINTAINER Droptica <info@droptica.com>

ENV DRUSH_8_VERSION ${DRUSH_8_VER}
ENV DRUSH_9_VERSION ${DRUSH_9_VER}
ENV COMPOSER_VERSION ${COMPOSER_VER}

# Default PHP settings
ENV PHP_TIMEZIONE UTC
ENV PHP_MAX_EXECUTION_TIME -1
ENV PHP_MAX_UPLOAD_FILE_SIZE 100G
ENV PHP_MAX_POST_SIZE 100G
ENV PHP_DISPLAY_ERRORS 1
ENV PHP_DISPLAY_STARTUP_ERRORS 1
ENV PHP_EXPOSE 0
ENV PHP_DISABLED_FUNCTIONS ""
ENV PHP_MAX_INPUT_VARS 10000
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 0
ENV PHP_MEMORY_LIMIT -1
ENV PHP_ERROR_REPORTING "E_ALL"

# Xdebug env variables
ENV XDEBUG_CONFIG "idekey=phpstorm"
ENV PHP_IDE_CONFIG "serverName=application"

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer
# Add global binary directory to PATH and make sure to re-export it
ENV PATH "/composer/vendor/bin:$PATH"
# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install packages
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y \
    acl \
    dirmngr \
    gnupg \
    python \
    python-dev \
    python-pip \
    python-yaml \
    python-setuptools \
    pkg-config \
    mysql-client \
    bash-completion \
    httrack \
    imagemagick \
    libc-client-dev \
    libkrb5-dev \
    libmemcached-dev \
    libmariadbclient-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    libbz2-dev \
    libxslt-dev \
    libldap2-dev \
    libzip-dev \
    zlib1g-dev \
    mcrypt \
    git \
    rsync \
    unzip \
    wget \
    yarn \
    zip

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-get -y update \
    && apt-get -y install ansible

# Add repo for NodeJS 8.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update
RUN apt-get install nodejs

# PHP extensions
RUN pecl install imagick mcrypt memcached${MEMCACHED_VERSION} redis${REDIS_VERSION} xdebug${XDEBUG_VERSION}
RUN docker-php-ext-enable imagick memcached redis

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) bcmath bz2 exif fileinfo gd intl imap mbstring mysqli pdo pdo_mysql soap xmlrpc zip

RUN docker-php-ext-enable opcache


#DOCKER CONSOLE
RUN pip install docker-console MySQL-python "python-dotenv[cli]"

# Custom php.ini
COPY ./configs/php.ini ${PHP_INI_DIR}/conf.d/droptica-customs.ini

# Composer
RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/bin/composer && chmod +x /usr/bin/composer
RUN mkdir /composer
RUN composer -vvv global require hirak/prestissimo 1>&2

# Symfony console
RUN wget https://symfony.com/installer -O /usr/bin/symfony && chmod +x /usr/bin/symfony

# Drush
RUN mkdir ~/drush-8 && cd ~/drush-8 && composer require drush/drush:${DRUSH_8_VERSION}

RUN mkdir ~/drush-9 && cd ~/drush-9 && composer require drush/drush:${DRUSH_9_VERSION}

ENV PATH "/root/drush-8/vendor/bin:${PATH}"

# Drupal console
RUN wget https://drupalconsole.com/installer -O /usr/bin/drupal && chmod +x /usr/bin/drupal


COPY ./configs/debug-php /usr/bin/debug-php
RUN chmod +x /usr/bin/debug-php

COPY ./configs/xdebug-php.ini $PHP_INI_DIR/conf.d/xdebug-php.ini.back

COPY ./configs/versions /usr/bin/versions
RUN chmod +x /usr/bin/versions

RUN git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
RUN printf "if [ -f \"\$HOME/.bash-git-prompt/gitprompt.sh\" ]; then \n GIT_PROMPT_ONLY_IN_REPO=1 \n  source \$HOME/.bash-git-prompt/gitprompt.sh \n fi" >> ~/.bashrc

# Create dedicated WWW user across all images
RUN useradd -u 7000 -s /bin/false -d /var/www -c "Droptica dedicated www user" dropadmin

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

COPY ./configs/entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["bash"]
