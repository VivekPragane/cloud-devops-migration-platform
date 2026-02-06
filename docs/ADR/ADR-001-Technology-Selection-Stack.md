# ADR-001: Technology Stack Selection

## Status
Accepted

---

## 1. Context

This project is part of the **Sparknet DevOps Internship Program**, where the provided system is an **intentionally misconfigured Azure-oriented DevOps application**.

The existing solution includes:
- Backend and frontend application components
- Docker-based containerization
- Terraform-based infrastructure definitions
- GitHub Actions for CI/CD automation

However, the system suffers from **systemic issues** across configuration management, infrastructure design, containerization, and deployment automation. These issues prevent the application from being production-ready and make safe cloud migration difficult.

The primary goal of this project is **not feature development**, but to:
- Diagnose real-world DevOps failures
- Apply production-grade DevOps practices
- Migrate the platform to AWS using a **clean, defensible, and reproducible design**
- Operate under **Free Tier and cost-aware constraints**

The technology stack therefore needed to:
- Support containerized workloads
- Enable Infrastructure as Code (IaC)
- Allow CI/CD automation
- Be simple enough to reason about failures
- Reflect tools commonly used in real DevOps teams

---

## 2. Decision

The following technology stack was selected:

- **Backend:** Node.js  
- **Frontend:** React  
- **Containerization:** Docker  
- **Infrastructure as Code:** Terraform  
- **CI/CD Automation:** GitHub Actions  
- **Cloud Provider:** Amazon Web Services (AWS)  

This stack was chosen to **maximize DevOps learning value** while maintaining production relevance and cost discipline.

---

## 3. Decision Drivers

The decision was guided by the following drivers:

- Focus on DevOps engineering, not application rewrites
- Ability to observe and debug failures across layers
- Cloud migration realism (Azure → AWS)
- Cost and Free Tier compatibility
- Industry relevance and interview defensibility
- Toolchain simplicity over unnecessary complexity

---

## 4. Rationale (Detailed)

### 4.1 Node.js (Backend)

- Already present in the existing application
- Avoids unnecessary refactoring
- Allows focus on:
  - Runtime configuration issues
  - Dependency handling
  - Health checks and logging
- Commonly used in production microservices

**DevOps Value:**  
Highlights runtime misconfigurations and fail-fast behavior in containerized systems.

---

### 4.2 React (Frontend)

- Existing frontend technology
- Suitable for static hosting
- Enables separation between frontend delivery and backend compute

**DevOps Value:**  
Demonstrates correct workload-to-platform alignment (S3 + CloudFront vs ECS).

---

### 4.3 Docker (Containerization)

- Standard container runtime across cloud platforms
- Enables consistent, repeatable builds
- Makes configuration errors visible at runtime
- Aligns with ECS deployment model

**DevOps Value:**  
Allows clear separation between build-time and run-time concerns.

---

### 4.4 Terraform (Infrastructure as Code)

- Declarative, version-controlled infrastructure
- Cloud-agnostic workflow (even if providers differ)
- Enables safe teardown and rebuild
- Industry standard for infrastructure automation

**DevOps Value:**  
Reinforces reproducibility, modular design, and dependency management.

---

### 4.5 GitHub Actions (CI/CD Automation)

- Native integration with the source repository
- Supports secure, event-driven workflows
- Sufficient for build-and-deploy automation
- Avoids additional tooling overhead

**DevOps Value:**  
Highlights real-world CI/CD failure modes (auth, paths, naming, permissions).

---

### 4.6 Amazon Web Services (AWS)

- Rich ecosystem for containerized workloads
- ECS provides managed orchestration without Kubernetes overhead
- CloudWatch enables strong observability
- Free Tier compatibility supports safe experimentation

**DevOps Value:**  
Allows demonstration of real AWS operational patterns used in industry.

---

## 5. Alternatives Considered

### 5.1 Changing Application Frameworks
**Rejected**
- Would distract from DevOps objectives
- Introduces unnecessary risk
- Not aligned with problem-solving focus

---

### 5.2 Kubernetes (EKS)

**Rejected**
- Adds operational complexity
- Obscures infrastructure fundamentals
- Not required for project scope

---

### 5.3 Other CI/CD Platforms (Jenkins, GitLab CI)

**Rejected**
- Additional operational overhead
- No clear advantage over GitHub Actions
- Reduced repository cohesion

---

### 5.4 Other Cloud Providers

**Rejected**
- AWS selected for:
  - ECS maturity
  - Observability
  - Free Tier flexibility
  - Industry demand

---

## 6. Consequences

### Positive Consequences
- Clear separation of concerns
- Strong alignment with industry DevOps workflows
- Simplified debugging and reasoning
- Cost-aware and reproducible architecture
- Interview-ready explanations

### Trade-offs
- AWS-specific resource definitions
- Limited orchestration flexibility compared to Kubernetes
- Advanced enterprise features intentionally excluded

---

## 7. Review & Evolution

This decision may evolve in a future iteration to include:
- Kubernetes-based orchestration
- Advanced CI/CD tooling
- Multi-cloud abstractions

However, for the current scope, the selected stack provides the **best balance between simplicity, realism, and learning depth**.

---

## 8. Summary

The selected technology stack enables this project to focus on **DevOps engineering fundamentals**:
- Debugging real failures
- Designing reproducible infrastructure
- Automating delivery safely
- Operating within real-world constraints

This decision supports the project’s core goal:  
**demonstrating production-grade DevOps reasoning, not tool accumulation**.

