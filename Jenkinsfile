pipeline {
    
    agent any;
    environment {
      ARTIFACT_ID="bhd/javatest/${env.BRANCH_NAME}:${BUILD_NUMBER}"
    }
    stages{
        stage('Prepare'){
            steps{
               echo "prepare"
            }
        }
        stage('Build'){
            agent {
                docker {
                    image 'maven:3-alpine' 
                    args '-v /root/.m2:/root/.m2 --entrypoint='
                    
                }
            }
            steps{
                //Limpiamos el workspace y compilamos
                sh 'mvn -B -DskipTests clean  package' 
            }
                        
                
        }
        stage('Test'){
         
            parallel{
                stage('Sonar Analysis'){
                    agent {
                        docker {
                            image 'sonarsource/sonar-scanner-cli'
                            args '-e SONAR_HOST_URL=http://foo.acme:9000 --entrypoint=""'
                        }
                    }
                    steps{
                        // sh 'sonar-scanner'
                        sh 'echo test'
                    }
                }
                stage('Unit Test'){
                    agent {
                        docker {
                            image 'maven:3-alpine' 
                            args '-v /root/.m2:/root/.m2 --entrypoint='
                            
                        }
                    }
                    steps{
                        sh 'mvn test' 
                    }
                }
                stage('Image Security Test'){
                    steps{
                       labelledShell( label: "Construcción de la Imagen",
                            script: 'docker build -t ${env.ARTIFACT_ID} .')

                       aquaMicroscanner imageName: 'alpine:latest', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
                    }
                }
               
            }
        }
        stage('Package'){
            when {
                branch pattern: "development|release|master", comparator: "REGEXP"
            }
            steps{
                echo "Dockerhub upload"
            }
            
        }
        
        stage('Deploy'){
          //  agent { label DEPLOYMENT_NODE }
            when {
                branch pattern: "development|release|master", comparator: "REGEXP"
            }
            options { skipDefaultCheckout() }  //Not clone repo in agent

            steps{
                echo "deploy"
            }
        }
        
        stage('Automated Tests'){
            when {
                branch pattern: "development|master", comparator: "REGEXP"
            }
            parallel {
                stage('Katalon'){
                    steps{
                        echo "Katalon testing..."
                    }
                }
                stage('JMeter'){
                    steps{
                        echo "JMeter testing..."
                    }
                }
                
            }
        }
        
        stage('Deployment to Production'){
            when {
                branch 'master' 
            }
            options { skipDefaultCheckout() }  //Not clone repo in agent

            steps{
                echo "Deployment to production..."
            }
        }
    }
    
}

def getDeploymentNode(){
    script {
        switch(env.BRANCH_NAME) {
          case "master":
            return "StagingNode"
            
          case "release":
            return "QaNode"
            
          default:
            return "DevNode" 
            
        }
    }
}

def runSonarAnalysis(){
    echo "sonar"
    // withSonarQubeEnv('Sonar-Server') {
    //      labelledShell( label: "Project Scan",
    //          script: """${SONAR_SCANNER_TOOL}/sonar-scanner -D sonar.branch.name=${env.BRANCH_NAME} -D sonar.login=${SONAR_LOGIN_TOKEN} -D sonar.host.url=${SONAR_HOST} -D sonar.projectKey=${SONAR_PROJECT} -D sonar.java.binaries=${SONAR_BINARIES_FOLDERS} """)
        
    // }
    // timeout(time: 10, unit: 'MINUTES') {
    //      waitForQualityGate abortPipeline: true
    // }

}

def appDeployedSuccessfully(){

    script {
        def appReturnedExpectedValue = labelledShell(label: "Check ap is up and running",
                                            returnStdout: true, 
                                            script: "curl -sS ${SERVER_HOST_NAME}:${APP_PORT} | grep -o  ${CURL_STATUS_PATTERN}")
        if (appReturnedExpectedValue){
            return true;
        }
        return false;
    }    

    
}
