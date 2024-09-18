# Use a base image with Java installed
FROM openjdk:11

# Set the working directory
WORKDIR /app

# Copy the JAR file to the container
ARG JAR_FILE
COPY ${JAR_FILE} /app/app.jar

# Run the JAR file
CMD ["java", "-jar", app.jar]