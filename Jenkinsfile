retry(2) {
    node('docker-agent') {
        withEnv(['DOCKERSLAVE_HOSTNAME=localhost, DB_NAME=tango',
                 'DB_USER=tangouser, DB_PASSWORD=tangouser']) {
            stage('Install git') {
                sh '''
                sudo apt-get update
                sudo apt-get install git-core
                '''
            }
            stage('Checkout') {
                checkout([$class: 'GitSCM', branches: [[name: 'main']],
                    userRemoteConfigs: [[credentialsId: '19a98b81-ab51-4efc-8207-2561c17e545c',
                                         url: 'https://github.com/danielcanencia/ci-cd-pipeline.git']]])
            }
            stage('Configure container using ansible') {
                sh '''
                # Install ansible
                sudo apt-get install -y ansible
                
                # Specify requirements.txt paths
                export REQUIREMENTS_PATH="requirements.txt"
                export REQUIREMENTS_DEST="${HOME}/requirements.txt"
                
                # Create custom inventory to allow ansible connection to localhost
                cat << EOF > inventory
                [all]
                localhost ansible_connection=local
                EOF

                ansible-playbook -i inventory playbook.yml
                '''
            }
            stage('Build Test Docker Image') {
                sh '''
                echo "Build Test Image"
                docker build -t danielcanenciagarcia/tango_with_django-test:${BUILD_NUMBER} --target=test .
                '''
            }
            stage('Run Tests') {
                sh '''
                echo "Execute Test Modules"
                # Add input network rule $EC2_PORT:$DOCKER_PORT
                docker run --rm -p 8010:8000 danielcanenciagarcia/tango_with_django-test:${BUILD_NUMBER}
                '''
            }
            stage('Build Production Docker Image') {
                sh '''
                echo "Build Production Image"
                docker build -t danielcanenciagarcia/tango_with_django:${BUILD_NUMBER} --target=production .
                '''
            }
            stage('Publish Docker Image') {
                withCredentials([usernamePassword(credentialsId: '31403351-6de5-434c-aa39-535f9c1a1cd7',
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
    }
}
