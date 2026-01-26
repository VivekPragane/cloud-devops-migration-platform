# ADR-001: Technology Stack Selection

## Status
Accepted

---

## 1. Context

The project involves analyzing an existing Azure-based DevOps application that contains
multiple configuration and architectural issues. The goal is to identify these issues,
apply industry-standard DevOps practices, and migrate the solution to AWS while ensuring
the final system is production-ready.

The technology stack must support containerization, infrastructure automation, CI/CD,
and cloud portability while remaining simple, maintainable, and compatible with Free Tier
constraints.

---

## 2. Decision

The following technology stack has been selected for this project:

- **Backend:** Node.js  
- **Frontend:** React  
- **Containerization:** Docker  
- **Infrastructure as Code:** Terraform  
- **CI/CD Automation:** GitHub Actions  
- **Cloud Provider:** Amazon Web Services (AWS)

---

## 3. Rationale

The chosen stack aligns with both the project requirements and real-world DevOps practices.

- **Node.js and React**  
  These technologies are already used in the existing application, reducing unnecessary
  refactoring and allowing focus on DevOps improvements rather than application rewrites.

- **Docker**  
  Docker provides a consistent and repeatable runtime environment, which is essential for
  identifying configuration issues and ensuring reliable deployments across environments.

- **Terraform**  
  Terraform enables infrastructure to be managed declaratively and version-controlled.
  Using Terraform also supports cloud migration by allowing infrastructure definitions to
  be adapted without changing the core workflow.

- **GitHub Actions**  
  GitHub Actions integrates directly with the source repository and supports automated
  build, test, and deployment workflows without requiring additional CI/CD tools.

- **AWS**  
  AWS offers Free Tier compatible services, strong documentation, and managed services
  suitable for containerized workloads. It also serves as a practical target cloud for
  demonstrating real-world migration scenarios.

---

## 4. Alternatives Considered

Several alternatives were considered but not selected:

- **Changing backend or frontend frameworks**  
  Rewriting application code would shift focus away from DevOps objectives and introduce
  unnecessary risk.

- **Using Kubernetes**  
  Kubernetes provides advanced orchestration features but adds operational complexity that
  is not required for the scope of this project.

- **Using other CI/CD tools**  
  External CI/CD platforms were not selected to keep the toolchain minimal and tightly
  integrated with the repository.

---

## 5. Consequences

### Positive Consequences
- Clear separation between application and infrastructure concerns
- Improved portability and reproducibility
- Simplified CI/CD automation
- Alignment with common industry DevOps workflows

### Trade-offs
- Limited orchestration features compared to full Kubernetes-based solutions
- AWS-specific infrastructure definitions require careful abstraction to avoid lock-in

---

## 6. Summary

The selected technology stack provides a balanced approach between simplicity and
production readiness. It enables the project to focus on identifying and resolving real
DevOps misconfigurations while delivering a maintainable, automated, and cloud-ready
solution.
