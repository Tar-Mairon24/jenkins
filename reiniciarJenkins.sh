#! /bin/bash

source ~/Documents/jenkins/.env

start_agent() {
    echo "Starting Jenkins agent..."
    docker exec -w /var/jenkins_home jenkins-agent curl -sO "$jenkins_curl"
    docker exec -w /var/jenkins_home jenkins-agent java -jar agent.jar \
        -url "$jenkins_url" -secret "$jenkins_secret" -name Agent -webSocket -workDir "/var/jenkins_home"
    if [ $? -ne 0 ]; then
        echo "Failed to start Jenkins agent"
        exit 1
    fi
    echo "Jenkins agent started successfully"
}

restart_jenkins() {
    echo "Restarting Jenkins..."
    docker compose down
    sleep 5
    docker compose up -d --build
    if [ $? -ne 0 ]; then
        echo "Failed to start Jenkins"
        exit 1
    fi
    echo "Jenkins started successfully"
    sleep 5
}

jenkins_count=$(docker ps | grep -c jenkins)
if [ "$jenkins_count" -ne 2 ]; then
    echo "Jenkins is not running. Starting Jenkins..."
    restart_jenkins
else
    echo "Jenkins is running. Restarting Jenkins..."
    restart_jenkins
fi

start_agent