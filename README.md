# Jenkins Pipeline Test

El pipeline de este proyecto fue pensado para ser usado con una estrategia de feature-branches, 
donde en las ramas vivas (features) diariamente vamos a compilar, ejecutar pruebas unitarias, analisis de sonar y analisis de seguridad de las imagenes docker. Mientras que con las ramas larga vida (develop, release y master) vamos desplegar ambientes de pruebas automatizadas, performance y UAT para posteriormente pasar a producción. 


## Requerimiento

Utilizando las herramientas necesarias generar un flujo que realice lo siguiente:

1. Descargue este código fuente:
https://github.com/daticahealth/java-tomcat-maven-example.git
2. Ejecute calidad de código
3. Compile usando maven
4. Cree una imagen docker con los artefactos
5. Suba la imagen a docker hub
6. hacer pruebas unitarias
7. hacer pruebas de seguridad
8. Instrucción necesaria para hacer el deploy a un cluster de kubernetes

## Restricciones
Deben ser utilizadas las siguientes herramientas:
- Docker
- Jenkins
- Kubernetes

## Plugins Necesarios
Para este projectos fueron necesarios los siguientes plugins de Jenkins:
##### Base
- [MultiBranch Plugin](https://plugins.jenkins.io/workflow-multibranch)
- [BlueOcean Plugin](https://plugins.jenkins.io/blueocean)
- [Docker Plugin](https://plugins.jenkins.io/docker-plugin)
- [Labelled Plugin](https://plugins.jenkins.io/labelled-steps)

##### Control de Versiones
- [Github Plugin](https://plugins.jenkins.io/github)

##### Analisis Estatico de Código
- [Sonar Scanner](https://plugins.jenkins.io/sonar)

##### Seguridad de Contenedores
- [Aqua Security Scanner](https://plugins.jenkins.io/aqua-microscanner)

## Configuración

### Pre Requisitos.
- Crear Jenkinsfile en la raíz del repositorio
- Crear Dockerfile en la raíz del repositorio
- Crear proyecto en Sonar
- Webhook creado en sonar apuntando a Jenkins
- [Cuenta de Microscanner de Aquasec](https://microscanner.aquasec.com/signup)
- Instalar Docker en el servidor de Jenkins o alguno de sus nodos
- Crear nodo con Kubernetes y asociarlo a Jenkins 
- Crear credenciales en Jenkins para:
	- Github
	- Dockerhub
	- Nodo de Ambiente Staging

### Paso a Paso
1. Instalar los plugins listados en la seccion [Plugins Necesarios](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/README.md "Plugins Necesarios")

2. Configurar los plugins de acuerdo a la documentación de cada uno.

3. En la ventana principal de nuestro Jenkins, Seleccionamos la opción "New Item"
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/new-item.png)

4. Crear Proyecto Multibranch Pipeline en Jenkins.
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/create-mulitbranch-pipeline.png)

5. Indicamos desde que repositorio Jenkins debe traer el código fuente.
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/pipeline-source.png)

6.  Indicamos que deseamos que busque el Jenkinsfile en la carpeta raíz de nuestro repo.
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/pipeline-jenkinsfile-location.png)

7.  Guardamos nuestra configuración.
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/save-conf.png)

8.  Jenkins escaneará todas nuestras ramas en busca de aquellas que posean un Jenkinsfile en la raíz.
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/branch-scanning-results.png)

9.  Luego de escanear, inciará el proceso de ejecución de las instrucciones descritas en nuestro Jenkinsfile
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/scanned-master-branch.png)



## Resultados

### Pipeline Results
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/pipeline-results.png)

### Pipeline Security Results
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/docker-image-security-results.png)

![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/docker-image-vulnerabilities.png)

![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/docker-image-malware.png)


### Sonar Results
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/sonar-qube-results.png)


### DockerHub Results
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/docker-hub-results.png)

### Kubernetes Results
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/kubernetes-node-service.png)
