build: build-base

test: build test-base

build-base:
	docker build -t droptica/php-developer:php7 base
	docker build -t droptica/php-developer:php5 base/php5

test-base:
	@echo "test pase PHP 7.0"
	@./tests.py 'droptica/php-developer:php7' 'php' 'PHP 7.0'
	@./tests.py 'droptica/php-developer:php7' 'php-extension' 'xdebug'
	@echo "build pase PHP 5.6"
	@./tests.py 'droptica/php-developer:php5' 'php' 'PHP 5.6'
	@./tests.py 'droptica/php-developer:php7' 'php-extension' 'xdebug'
