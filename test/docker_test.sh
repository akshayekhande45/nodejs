#!/bin/bash

docker stop nodecontainer || true
docker rm nodecontainer || true
docker run -d --name nodecontainer -p 80:3000 nodeimg

# Wait for the container to be running
max_attempts=30
current_attempt=0

while [ $current_attempt -lt $max_attempts ]; do
    container_status=$(docker ps --format "{{.Names}}: {{.Status}}" | grep 'nodecontainer')

    if echo "$container_status" | grep -q "Up"; then
        echo "Container 'nodecontainer' is running!"
        break
    else
        echo "Waiting for the container to be running..."
        sleep 5
        current_attempt=$((current_attempt + 1))
    fi
done

if [ $current_attempt -eq $max_attempts ]; then
    echo "Container 'nodecontainer' did not start within the expected time."
    exit 1
fi