pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        nodejs 'node20'
    }

    environment{
        SCANNER_HOME = tool 'sonar-scanner'
        REPO_URL = 'https://github.com/rimas123-creator/Project-Nodejs-Jenkins-Sonarqube-Owasp-Trivy-Docker-Scout-DevSecops.git'
        BUILD_IMG_NAME = 'myapp:latest'
        BIN_DIR = "${WORKSPACE}/bin"
        PATH = "${BIN_DIR}:${env.PATH}"
        DOCKER_HUB_USR = credentials('dh_user')
        DOCKER_HUB_PSW = credentials('dh_password')
    }
    
    stages {
        stage('CW') {
            steps {
                cleanWs()
            }
        }

        stage('checkout scm') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'rimas-jenkins', url: REPO_URL ]]])
            }
        }
        stage('SonarQube-Analysis'){
            steps{
                script{
                    withSonarQubeEnv('sonar-server') {
                    sh '''
                    
                     $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=rimas-myapp \
                     -Dsonar.projectKey=rimas-myapp
                    
                    '''
                    }
                }
            }
        }
        // stage('SonarQube-QualityGates'){
        //     steps{
        //         script{
        //             waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
        //         }
        //     }
        // }
        stage('NPM Install'){
            steps{
                sh 'npm install'
            }
        }
        stage('OWASP FS SCAN'){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Trivy FS Scan'){
            steps{
                sh 'trivy fs . > TRIVYFS-MYAPP.txt'
            }
        }
        
        stage('Build the Dockerfile and Get the Image'){
            steps{
                sh 'docker build -t ${BUILD_IMG_NAME} .'
            }
        }

        stage('Trivy Image Scan'){
            steps{
                sh 'trivy image ${BUILD_IMG_NAME} > TRIVYIMAGE-MYAPP.txt'
            }
        }
        
         stage('Install Docker Scout') {
            steps {
                sh '''
                    mkdir -p ${BIN_DIR}
                    if ! [ -x "${BIN_DIR}/docker-scout" ]; then
                        echo "Installing Docker Scout CLI..."
                        curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s -- -b ${BIN_DIR}
                    else
                        echo "Docker Scout is already installed in ${BIN_DIR}."
                    fi
                '''
            }
        }
        
         stage('Docker Login (Hub)') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_HUB_USR', passwordVariable: 'DOCKER_HUB_PSW')]) {
                    sh '''
                        echo "$DOCKER_HUB_PSW" | docker login -u "$DOCKER_HUB_USR" --password-stdin
                    '''
                }
            }
        }

        stage('Scan with Docker Scout') {
        steps {
        sh '''
            echo "Running Docker Scout scan..."
            export TMPDIR="${WORKSPACE}/tmp"
            mkdir -p "$TMPDIR"
            docker-scout quickview ${BUILD_IMG_NAME} | echo "Issue with image please check!!!"
        '''
        }
    }

        stage('Remove the Image from Host'){
            steps{
                sh 'docker image prune -a -f'
            }
        }
        
 
    }
}