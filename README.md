# Java CI/CD Pipeline Deployment Demo

A portable Java application built with Spring Boot and Maven. The same source code and executable JAR run on Windows, Linux, and macOS with a compatible JDK (Java 17 or later).

## Requirements

- Install a JDK and make `java` available on your PATH. If `JAVA_HOME` is set, it must point to that JDK.
- The included Maven wrappers download Maven automatically; a separate Maven installation is not required.
- The first build needs internet access to download Maven and dependencies. Linux/macOS need a POSIX shell and curl or wget for the wrapper download.
- Run commands from the project directory.

## Build and test

Windows (PowerShell or Command Prompt):

```powershell
.\mvnw.cmd clean verify
```

Linux/macOS:

```sh
sh ./mvnw clean verify
```

Using `sh` also works when a ZIP download has not preserved executable permissions. Alternatively, run `chmod +x mvnw` once, then use `./mvnw clean verify`.

## Run on any platform

After building, the command is identical on Windows, Linux, and macOS:

```text
java -jar target/hello-java-0.0.1-SNAPSHOT.jar
```

Open http://localhost:8080/ to see **JAVA CI/CD Pipeline Deployment Demo**. Spring Boot serves `index.html` and `styles.css` directly from `src/main/resources/static/`. There is no custom REST API or controller. A greeting is also printed in the terminal on startup.

To use another port on any platform:

```text
java -jar target/hello-java-0.0.1-SNAPSHOT.jar --server.port=8081
```

Then open http://localhost:8081/. Stop the application with Ctrl+C.

You can also run directly from source:

| Platform | Command |
| --- | --- |
| Windows | `.\mvnw.cmd spring-boot:run` |
| Linux/macOS | `sh ./mvnw spring-boot:run` |

## Portable logging

Logs are written to the console and `logs/app.log`, relative to the directory where you start the application. Use a writable working directory. No system log directory or administrator/root privileges are required.

Override the file location with the `APP_LOG_FILE` environment variable, or use the same command-line option on any platform:

```text
java -jar target/hello-java-0.0.1-SNAPSHOT.jar --logging.file.name=custom-logs/app.log
```

Quote the full option if the path contains spaces. Environment-specific absolute paths can also be supplied when deploying.

## Tests and coverage

### GitHub Actions

The workflow in `.github/workflows/maven.yml` runs on pushes, pull requests, and manual runs from the GitHub Actions tab.

1. **Build with Maven:** uses Java 17 on Ubuntu, packages the JAR with tests skipped, and uploads it as `application-jar`.
2. **Run tests and generate coverage:** starts only after the build succeeds (`needs: build`). Runs the unit and application integration tests and uploads JUnit results and JaCoCo reports as `test-results-and-coverage`, including available reports when tests fail.

Each job starts on a separate runner. The test job checks out the same source and compiles it for testing; it does not test the uploaded JAR. Maven dependencies are cached between jobs/runs.

Commit and push the project with `pom.xml`, `mvnw`, and `.github/` at the repository root. Download reports from the workflow run's **Artifacts** section, then open `index.html` inside the JaCoCo report folder. A failed test fails the test job and the workflow.

### Local tests

| Platform | Run tests and generate coverage |
| --- | --- |
| Windows | `.\mvnw.cmd test` |
| Linux/macOS | `sh ./mvnw test` |

The runner unit test checks startup console output using the platform's line separator. Application integration tests start Spring Boot on an automatically assigned port and check that the home page and stylesheet load successfully and the removed greeting endpoint returns 404.

JaCoCo generates reports automatically during `test`, `package`, and `verify`:

- Browser report: `target/site/jacoco/index.html`
- CI coverage data: `target/site/jacoco/jacoco.xml`
- CSV: `target/site/jacoco/jacoco.csv`
- JUnit results: `target/surefire-reports/`

Open the HTML report with your browser or file manager on any platform. Coverage measures Java production code; HTML/CSS are not included. No production classes are excluded. See the [JaCoCo Maven plugin documentation](https://www.jacoco.org/jacoco/trunk/doc/maven.html).
