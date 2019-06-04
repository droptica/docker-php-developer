node {
    def php56
    def php56_tag
    def php70
    def php70_tag
    def php71
    def php71_tag
    def php72
    def php72_tag
    def php73
    def php73_tag

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        withEnv(['DRUSH_9_VER=9.6.2', 'DRUSH_8_VER=8.2.3', 'COMPOSER_VER=1.8.5']) {

            withEnv(['PHP_VERSION=5.6', 'MEMCACHED_VERSION=-2.2.0', 'XDEBUG_VERSION=-2.5.5']) {
                sh 'envsubst \'${PHP_VERSION},${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER},${MEMCACHED_VERSION},${XDEBUG_VERSION}\' < Dockerfile.tpl > Dockerfile'
                sh 'cat Dockerfile'
                php56 = docker.build("droptica/php-dev:5.6-${env.BUILD_ID}", "--no-cache -f ./Dockerfile .")
            }

            withEnv(['PHP_VERSION=7.0']) {
                sh 'envsubst \'${PHP_VERSION},${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER}\' < Dockerfile.tpl > Dockerfile'
                php70 = docker.build("droptica/php-dev:7.0-${env.BUILD_ID}", "--no-cache -f ./Dockerfile .")
            }

            withEnv(['PHP_VERSION=7.1']) {
                sh 'envsubst \'${PHP_VERSION},${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER}\' < Dockerfile.tpl > Dockerfile'
                php71 = docker.build("droptica/php-dev:7.1-${env.BUILD_ID}", "--no-cache -f ./Dockerfile .")
            }

            withEnv(['PHP_VERSION=7.2']) {
                sh 'envsubst \'${PHP_VERSION},${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER}\' < Dockerfile.tpl > Dockerfile'
                php72 = docker.build("droptica/php-dev:7.2-${env.BUILD_ID}", "--no-cache -f ./Dockerfile .")
            }

            withEnv(['PHP_VERSION=7.3']) {
                sh 'envsubst \'${PHP_VERSION},${DRUSH_9_VER},${DRUSH_8_VER},${COMPOSER_VER}\' < Dockerfile.tpl > Dockerfile'
                php73 = docker.build("droptica/php-dev:7.3-${env.BUILD_ID}", "--no-cache -f ./Dockerfile .")
            }

        }
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */


        for (img in [ php56, php70, php71, php72, php73 ]) {
            img.inside {
                sh "echo 'Container available: ${img.id}'"
                sh 'php -r "echo \'PHP is available\';"'
                sh 'php --version'
            }
        }
    }

    stage('Set tags') {

        php56.inside{
            php56_tag = sh (
                script: 'php --version',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
        }

        php70.inside{
            php70_tag = sh (
                script: 'php --version',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
        }

        php71.inside{
            php71_tag = sh (
                script: 'php --version',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
        }

        php72.inside{
            php72_tag = sh (
                script: 'php --version',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
        }

        php73.inside{
            php73_tag = sh (
                script: 'php --version',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'hub.docker.com') {
            echo "Push: ${php56_tag}"
            php56.push("${php56_tag}")
            php56.push("5.6")

            echo "Push: ${php70_tag}"
            php70.push("${php70_tag}")
            php70.push("7.0")

            echo "Push: ${php71_tag}"
            php71.push("${php71_tag}")
            php71.push("7.1")

            echo "Push: ${php72_tag}"
            php72.push("${php72_tag}")
            php72.push("7.2")

            echo "Push: ${php73_tag}"
            php73.push("${php73_tag}")
            php73.push("7.3")
        }
    }
}
