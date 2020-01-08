FROM openjdk:8u171-jre-slim
MAINTAINER Francisco Vasquez <frvasquezjaquez@gmail.com>

#Indicamos nuestra carpeta de trabajo
WORKDIR /app

#Copiamos los archivos compilados y las dependencias de acuerdo a la documentación
COPY target/ .

# Exponemos el puerto que tiene la aplicación por defecto
EXPOSE  8080

#Ejecutamos el comando necesario para compilar la aplicación
CMD ["java", "-jar", "dependency/webapp-runner.jar","java-tomcat-maven-example.war"]
