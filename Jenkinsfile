pipeline {
    
    agent any;
    environment {
      DEMO = "test"
    }
    stages{
        stage('Prepare'){
            steps{
               echo "prepare"
            }
        }
        stage('Build'){
         
            parallel{
                stage('App Compilation'){
                    agent {
                        docker {
                            image 'maven:3-alpine' 
                            args '-v /root/.m2:/root/.m2 --entrypoint='
                            
                        }
                    }
                    steps{
                        sh 'ls'
                        sh 'pwd'
                        sh 'mvn -B -DskipTests clean package' 
                    }
                        
                }
                stage('Sonar Analysis'){
                    steps{
                        runSonarAnalysis()
                    }
                }
                stage('Unit Test'){
                    steps{
                        echo 'Run Unit testing'
                    }
                }
                stage('Image Security Test'){
                    steps{
                        echo 'image testing'
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
