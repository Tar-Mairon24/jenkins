#! /bin/bash

jenkins_count=$(docker ps | grep jenkins | wc -l)

if [ "$jenkins_count" -ne 2 ]; then 
    
    echo "Jenkins is not running"

    docker compose -f docker/jenkins-compose.yml up -d --build

    docker exec -itw /var/jenkins_home jenkins-agent curl -sO http://172.18.0.2:8080/jnlpJars/agent.jar

    docker exec -itdw /var/jenkins_home jenkins-agent java -jar agent.jar -url http://172.18.0.2:8080/ -secret c4f9302b84b77d4d2fec207be69c4c39c76e1fef0f6b4c40aeecb757fe13f3c1 -name Agent -webSocket -workDir "/var/jenkins_home"

    if [ $? -ne 0 ]; then
        
        echo "Failed to start Jenkins agent"
        exit 1
    
    elif [ $? -eq 0 ]; then
        
        echo "Jenkins agent started successfully"
        sleep 5 
    fi

    if [ $? -ne 0 ]; then
        
        echo "Failed to start Jenkins"
        exit 1
    
    elif [ $? -eq 0 ]; then
        
        echo "Jenkins started successfully"
        sleep 5

        docker exec -itw /var/jenkins_home jenkins-agent curl -sO http://172.18.0.2:8080/jnlpJars/agent.jar

        docker exec -itdw /var/jenkins_home jenkins-agent java -jar agent.jar -url http://172.18.0.2:8080/ -secret c4f9302b84b77d4d2fec207be69c4c39c76e1fef0f6b4c40aeecb757fe13f3c1 -name Agent -webSocket -workDir "/var/jenkins_home"
    
    fi
else 

    docker compose -f docker/jenkins-compose.yml down
    echo "Jenkins is stopping"
    sleep 5

    docker compose -f docker/jenkins-compose.yml up -d --build
    compose_status=$?
    echo "Jenkins is starting"
    sleep 5

    if [ "$compose_status" -ne 0 ]; then
        
        echo "Failed to start Jenkins"
        exit 1
    
    else
        
        echo "Jenkins started successfully"
        sleep 5

    fi

    docker exec -itw /var/jenkins_home jenkins-agent curl -sO http://172.18.0.2:8080/jnlpJars/agent.jar

    docker exec -itdw /var/jenkins_home jenkins-agent java -jar agent.jar -url http://172.18.0.2:8080/ -secret c4f9302b84b77d4d2fec207be69c4c39c76e1fef0f6b4c40aeecb757fe13f3c1 -name Agent -webSocket -workDir "/var/jenkins_home"

    if [ $? -ne 0 ]; then
        
        echo "Failed to start Jenkins agent"
        exit 1
    
    elif [ $? -eq 0 ]; then
        
        echo "Jenkins agent started successfully"
        sleep 5 
    fi
fi
