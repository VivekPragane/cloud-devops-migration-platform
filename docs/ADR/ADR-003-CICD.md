# ADR-003: CI/CD Pipeline Design

## Status
Accepted

---

## 1. Context

The project includes an existing CI/CD pipeline that is configured with cloud-specific
assumptions and lacks proper validation, error handling, and deployment consistency.
The current pipeline does not fully support containerized deployments or infrastructure
changes in a reliable and repeatable manner.

As part of the migration from Azure to AWS, the CI/CD pipeline must be redesigned to
support automated builds, testing, and deployments while remaining simple, transparent,
and closely integrated with the source code repository.

---

## 2. Decision

GitHub Actions is selected as the CI/CD platform to implement automated pipelines for:

- Building backend and frontend Docker images
- Running basic validation checks
- Pushing images to Amazon ECR
- Deploying infrastructure and services on AWS

The pipeline is structured into clearly defined stages to improve readability,
maintainability, and failure isolation.

---

## 3. Pipeline Design Overview

The CI/CD workflow follows a stage-based approach:

1. **Source Control Trigger**
   - Pipeline is triggered on changes to the main branch
   - Ensures deployments are driven by version-controlled changes

2. **Build Stage**
   - Application code is built and packaged into Docker images
   - Build failures stop the pipeline immediately

3. **Validation Stage**
   - Basic checks ensure Docker images are created successfully
   - Early detection of configuration or build errors

4. **Deployment Stage**
   - Docker images are pushed to Amazon ECR
   - Infrastructure and services are updated using defined deployment steps

This design ensures that errors are detected early and deployments remain predictable.

---

## 4. Rationale

### GitHub Actions
GitHub Actions is tightly integrated with the source repository, reducing operational
overhead and eliminating the need for external CI/CD tools. It provides sufficient
flexibility for container-based workflows and infrastructure automation.

### Stage-Based Pipeline
Separating the pipeline into distinct stages improves clarity and troubleshooting.
Failures can be traced to specific stages, reducing debugging time and improving
developer feedback.

### Container-Centric Workflow
The pipeline treats Docker images as the primary deployment artifact. This ensures
consistency between local development, CI environments, and production deployments.

### Automation and Repeatability
Automating build and deployment steps reduces manual intervention and ensures that
deployments are repeatable and auditable.

---

## 5. Alternatives Considered

### Jenkins
Jenkins offers extensive flexibility but requires additional infrastructure management
and maintenance. This introduces unnecessary complexity for the scope of the project.

### GitLab CI/CD
GitLab CI/CD provides strong features but requires migrating the repository or maintaining
additional tooling, which is not aligned with the project constraints.

### Manual Deployment
Manual deployment was not considered viable due to the increased risk of human error and
lack of repeatability.

---

## 6. Security Considerations

- Secrets are managed using GitHub repository secrets
- Sensitive values are not stored in the codebase
- Least-privilege access is applied to AWS credentials
- Pipeline logs are reviewed to ensure no sensitive data is exposed

These measures reduce security risks while maintaining automation.

---

## 7. Consequences

### Positive Consequences
- Clear and maintainable CI/CD workflows
- Faster feedback on build and deployment failures
- Improved consistency across environments
- Strong alignment with DevOps automation principles

### Trade-offs
- GitHub Actions is dependent on GitHub availability
- Pipeline complexity increases as infrastructure grows
- Requires careful management of secrets and permissions

---

## 8. Summary

The selected CI/CD design provides a balanced and practical approach to automation.
By using GitHub Actions with a structured, container-centric workflow, the pipeline
supports reliable builds and deployments while remaining easy to understand and maintain.

This CI/CD approach reinforces DevOps best practices and enables efficient cloud migration
with minimal operational overhead.
