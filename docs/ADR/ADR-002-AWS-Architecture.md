# ADR-002: AWS Architecture Design

## Status
Accepted

---

## 1. Context

The existing application is deployed on Azure using container-based services and
infrastructure managed through Terraform. However, the current infrastructure is tightly
coupled to Azure-specific services and lacks portability and modular design.

The objective of this project is to migrate the application to AWS while ensuring that the
final architecture is production-ready, maintainable, and aligned with DevOps best
practices. The architecture must also remain compatible with AWS Free Tier constraints and
avoid unnecessary complexity.

---

## 2. Decision

The application will be deployed on AWS using a container-based architecture with the
following high-level components:

- **Container Registry:** Amazon Elastic Container Registry (ECR)
- **Compute:** Amazon ECS (container-based service)
- **Networking:** Virtual Private Cloud (VPC) with public subnets
- **Security:** IAM roles and security groups
- **Load Balancing:** Application Load Balancer (ALB)
- **Logging and Monitoring:** Amazon CloudWatch
- **Infrastructure Management:** Terraform

---

## 3. Architecture Overview

The architecture follows a clear separation of concerns:

- Application code is packaged as Docker images
- Infrastructure is provisioned and managed using Terraform
- Deployment and updates are handled through CI/CD automation
- Runtime configuration is provided through environment variables

This approach ensures that application logic, infrastructure, and automation workflows
remain loosely coupled and independently manageable.

---

## 4. Rationale

### Container-Based Deployment
Using containers provides consistency across environments and simplifies deployment.
Containers encapsulate application dependencies and runtime configuration, reducing
environment-related issues during migration.

### Amazon ECS
ECS provides managed container orchestration without the operational overhead of managing
a Kubernetes cluster. It is well-suited for the scale and complexity of this project while
remaining cost-effective and Free Tier compatible.

### Amazon ECR
ECR integrates seamlessly with ECS and provides a secure, managed container registry for
storing Docker images. This simplifies image management and access control.

### Networking Design
A dedicated VPC with clearly defined subnets and security groups provides network isolation
and control. Public access is managed through a load balancer, ensuring that application
services are not directly exposed.

### Load Balancing
An Application Load Balancer is used to route traffic to backend services and perform health
checks. This improves availability and enables future scalability.

### Logging and Monitoring
CloudWatch is used to collect logs and metrics from running services. Centralized logging
improves observability and simplifies troubleshooting in production environments.

### Terraform
Terraform enables the entire infrastructure to be version-controlled, reproducible, and
reviewable. This aligns with infrastructure-as-code best practices and supports reliable
environment provisioning.

---

## 5. Alternatives Considered

### AWS EC2 with Manual Docker Management
Running containers directly on EC2 instances was considered. However, this approach
requires additional operational effort for scaling, health checks, and service management,
which ECS handles automatically.

### AWS Elastic Beanstalk
Elastic Beanstalk simplifies deployment but provides limited control over underlying
infrastructure. This project requires explicit infrastructure definitions to demonstrate
DevOps best practices.

### Kubernetes (EKS)
Kubernetes offers advanced orchestration capabilities but introduces additional complexity
that is not necessary for the scope of this project.

---

## 6. Consequences

### Positive Consequences
- Clear and maintainable infrastructure design
- Improved scalability and availability
- Reduced operational overhead
- Strong alignment with DevOps and cloud-native practices
- Easier migration from Azure due to container-based abstraction

### Trade-offs
- ECS provides fewer advanced orchestration features compared to Kubernetes
- AWS-specific services introduce some level of vendor dependency
- Initial infrastructure setup requires careful configuration

---

## 7. Summary

The selected AWS architecture provides a balanced approach between simplicity and
production readiness. By leveraging managed container services, infrastructure-as-code, and
centralized monitoring, the architecture supports reliable deployments while remaining
cost-effective and maintainable.

This design enables the project to demonstrate real-world DevOps migration practices and
delivers a stable foundation for future enhancements.
