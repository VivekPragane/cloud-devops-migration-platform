# ADR-004: CI/CD Design & Responsibility Boundaries

## Status
Accepted

---

## 1. Context

The original Azure-based project included a CI/CD pipeline that was:
- Tightly coupled to cloud-specific assumptions
- Poorly separated from infrastructure concerns
- Difficult to debug when failures occurred
- Lacking clear responsibility boundaries

As part of migrating the platform to AWS and stabilizing the DevOps workflow, a clear decision was required regarding **what CI/CD should do—and what it should explicitly not do**.

In real-world DevOps environments, CI/CD pipelines are a powerful automation tool, but they can also become a source of significant risk if responsibilities are poorly defined. This ADR documents the **intentional boundaries** placed around CI/CD in this project.

---

## 2. Decision

The CI/CD pipeline is designed with **strictly limited and explicit responsibilities**:

### CI/CD is responsible for:
- Building Docker images
- Pushing images to Amazon ECR
- Triggering ECS service deployments

### CI/CD is explicitly NOT responsible for:
- Provisioning infrastructure
- Running `terraform apply` or `terraform destroy`
- Modifying Terraform state
- Managing cloud networking or IAM resources

All infrastructure changes are performed **manually and deliberately** using Terraform from environment-specific directories.

---

## 3. Decision Drivers

This decision was guided by the following drivers:

- Protection of Terraform state integrity
- Reduction of blast radius for automated actions
- Clear separation of concerns
- Improved debuggability and auditability
- Alignment with real-world enterprise DevOps practices
- Suitability for a single-engineer, learning-focused project

---

## 4. CI/CD Design Philosophy

### 4.1 CI/CD as a Delivery Mechanism

In this project, CI/CD is treated as a **delivery pipeline**, not a platform controller.

Its role is to:
- Turn source code into immutable artifacts (Docker images)
- Deliver those artifacts to a runtime platform
- Trigger controlled, observable deployments

This keeps CI/CD:
- Predictable
- Easy to reason about
- Easy to debug

---

### 4.2 Separation of Infrastructure and Delivery

Infrastructure and delivery operate on **different lifecycles**:

| Concern | Lifecycle | Tool |
|------|---------|------|
| Infrastructure | Infrequent, deliberate | Terraform |
| Application Delivery | Frequent, automated | GitHub Actions |

Blending these concerns increases risk and reduces clarity.

By separating them:
- Infrastructure remains stable
- Application delivery remains fast
- Failures are easier to classify

---

## 5. CI/CD Workflow Overview

The CI/CD pipeline follows this high-level flow:

1. Developer pushes code to the `main` branch
2. GitHub Actions workflow is triggered
3. Docker image is built
4. Image is tagged and pushed to Amazon ECR
5. ECS service deployment is triggered
6. ECS performs a rolling deployment
7. Runtime behavior is observed via CloudWatch Logs

No infrastructure is created, modified, or destroyed during this process.

---

## 6. Authentication & Security Model

### 6.1 CI/CD Credentials

- A dedicated IAM user is used for CI/CD
- Permissions are scoped to:
  - ECR image push
  - ECS service update
- No administrative permissions are granted

### 6.2 Security Benefits

This approach:
- Limits blast radius if credentials are compromised
- Prevents CI/CD from performing destructive actions
- Aligns with least-privilege principles

---

## 7. Failure Handling & Observability

CI/CD failures are treated as **first-class signals**, not incidental noise.

Failures may occur due to:
- Authentication issues
- Docker build context errors
- Incorrect resource naming
- Runtime configuration problems

All failures are:
- Visible in GitHub Actions logs
- Traceable to a specific pipeline stage
- Correlated with ECS and CloudWatch logs

This reinforces **observability-driven debugging**.

---

## 8. Alternatives Considered

### 8.1 Fully Automated Infrastructure via CI/CD
**Rejected**

Reasons:
- High risk of accidental destruction
- Poor state visibility
- Difficult rollbacks
- Not aligned with learning goals

---

### 8.2 GitOps-Style Infrastructure Automation
**Rejected**

Reasons:
- Adds conceptual overhead
- Requires additional tooling
- Not necessary for project scope

---

### 8.3 Manual-Only Deployments
**Rejected**

Reasons:
- Reduces repeatability
- Increases human error
- Does not reflect modern DevOps workflows

---

## 9. Consequences

### Positive Consequences
- Strong safety guarantees for infrastructure
- Clear ownership boundaries
- Easier debugging and reasoning
- Enterprise-aligned DevOps model
- Interview-ready explanations

### Trade-offs
- Infrastructure changes require manual execution
- Slightly slower infra iteration
- CI/CD automation scope is intentionally limited

These trade-offs were **accepted intentionally**.

---

## 10. Relationship to Other ADRs

This ADR directly complements:
- **ADR-001:** Technology Stack Selection
- **ADR-002:** Container Orchestration Strategy
- **ADR-003:** Infrastructure as Code & Environment Strategy
- **ADR-005 (Planned):** Frontend Deployment Strategy

Together, these decisions form a coherent DevOps architecture with clear responsibility boundaries.

---

## 11. Summary

The CI/CD design in this project prioritizes:
- Safety over excessive automation
- Clarity over convenience
- Observability over opacity

By explicitly limiting CI/CD responsibilities, the project demonstrates **mature DevOps governance** and real-world operational thinking.

> **Automation should accelerate delivery—not amplify risk.**
