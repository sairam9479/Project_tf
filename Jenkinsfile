pipeline {
       agent any
        stages {
                stage ('build') {
                   steps{
                     sh 'mvn dependency:purge-local-repository -DactTransitively=false -DreResolve=false'
                     sh 'mvn versions:set -DnewVersion=2.5.${BUILD_NUMBER}'
                     sh 'mvn clean install -Dlicense.skip -DskipTests'
                    }
                }
                stage ('test') {
                   steps{
                      sh 'mvn surefire-report:report-only -Daggregate=true -Dlicense.skip'
                    }
                }
                stage ('docker build & push') {
                  steps{
                     sh "mvn clean pre-integration-test -DskipTests -Dlicense.skip -Ppush-docker-image -Ddockerfile.skip=false -Ddocker.repo=sairam/project"
                     sh 'docker system prune -af'
                     deleteDir()
                    }
                }

        }
}
