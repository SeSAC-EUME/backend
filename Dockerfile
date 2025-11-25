# 빌드 단계
FROM gradle:8-jdk17-jammy AS build
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew
RUN ./gradlew clean bootJar -x test

# 런타임 단계
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
# 필요 환경변수 예: DB 접속 정보
# ENV SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/eum SPRING_DATASOURCE_USERNAME=... SPRING_DATASOURCE_PASSWORD=...
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]