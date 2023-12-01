node {
    stage('Checkout') {
        checkout scm
    }
    stage('Provision docker slave container') {
        cd terraform
        terraform init && terraform apply
    }


    stage('Destroy created resources') {
        terraform destroy
    }
}

node('dockerSlave') {
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stage('Checkout') {
        // Clone the specific revision who triggers this pipeline
        // checkout scm

        checkout([$class: 'GitSCM', branches: [[name: 'jenkins-pipeline']],
            userRemoteConfigs: [[credentialsId: '036a1b28-48ee-4c59-8ab1-388370a0e8d6',
                                 url: 'https://github.com/danielcanencia/ci-cd-pipeline.git']]])
    }
    stage('Build Test') {
        sh '''
        echo "Build Test Image"
        docker build -t danielcanenciagarcia/tango_with_django-test:${BUILD_NUMBER} --target=test .
        '''
    }
    stage('Tests') {
        sh '''
        echo "Execute Test Modules"
        docker run --rm -p 8010:8000 danielcanenciagarcia/tango_with_django-test:${BUILD_NUMBER}
        '''
    }
    stage('Build Production') {
        sh '''
        echo "Build Production Image"
        docker build -t danielcanenciagarcia/tango_with_django:${BUILD_NUMBER} --target=production .
        '''
    }
    stage('Publish Image') {
        withCredentials([usernamePassword(credentialsId: 'dockerHub',
                         usernameVariable: 'DOCKER_USERNAME',
                         passwordVariable: 'DOCKER_PASSWORD')]) {
            sh '''
            echo "Publish image to DockerHub"
            docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
            docker push danielcanenciagarcia/tango_with_django:${BUILD_NUMBER}
            '''
        }
    }
}
