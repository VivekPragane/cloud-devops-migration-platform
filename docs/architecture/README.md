# Architecture Overview

This directory contains the architecture diagrams for the DevOps migration project.
The diagrams represent the final AWS-based design and the CI/CD workflow used to build,
deploy, and operate the application.

These diagrams are intended to provide a high-level understanding of the system design
and to complement the detailed architecture decisions documented in the ADR files.

---

## AWS Application Architecture

The AWS application architecture diagram illustrates how the application is deployed
and operated on Amazon Web Services.

Key aspects covered in the diagram:
- Containerized frontend and backend services running on Amazon ECS
- Docker images stored and pulled from Amazon ECR
- Traffic routed through an Application Load Balancer (ALB)
- Secure access managed using IAM roles
- Centralized logging and metrics using Amazon CloudWatch
- All components deployed within a dedicated AWS VPC

This diagram reflects the architectural decisions described in **ADR-002: AWS Architecture Design**.

---

## CI/CD Architecture

The CI/CD architecture diagram describes the automated workflow used to build and deploy
the application.

Key aspects covered in the diagram:
- GitHub repository as the single source of truth
- GitHub Actions used as the CI/CD engine
- Automated Docker image builds for frontend and backend services
- Image storage in Amazon ECR
- Automated deployment to Amazon ECS
- Log and metric visibility through Amazon CloudWatch

This diagram aligns with **ADR-003: CI/CD Pipeline Design** and demonstrates how
automation is used to achieve reliable and repeatable deployments.

---

## Purpose of the Diagrams

Together, these diagrams provide:
- A clear visual representation of the system design
- A reference for implementation and troubleshooting
- Supporting material for evaluation and technical discussions

They are designed to be simple, accurate, and aligned with real-world DevOps best practices.
