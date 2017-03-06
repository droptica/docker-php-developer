build: build-base

test: build test-base test-xdebug test-xhprof

build-base:
	docker build -t droptica/php-developer:php7 base --no-cache
	docker build -t droptica/php-developer:php5 base/php5 --no-cache

test-base:
	@echo "test pase PHP 7.0"
	@./tests.py 'droptica/php-developer:php7' 'php' 'PHP 7.0'
	@./tests.py 'droptica/php-developer:php7' 'apache2' 'apache2'
	@echo "build pase PHP 5.6"
	@./tests.py 'droptica/php-developer:php5' 'php' 'PHP 5.6'
	@./tests.py 'droptica/php-developer:php5' 'apache2' 'apache2'
