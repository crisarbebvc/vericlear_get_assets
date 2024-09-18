#!/bin/sh

# Set the release version
RELEASE_VERSION="17.09.2024"

# Get the list of files in the assets directory of the GitHub release
ASSETS_URL="https://api.github.com/repos/crisarbebvc/vericlear/releases/tags/$RELEASE_VERSION"
ASSETS_JSON=$(curl -s $ASSETS_URL)
FILES=$(echo $ASSETS_JSON | jq -r '.assets[].name')

# Loop through the files and download each one
for file in $FILES; do
     if echo $file | grep -q '.jar'
     then
          echo "$file downloading..."
          curl -LO "https://github.com/crisarbebvc/vericlear/releases/download/$RELEASE_VERSION/$file" --output-dir "./artifacts/"
     fi
done

# Create a Docker container for each file in the artifacts folder
for file in ./artifacts/*; do
     if [ -f "$file" ]; then
          echo "Creating Docker container for $file..."
          file_name=${file##*/}
          echo ${file_name}
          lower_case=$(echo $file_name | tr '[:upper:]' '[:lower:]')
          docker build --build-arg JAR_FILE=$file -t ${lower_case}:latest .
          #docker push ${lower_case}:latest
     fi
done