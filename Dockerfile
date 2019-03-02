FROM openjdk:9-jdk-slim as build

RUN apt-get update && \
    apt-get install --no-install-recommends -y -qq ca-certificates-java

COPY certificates /usr/local/share/ca-certificates/certificates

RUN chmod 644 /usr/local/share/ca-certificates/certificates/* && \
    update-ca-certificates

# Import cert into keystore
RUN keytool -import -trustcacerts -cacerts -storepass changeit -alias Root -import -file /usr/local/share/ca-certificates/certificates/* -noprompt

FROM openjdk:9-jdk-slim as run

RUN groupadd --gid 1000 java && \
    useradd --uid 1000 --gid java --shell /bin/bash --create-home java && \
    chmod -R a+w /home/java

USER java
WORKDIR /home/java

# Only copy system certs and keystore over
COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /etc/default/cacerts /etc/default/cacerts
COPY --from=build ${JAVA_HOME}/lib/security/cacerts ${JAVA_HOME}/lib/security/cacerts
