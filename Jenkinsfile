pipeline {
    agent any
    environment {
        EC2INSTANCEDEV = 'ec2-user@44.201.56.64'
        EC2INSTANCETEST = 'ec2-user@44.203.20.13'
        EC2INSTANCEPROD = 'ec2-user@34.201.35.162'
        APPNAME = 'grupo2'
        REGISTRY = 'luisman10'
        DOCKER_HUB_LOGIN = credentials('docker-grupo2')
    }

    stages {
        stage('Init') {
            steps {
                echo 'Stage Init'
            }
        }
        stage('Test') {
            steps {
                echo 'Stage Init'
            }
        }

        stage('Build') {
             steps {
                echo 'Stage Build'
                sh 'docker build -t ${APPNAME}:${BUILD_NUMBER} .'
                sh 'docker tag ${APPNAME}:${BUILD_NUMBER} ${REGISTRY}/${APPNAME}:${BUILD_NUMBER}'
                    }
                }
            
        stage('Push to Registry') {
            steps {
                echo 'Stage Push'
                sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                sh 'docker push ${REGISTRY}/${APPNAME}:${BUILD_NUMBER}'
                echo 'finish'    
            }
        }

        stage('Deploy') {
            steps {
                echo 'Stage Deploy'
                sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
                sh ("sed -i -- 's/APPNAME/$APPNAME/g' docker-compose.yml")
                sh ("sed -i -- 's/TAG/$BUILD_NUMBER/g' docker-compose.yml")
                sshagent(['ssh-ec2']){
                 sh 'scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2INSTANCEDEV}:/home/ec2-user' 
                 sh 'ssh ${EC2INSTANCEDEV} ls -lrt'
                 sh 'ssh ${EC2INSTANCEDEV} docker-compose up -d'
                }
            }
        }
    }
}