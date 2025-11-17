# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Install git to clone repository
RUN apt-get update && apt-get install -y git && apt-get clean

# Clone your GitHub project
RUN git clone https://github.com/ManvithaDantuluri/travel-backend.git .

# Build the project
RUN mvn -B -DskipTests clean package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

ENV JAVA_OPTS=""
EXPOSE 8081

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
