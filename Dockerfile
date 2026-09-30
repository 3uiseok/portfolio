# syntax=docker/dockerfile:1
# 1단계: Maven으로 target/web.war 빌드 (JDK 21)
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# 의존성만 먼저 받아 두어 소스 변경 시 레이어 캐시를 재사용한다
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn -B -q dependency:go-offline

COPY src ./src
COPY WebContent ./WebContent
RUN --mount=type=cache,target=/root/.m2 mvn -B -q clean package

# 2단계: Tomcat 11 + JRE 21 실행 이미지 (run.cmd 의 Tomcat 11.0.x 와 동일 계열)
FROM tomcat:11.0-jre21-temurin
ENV TZ=Asia/Seoul
# 기본 webapps 는 비어 있지만, 혹시 남아 있을 예제 앱은 제거한다
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /build/target/web.war /usr/local/tomcat/webapps/web.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
