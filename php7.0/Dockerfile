FROM php:7.0
MAINTAINER Droptica <info@droptica.com>

ENV DRUSH_VERSION 8.1.15
ENV COMPOSER_VERSION 1.4.1

# Xdebug env variables
ENV XDEBUG_CONFIG "idekey=phpstorm"
ENV PHP_IDE_CONFIG "serverName=application"

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer
# Add global binary directory to PATH and make sure to re-export it
ENV PATH "/composer/vendor/bin:$PATH"
# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y \
    python \
    python-pip \
    python-yaml \
    python-setuptools \
    pkg-config \
    mysql-client \
    bash-completion \
    imagemagick \
    libc-client-dev \
    libkrb5-dev \
    libmemcached-dev \
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
    zlib1g-dev \
    mcrypt \
    git \
    unzip \
    wget

# PHP extensions
RUN pecl install imagick memcached redis xdebug
RUN docker-php-ext-enable imagick memcached redis xdebug

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) bcmath exif fileinfo gd intl imap mbstring mcrypt mysqli pdo pdo_mysql soap xmlrpc zip

RUN docker-php-ext-enable opcache

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

#DOCKER CONSOLE
RUN pip install docker-console

RUN git config --global alias.st status; \
  git config --global alias.ci commit; \
  git config --global alias.br branch; \
  git config --global alias.co checkout; \
  git config --global alias.df diff; \
  git config --global alias.lg "log --graph --pretty=format:'%C(blue)%h %Creset%C(reverse bold blue)%d%Creset %C(white)%s %C(green bold)%cr%Creset %C(green)%aN' --abbrev-commit --decorate"; \
  git config --global alias.clear '!git add -A && git reset --hard'; \
  git config --global alias.unstage "reset HEAD --"; \
  git config --global alias.ign "ls-files -o -i --exclude-standard"; \
  git config --global alias.gitkconflict '!gitk --left-right HEAD...MERGE_HEAD'; \
  git config --global alias.alias "config --get-regexp alias"; \
  git config --global apply.whitespace error-all; \
  git config --global color.ui auto; \
  git config --global color.diff.whitespace "red reverse"; \
  git config --global color.diff.meta "magenta"; \
  git config --global color.diff.frag "yellow"; \
  git config --global color.diff.old "red"; \
  git config --global color.diff.new "green bold"; \
  git config --global color.grep.context yellow; \
  git config --global color.grep.filename blue; \
  git config --global color.grep.function "yellow bold"; \
  git config --global color.grep.linenumber "cyan bold"; \
  git config --global color.grep.match red bold; \
  git config --global color.grep.selected white; \
  git config --global color.grep.separator blue; \
  git config --global color.status.added yellow; \
  git config --global color.status.changed red; \
  git config --global color.status.untracked "cyan bold"; \
  git config --global diff.tool meld; \
  git config --global instaweb.httpd 'apache2'; \
  git config --global merge.summary true; \
  git config --global merge.tool meld;

#
# Additional scripts and settings
#

# Custom php.ini
COPY ./configs/php.ini ${PHP_INI_DIR}/conf.d/droptica-customs.ini

# Bash git prompt
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O /root/.git-prompt.sh && chmod +x /root/.git-prompt.sh

# Composer
RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/bin/composer && chmod +x /usr/bin/composer
RUN mkdir /composer

# Symfony console
RUN wget https://symfony.com/installer -O /usr/bin/symfony && chmod +x /usr/bin/symfony

# Drush
RUN wget https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar -O /usr/bin/drush && chmod +x /usr/bin/drush && drush init -y

#DRUPAL CONSOLE
RUN wget https://drupalconsole.com/installer -O /usr/bin/drupal && chmod +x /usr/bin/drupal


COPY ./configs/debug-php /usr/bin/debug-php
RUN chmod +x /usr/bin/debug-php
#COPY ../config/xdebug-php.ini $PHP_INI_DIR/conf.d/xdebug-php.ini

#COPY ../config/versions /usr/bin/versions
#RUN chmod +x /usr/bin/versions

RUN echo "source ~/.git-prompt.sh" >> /root/.bashrc
RUN echo "alias ls='ls --color=auto'" >> /root/.bashrc

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
ENTRYPOINT []
CMD ["bash"]
