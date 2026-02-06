## Architecture Overview

The platform follows a **layered, production-aligned AWS architecture** designed to clearly separate
development workflows, delivery automation, infrastructure, runtime execution, and observability.

All infrastructure is provisioned using **Terraform**, while application delivery is automated via
**GitHub Actions**, following strict responsibility boundaries.

The architecture emphasizes:
- Clear separation of concerns
- Observability-driven debugging
- Cost-aware design
- Safe automation
- Real-world DevOps operational practices

## Architecture Layers

### Layer 1 — Development & Source Control
- Developers work locally using Docker and Terraform
- Code is pushed to the GitHub repository (`main` branch)
- Each push acts as the trigger point for CI/CD

---

### Layer 2 — CI/CD Pipeline (GitHub Actions)
- GitHub Actions handles **application delivery only**
- Pipeline responsibilities include:
  - Source checkout
  - Secure AWS authentication
  - Docker image build
  - Image push to Amazon ECR
  - ECS service update (force new deployment)

> ⚠️ Infrastructure provisioning is intentionally excluded from CI/CD to prevent
Terraform state corruption and uncontrolled changes.

---

### Layer 3 — AWS Networking Foundation
- Custom VPC (`10.0.0.0/16`) in `ap-south-1`
- Public subnets across multiple Availability Zones
- Internet Gateway and route tables configured for controlled access

This design prioritizes **simplicity and Free Tier compatibility** while remaining production-aligned.

---

### Layer 4 — Container Platform (Amazon ECS – EC2 Launch Type)
- ECS cluster backed by EC2 instances managed via Auto Scaling Group
- EC2 launch type selected intentionally to:
  - Expose orchestration internals
  - Enable deeper infrastructure learning
  - Maintain predictable cost behavior

Backend service:
- Deployed as an ECS service
- Runs inside Docker containers
- Receives runtime configuration via environment variables
- Uses IAM instance profiles for AWS access

---

### Layer 5 — Load Balancing & Frontend Delivery
- Application Load Balancer (ALB):
  - Routes traffic to ECS backend service
  - Uses instance-based target groups (required for EC2 launch type)
  - Performs health checks independent of database availability

Frontend:
- Built React application hosted on Amazon S3
- Served globally via Amazon CloudFront
- Decoupled from backend compute to reduce cost and complexity

This separation ensures frontend availability even if backend services are degraded.

---

### Layer 6 — Data & Observability
- MongoDB Atlas (M0 Free Tier) used as an external managed database
- Backend connects securely via runtime environment variables
- Application and infrastructure logs streamed to Amazon CloudWatch
- CloudWatch used as the primary debugging and observability tool

No SSH-based debugging is required or used.

## Key Architectural Decisions

- ECS EC2 launch type was chosen over Fargate to enable deeper understanding of
  container scheduling, capacity management, and orchestration behavior
- Frontend was moved from ECS to S3 + CloudFront after identifying ECS as an
  inefficient platform for static workloads
- CI/CD responsibilities were strictly limited to application delivery
- Infrastructure lifecycle is controlled manually using Terraform
- Observability was prioritized over premature optimization
- Cost control and teardown are treated as first-class DevOps responsibilities

This architecture reflects a **complete DevOps lifecycle**—from code commit to
production deployment, observability, and responsible teardown—designed to
demonstrate real-world engineering judgment rather than tutorial-style automation.
