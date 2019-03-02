FROM openjdk:9-jdk-slim as build

COPY certificates /usr/local/share/ca-certificates/certificates

RUN chmod 644 /usr/local/share/ca-certificates/certificates/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y -qq ca-certificates-java && \
    update-ca-certificates

RUN keytool -import -trustcacerts -cacerts -storepass changeit -alias Root -import -file /usr/local/share/ca-certificates/certificates/* -noprompt

FROM openjdk:9-jdk-slim as run

RUN groupadd --gid 1000 java && \
    useradd --uid 1000 --gid java --shell /bin/bash --create-home java && \
    chmod -R a+w /home/java

COPY --from=build ${JAVA_HOME}/lib/security/cacerts ${JAVA_HOME}/lib/security/cacerts

USER java
WORKDIR /home/java
