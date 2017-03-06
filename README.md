# Apache and php on docker tailored for Drupal/Wordpress

## Tags
- `php7`, `latest`,
- `php5`, 

## Installation / Usage

1. Install the `droptica/php-developer` container:

    ``` sh
    $ docker pull droptica/php-developer
    ```

  Alternatively, pull a specific version of `droptica/php-developer`:
    ``` sh
    $ docker pull droptica/php-developer:php5
    ```
    
2. Download drupal to a folder of your choosing    

3. Run the containter
    ```sh
    $ docker run -v /my-folder/with-project:/app droptica/php-developer
    ```
    and you are in the folder with your project and have composer and drush. 
    Of course to use drush you have to have access to the database.
    ```sh
    $ docker run -v /my-folder/with-project:/app --link mysql:mysql droptica/php-developer 
    ```