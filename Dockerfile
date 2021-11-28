FROM gradle:7.1.1-jdk11 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle distTar --no-daemon
RUN tar -xvf proxy/build/distributions/proxy.tar

FROM adoptopenjdk/openjdk11:x86_64-alpine-jre-11.0.6_10

EXPOSE 9090

RUN mkdir /app

COPY --from=build /home/gradle/src/proxy/build/distributions/proxy/ /app/

#ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/azymuth-proxy.jar"]
ENTRYPOINT ["/app/bin/proxy"]