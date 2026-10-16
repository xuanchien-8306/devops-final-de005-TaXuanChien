# syntax=docker/dockerfile:1
# =============================================================================
#  Dockerfile - FILE KHUNG (multi-stage build cho Spring Boot 4 / Java 21 / Gradle)
#  Sinh viên hoàn chỉnh các ô ______ theo yêu cầu Phần 2 của đề thi.
# =============================================================================

# ---------- Stage 1: build - biên dịch & đóng gói bằng Gradle + JDK 21 ----------
# Spring Boot 4 yêu cầu Gradle >= 8.14
FROM gradle:8.14-jdk21-alpine AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./
RUN gradle dependencies --no-daemon

COPY src/ src/
RUN gradle bootJar -x test --no-daemon

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

ARG APP_VERSION=1.0
ENV APP_VERSION=${APP_VERSION}

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder --chown=appuser:appgroup /app/build/libs/app.jar ./app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
