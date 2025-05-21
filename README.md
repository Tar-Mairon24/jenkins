# Jenkins CI/CD Environment for nodejs

This setup installs Jenkins and an agent on your machine, enabling it to run jobs using Node.js and npm. It also supports deploying Docker containers. To enable this, you need to retrieve your Docker group ID and provide it as an argument for the image.

## How to Build and Run

### 1. Get the Docker Group ID from Your Host

Run this command on your host to get the Docker group ID:

```bash
DOCKER_GID=$(getent group docker | cut -d: -f3)
```

### 2. Run the compose

In this stage the agent will not work, you need to fill the .env as per the example, for the secret and agent name you'll need to configure a agent in your jenkins after the initial configuration.

```bash
docker compose up -d
```

Fill the .env and then do the next 

### 3. Build the Jenkins Agent Image

Build the agent

```bash
docker compose build --build-arg DOCKER_GID=<DOCKER_GID> jenkins-agent
```

### 4. Start the Jenkins Environment again

```bash
docker compose up -d
```

### 5. Verify Everything is Working

You can check the running containers:

```bash
docker ps
```

And verify Jenkins is accessible at [http://localhost:8080](http://localhost:8080).
