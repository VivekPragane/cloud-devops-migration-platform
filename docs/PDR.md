# Problem Definition Report (PDR)

## 1. Background

The provided application is an Azure-based DevOps project that includes a backend service,
a frontend application, containerization using Docker, infrastructure provisioning using
Terraform, and CI/CD automation using GitHub Actions.

The project is intentionally designed with multiple misconfigurations across different
layers of the system. These issues prevent the application from being production-ready
and make it unsuitable for reliable deployment in a real cloud environment.

This project focuses on identifying those issues, understanding why they exist, and
resolving them using industry-standard DevOps best practices.

---

## 2. Current State of the Application

In its current form, the application has the following characteristics:

- Backend and frontend services are present but tightly coupled to local configurations
- Docker images are not optimized for production use
- Infrastructure code is specific to Azure and lacks modular design
- CI/CD pipeline is configured with cloud-specific assumptions
- Configuration and environment management are inconsistent

As a result, the application:
- Works partially in local environments
- Fails or behaves unpredictably in containerized or cloud setups
- Is difficult to migrate or scale without significant changes

---

## 3. Identified Problems

After analyzing the project structure and codebase, the following high-level problems
were identified:

### Application-Level Issues
- Hardcoded configuration values such as ports and service URLs
- Missing health check endpoints required by container orchestration platforms
- Incomplete error handling and logging
- Improper use of environment variables

### Containerization Issues
- Dockerfiles are not optimized for production workloads
- Lack of multi-stage builds, resulting in large image sizes
- No container health checks defined
- Inconsistent use of `.dockerignore` files

### Infrastructure Issues
- Terraform configuration is tightly coupled to Azure services
- Flat Terraform structure with limited reusability
- No clear separation between environments
- Infrastructure is not easily portable to another cloud provider

### CI/CD Issues
- Pipeline logic assumes Azure-specific resources
- Missing validation and environment configuration steps
- Pipeline failures are not handled or documented clearly

---

## 4. Impact of the Problems

These issues collectively create several risks:

- Application instability during deployment
- Inability to scale or monitor services effectively
- Increased operational overhead
- Difficulties in migrating the application to AWS
- Reduced confidence in automation and repeatability

From a DevOps perspective, these problems indicate gaps in configuration management,
infrastructure design, and deployment automation.

---

## 5. Project Objectives

The objectives of this project are:

- Identify and document all misconfigurations across the application, Docker,
  infrastructure, and CI/CD layers
- Refactor the application to follow production-ready DevOps practices
- Migrate the infrastructure from Azure to AWS using Free Tier compatible services
- Implement a reliable CI/CD pipeline that supports automated builds and deployments
- Ensure the final solution is secure, maintainable, and cloud-agnostic where possible

---

## 6. Expected Outcome

At the end of this project:

- The application will run reliably in a containerized AWS environment
- Infrastructure will be fully managed using Terraform
- CI/CD automation will be functional and transparent
- Configuration will be environment-driven and secure
- The overall system will reflect real-world DevOps engineering standards

This project serves as a practical demonstration of identifying real issues,
applying structured problem-solving, and delivering a production-ready cloud solution.
