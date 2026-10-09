FROM eclipse-temurin:17-jre

WORKDIR /app

COPY target/springbootApp.jar app.jar

EXPOSE 8085

ENTRYPOINT ["java", "-jar", "app.jar"]
