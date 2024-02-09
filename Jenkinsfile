pipeline {
    agent any
    environment {
 
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '482088842115'
        CODECOMMIT_REPO_URL = 'https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/datayaan_website2.0'
        ECR_REPO_NAME = 'welcome_cantainer'
        DOCKER_IMAGE_NAME = 'welcome_cantainer'
        DOCKER_HOST_IP = '43.205.231.221'
        DOCKER_HOST_PORT = '9003'
        YOUR_CONTAINER = '482088842115.dkr.ecr.ap-south-1.amazonaws.com/welcome_cantainer'
        AWS_CREDENTIALS = credentials('aws_provider') // Use the ID you set in Jenkins credentials
        IMAGE_TAG = "welcome_cantainer"
        
    }
 
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', credentialsId: 'aws_codecommit', url: CODECOMMIT_REPO_URL
            }
        }
 
        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }
 
        stage('Build Docker Image') {
            steps {
                script {
                    echo('into build stage')
                    // Build Docker image
                    def dockerImage = docker.build("${YOUR_CONTAINER}:${IMAGE_TAG}")
                    dockerImage.push()
                    echo('build completed')
                }
            }
        }
 
        stage('Pushing to ECR') {
            steps {
                script {
                    echo('Pushing the image')
                    sh "docker tag ${YOUR_CONTAINER}:${IMAGE_TAG} ${YOUR_CONTAINER}:${IMAGE_TAG}"
                    sh "docker push ${YOUR_CONTAINER}:${IMAGE_TAG}"
                    echo('Image pushed to the repository successfully')
                }
            }
        }
 
        stage('Deploying to Docker') {
            steps {
                script {
                    // Pull the image from ECR
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker pull ${YOUR_CONTAINER}:${IMAGE_TAG}"
                    echo('docker image pulled')
                }
            }
        }
        stage('Check and Stop Container') {
            steps {
                script {
                    echo('check & stop stage')
                    def portToStop = 80
                    def containerIds = sh(script: "docker ps -q --filter=expose=${portToStop}", returnStdout: true).trim()
                    echo "${containerIds}"
                    if (containerIds) {
                        // Split the container IDs and stop each container
                        containerIds.split("\n").each { containerId ->
                            sh "docker stop ${containerId}"
                            sh "docker rm ${containerId}"
                            echo "Stopped and removed container ID: ${containerId}"
                        }
                    } else {
                        echo "No containers found using port ${portToStop}"
                    }
                }
            }
        }
       
        stage('Run New Container') {
            steps {
                script {
                    sh "docker run -d -p 9003:80 482088842115.dkr.ecr.ap-south-1.amazonaws.com/welcome_cantainer:welcome_cantainer"
                }
            }
        }
 
    }
}
 