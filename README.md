**Inception** is a system administration project designed to build a secure and modular containerized infrastructure using **Docker**.
The goal is to gain hands-on experience with container orchestration, network management, service configuration, and secure deployment practices.
This repository includes the setup to run **NGINX**, **WordPress with php-fpm**, and **MariaDB**, all managed via **Docker Compose** in a **Virtual Machine (VM)** environment.

## Project Goals

- Learn and apply fundamental system administration practices.
- Containerize services manually without using pre-built images.
- Use **Dockerfiles** to build each service from Alpine (penultimate stable release).
- Orchestrate services using `docker-compose.yml`.
- Ensure secure communication with **TLSv1.2+**.
- Practice secure secret handling using environment variables.
- Create a resilient architecture with automatic container restarts.
