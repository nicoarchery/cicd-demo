FROM eclipse-temurin:17-jdk
VOLUME /tmp
COPY target/cicd-demo-*.jar /app.jar
ENTRYPOINT [ "java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar" ]
