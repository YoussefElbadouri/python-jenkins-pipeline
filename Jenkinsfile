pipeline {
    agent any // Utiliser n'importe quel agent disponible
    environment {
        DOCKER_IMAGE = 'youssefelbadouri/python-jenkins-pipeline' // Nom de l'image Docker
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Récupération du code source depuis GitHub..."
                }
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']], // Branche principale
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/YoussefElbadouri/python-jenkins-pipeline.git',
                        credentialsId: 'github-creds' // Identifiant des credentials GitHub
                    ]]
                ])
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construction de l'image Docker..."
                }
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    echo "Exécution des tests..."
                }
                sh '''
                docker run --rm -d -p 5000:5000 --name test-app $DOCKER_IMAGE
                sleep 5
                curl -f http://localhost:5000 || exit 1
                docker stop test-app
                '''
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo "Push de l'image Docker sur Docker Hub..."
                }
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker tag $DOCKER_IMAGE $DOCKER_USERNAME/python-jenkins-pipeline:latest
                    docker push $DOCKER_USERNAME/python-jenkins-pipeline:latest
                    '''
                }
            }
        }
    }
    post {
        success {
            script {
                echo "Pipeline terminée avec succès !"
            }
        }
        failure {
            script {
                echo "Pipeline échouée. Vérifiez les logs."
            }
        }
    }
}
