FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN sh ./mvnw --batch-mode --no-transfer-progress dependency:go-offline

COPY src/ src/
RUN sh ./mvnw --batch-mode --no-transfer-progress clean verify

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

RUN groupadd --gid 10001 appgroup \
    && useradd --uid 10001 --gid appgroup --no-create-home appuser \
    && mkdir -p /app/logs \
    && chown appuser:appgroup /app/logs

COPY --from=build /workspace/target/hello-java-*.jar /app/app.jar

USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
