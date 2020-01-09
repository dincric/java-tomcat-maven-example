pipeline {
    
    agent any;
    environment {
      ARTIFACT_ID="javierex/javatest:${BUILD_NUMBER}-${env.BRANCH_NAME}"
      
      //SONAR
      SONAR_URL="http://52.170.155.167:9000"
      SONAR_TOKEN="9c10addc968c43fe861d541d6b08e3ef0acf6cac"
      SONAR_PROJECT="JavaBHDTest"
      
      //Deploy 
      DEPLOYMENT_NODE = getDeploymentNode()

    }
    stages{
        stage('Prepare'){
            steps{
                /*  En esta etapa se registran las instrucciones necesarias 
                    para limpiar nuestro ambiente. 
                */
            
                labelledShell( label: "Clean environment",
                    script: "echo cleaning...")
            }
        }
        stage('Build'){
            agent {
                docker {
                    image 'maven:3-alpine' 
                    args "-v /${HOME}/.m2:/root/.m2 -v ${WORKSPACE}:/app -w /app --entrypoint="
                    reuseNode true
                }
            }
            steps{
                //Limpiamos el proyecto y compilamos
                sh 'mvn -B -DskipTests clean  package' 
            }
                        
                
        }
        stage('Test'){
            parallel{
                stage('Sonar Analysis'){
                   agent {
                        docker {
                            image 'maven:3-alpine' 
                            args "-v ${HOME}/.m2:/root/.m2 --entrypoint="
                            
                        }
                    }
                    steps{
                        withSonarQubeEnv('Sonar-Server') {
                            sh "mvn sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT} -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN}"
                        }

                        /*
                            Esperamos la respuesta del Webhook de Sonar
                            Si no termina en 2 minutos, aborta el proceso del pipeline
                        */
                        timeout(time: 2, unit: 'MINUTES') {
                             waitForQualityGate abortPipeline: true
                        }
                    }
                }
                stage('Unit Test'){
                    agent {
                        docker {
                            image 'maven:3-alpine' 
                            args "-v ${HOME}/.m2:/root/.m2 --entrypoint="
                        }
                    }
                    steps{
                        sh 'mvn test' 
                    }
                }
                stage('Image Security Test'){
                    steps{
                        labelledShell( label: "Construcción de la Imagen",
                            script: "docker build -t ${ARTIFACT_ID} .")

                        /*
                            Ejecutamos el analisis de seguridad con el Aqua Microscanner
                        */    
                        aquaMicroscanner imageName: "${ARTIFACT_ID}", notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
                    }
                }
               
            }
        }
        stage('Package'){
            when {
                branch pattern: "development|release|master", comparator: "REGEXP"
            }
            steps{
                script {
                    withDockerRegistry([ credentialsId: "44a219b5-386c-49ae-96f1-a5a57af89886", url: "" ]){
                        def customImage = docker.build("${ARTIFACT_ID}")
                        customImage.push()
                        
                    }
                }
            }
            
        }
        
        stage('Deploy'){
            agent { label DEPLOYMENT_NODE }
            when {
                branch pattern: "development|release|master", comparator: "REGEXP"
            }
            //options { skipDefaultCheckout() }  //No clonamos

            steps{
                sh 'pwd'
            }
        }
        
        stage('Automated Tests'){
            when {
                branch pattern: "development|release|master", comparator: "REGEXP"
            }
            parallel {
                stage('Katalon'){
                    /*
                        En esta etapa ejecutariamos las pruebas funcionales automatizadas
                         En estecaso, sería con la aplicación Katalon
                    */
                    steps{
                        echo "Katalon testing..."
                    }
                }
                stage('JMeter'){
                    /*
                        En esta etapa ejecutariamos las pruebas de Carga
                        En estecaso, sería con la aplicación Jmeter
                    */
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
            return "staging-node"
            
          case "release":
            return "qa-node"
            
          default:
            return "dev-node" 
            
        }
    }
}

def appDeployedSuccessfully(){
    script {
        def appReturnedExpectedValue = labelledShell(label: "Verificamos que la app esté corriendo",
                                            returnStdout: true, 
                                            script: "curl -sS ${SERVER_HOST_NAME}:${APP_PORT} | grep -o  ${CURL_STATUS_PATTERN}")
        if (appReturnedExpectedValue){
            return true;
        }
        return false;
    }    

    
}
