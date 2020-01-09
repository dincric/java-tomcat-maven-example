# Jenkins Pipeline Test

[TOCM]

[TOC]

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

## Paso a Paso

### Pre Requisitos.
- Crear proyecto en Sonar
- [Cuenta de Microscanner de Aquasec](https://microscanner.aquasec.com/signup)
- Haber instalado Docker en el servidor de Jenkins o alguno de sus nodos

1. Instalar los plugins listados en la seccion [Plugins Necesarios](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/README.md "Plugins Necesarios")

2. Configurar los plugins de acuerdo a la documentación de cada uno.


3. En la ventana principal de nuestro Jenkins, Seleccionamos la opción "New Item"
![](https://github.com/frvasquezjaquez/java-tomcat-maven-example/blob/master/readme-img/new-item.png)

4. Crear Proyecto Multibranch Pipeline en Jenkins.
