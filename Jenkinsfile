def php71
def php71_tag
def php72
def php72_tag
def php73
def php73_tag

pipeline {

  agent any

  options {
    ansiColor('xterm')
  }

  stages {
    stage('Clone repository') {
      steps {
        checkout scm
      }
    }

    stage('Build image') {
      steps {
        script {
          withEnv(['DRUSH_9_VER=9.6.2', 'DRUSH_8_VER=8.2.3', 'COMPOSER_VER=1.8.5', 'REDIS_VERSION="-4.3.0"']) {

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
      }
    }

    stage('Test image') {
      steps {
        script {
          for (img in [ php71, php72, php73 ]) {
            img.inside {
                sh "echo 'Container available: ${img.id}'"
                sh 'php -r "echo \'PHP is available\';"'
                sh 'php --version'
            }
          }
        }
      }
    }

    stage('Set tags') {
      steps {
        script {
          php71.inside{
            php71_tag = sh (
                script: 'php --version 2>&1 | grep -v Warn',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
          }

          php72.inside{
            php72_tag = sh (
                script: 'php --version 2>&1 | grep -v Warn',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
          }

          php73.inside{
            php73_tag = sh (
                script: 'php --version 2>&1 | grep -v Warn',
                returnStdout: true
            ).trim().replaceAll('PHP ', '').split(' ')[0]
          }
        }
      }
    }

    stage('Push image') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'hub.docker.com') {

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
    }
  }

  post {
    failure {
      echo 'Build was finished with failure'
      slackSend channel: '#monitoring', color: '#e04343', iconEmoji: '', message: "${JOB_NAME} - #${BUILD_NUMBER} (<${BUILD_URL}|View Job>) \n\n Image build failed", tokenCredentialId: 'slack-key', username: ''
    }
  }
}
