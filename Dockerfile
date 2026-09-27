# Stage 1: build and test using the project's Maven wrapper.
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN sh ./mvnw --batch-mode --no-transfer-progress dependency:go-offline

COPY src/ src/
RUN sh ./mvnw --batch-mode --no-transfer-progress clean verify

# Stage 2: only Java and the finished application are needed at runtime.
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Give the application a writable log directory without running as root.
RUN groupadd --gid 10001 appgroup \
    && useradd --uid 10001 --gid appgroup --no-create-home appuser \
    && mkdir -p /app/logs \
    && chown appuser:appgroup /app/logs

COPY --from=build /workspace/target/hello-java-*.jar /app/app.jar

USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
