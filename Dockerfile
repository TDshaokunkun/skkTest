FROM adoptopenjdk/maven-openjdk11 AS MAVEN_BUILD
MAINTAINER Dragon
RUN mkdir -p /td
WORKDIR /td
COPY . .
RUN mvn clean install -Dmaven.test.skip=true

FROM adoptopenjdk/openjdk11:alpine-slim AS DOCKER_BUILD
WORKDIR /td
RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/6.5.0/newrelic-java-6.5.0.zip \
    && unzip newrelic-java-6.5.0.zip \
    && rm -rf newrelic-java-6.5.0.zip
COPY --from=MAVEN_BUILD /td/target/sc-case-stream*.jar /td/app.jar
COPY ./newrelic.yml ./newrelic/newrelic.yml
ENTRYPOINT ['java','-XX:+UseContainerSupport','-XX:InitialRAMPercentage=50.0','-XX:MinRAMPercentage=25.0','-XX:MaxRAMPercentage=50.0','-XX:+HeapDumpOnOutOfMemoryError','-XX:+PrintGCDetails','-Dspring.profiles.active=dev','-Djava.security.egd=file:/dev/./urandom','-jar','-javaagent:/td/newrelic/newrelic.jar','app.jar']
