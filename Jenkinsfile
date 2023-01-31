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
            agent{
            docker {
                image 'node:erbium-alpine'
                args '-u root:root'
                }
            }
            steps {
                echo 'Stage Init'
                sh 'npm install'
            }
        }
        stage('Test') {
            agent{
                docker {
                    image 'node:erbium-alpine'
                    args '-u root:root'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                sh 'npm run test'
                }
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

        stage('Deploy-dev') {
            when {
                branch 'dev'
            }
            steps {
                echo 'Stage Deploy-dev!'
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
        stage('Deploy-testing') {
            when {
                branch 'testing'
            }
            steps {
                echo 'Stage Deploy-testing'
                sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
                sh ("sed -i -- 's/APPNAME/$APPNAME/g' docker-compose.yml")
                sh ("sed -i -- 's/TAG/$BUILD_NUMBER/g' docker-compose.yml")
                sshagent(['ssh-ec2']){
                 sh 'scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2INSTANCETEST}:/home/ec2-user' 
                 sh 'ssh ${EC2INSTANCETEST} ls -lrt'
                 sh 'ssh ${EC2INSTANCETEST} docker-compose up -d'
                }
            }
        }
        stage('Deploy-prod') {
            when {
                branch 'main'
            }   
            steps {
                echo 'Stage Deploy prod'
                sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
                sh ("sed -i -- 's/APPNAME/$APPNAME/g' docker-compose.yml")
                sh ("sed -i -- 's/TAG/$BUILD_NUMBER/g' docker-compose.yml")
                sshagent(['ssh-ec2']){
                 sh 'scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2INSTANCEPROD}:/home/ec2-user' 
                 sh 'ssh ${EC2INSTANCEPROD} ls -lrt'
                 sh 'ssh ${EC2INSTANCEPROD} docker-compose up -d'
                }
            }
        }
    }
}