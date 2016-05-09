FROM java:8
ENTRYPOINT ["java", "-jar", "/app/demo-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080

ADD build/libs/hello-karyon-rxnetty-all-0.1.1.jar /app/
