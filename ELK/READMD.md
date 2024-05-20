# ELK Stack Deployment

This project provides a streamlined method to deploy the ELK stack (Elasticsearch, Logstash, and Kibana) using Docker Compose, along with setting up Metricbeat and Filebeat on your servers. The setup is designed to work on various Linux-based operating systems.

## Prerequisites

- A Linux-based operating system (Ubuntu, Debian, CentOS, RHEL, Fedora, openSUSE)
- Root or sudo access
- Internet connection

## Project Files

- `docker-compose.yml`: Docker Compose file to deploy the ELK stack.
- `install_elk.sh`: Script to install Docker, Docker Compose, Metricbeat, and Filebeat.

## Setup Instructions

### Step 1: Prepare the Docker Compose File

1. Create a `docker-compose.yml` file in your desired directory.
2. Copy and paste the ELK stack configuration into the `docker-compose.yml` file.

### Step 2: Create the Logstash Pipeline Configuration

1. Create the Logstash pipeline directory:
    ```bash
    mkdir -p logstash/pipeline
    ```

2. Create logstash.conf file in the `logstash/pipeline` directory and copy required files to it.

### Step 3: Save the Installation Script

1. Save the provided script as `install_elk.sh`.

### Step 4: Make the Script Executable

1. Make the script executable by running:
    ```bash
    chmod +x install_elk.sh
    ```

### Step 5: Run the Installation Script

1. Execute the script to install Docker, Docker Compose, Metricbeat, and Filebeat:
    ```bash
    ./install_elk.sh
    ```

### Step 6: Start the ELK Stack

1. Navigate to the directory containing your `docker-compose.yml` file.
2. Start the ELK stack using Docker Compose:
    ```bash
    docker-compose up -d
    ```

## Verification

- Access Kibana by navigating to `http://<your-server-ip>:5601` in your web browser.
- Ensure that Elasticsearch is running by visiting `http://<your-server-ip>:9200`.
- Verify that Logstash is listening on port 5044.

## Configuration

- The Metricbeat and Filebeat configurations are set to output data to `http://localhost:9200` by default. Modify the configuration files if necessary.

## Additional Information

- The `docker-compose.yml` file and Logstash pipeline configuration can be customized according to your needs.
- Ensure that all necessary ports are open and accessible for communication between services.

## Troubleshooting

- If you encounter any issues, check the logs of the Docker containers:
    ```bash
    docker-compose logs
    ```

- Verify that Docker and Docker Compose are correctly installed and running:
    ```bash
    docker --version
    docker-compose --version
    ```

## Conclusion

This setup provides a quick and efficient way to deploy the ELK stack and configure Metricbeat and Filebeat on your servers. Customize the configurations as needed to fit your specific requirements.
