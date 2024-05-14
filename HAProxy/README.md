# HAProxy Docker Setup

This repository contains a Docker and Docker Compose configuration for setting up HAProxy as a reverse proxy and load balancer. It is designed for production environments with an emphasis on reliability, maintainability, and security.

## Features

- **Dockerized HAProxy**: Containerized HAProxy for easy deployment and isolation.
- **Dynamic Configuration**: Scripts to dynamically generate HAProxy configurations from base, frontend, and backend templates.
- **Managed Docker Volumes**: Persistent storage for HAProxy configurations, logs, and error files to ensure data durability across container restarts.
- **Logging and Monitoring**: Configured logging with automatic rotation to manage disk space usage efficiently.
- **Health Checks**: Basic health checks to ensure HAProxy service reliability.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/universcom/app-composers.git
   cd app-composers/HAProxy
   docker-compose build
   docker-compose up -d
   ```

### Configuration

- **HAProxy Configuration:** Place your HAProxy base configurations in ./config/base, frontend configurations in ./config/frontends, and backend configurations in ./config/backends. These directories are mapped to Docker volumes.

- **Logs and Errors:** Logs are stored in the ./logs volume, and error files are in the ./errors volume. Adjust the logging settings in docker-compose.yml as needed.

### Usage

After deployment, HAProxy will be accessible at:

- HTTP: Port 80
- HTTPS: Port 443

Modify the port mappings in **docker-compose.yml** if you need to change these defaults.


### Contributing

Contributions are welcome! Please feel free to submit pull requests, create issues, or suggest improvements via the GitHub issue tracker.

### License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

HAProxy community for the comprehensive configuration documentation.
Docker docs for guidance on best practices in containerization.

