# ADR-003: Infrastructure as Code & Environment Strategy

## Status
Accepted

---

## 1. Context

The original project included Terraform-based infrastructure definitions that were:
- Tightly coupled to Azure-specific resources
- Structured in a flat, non-modular manner
- Difficult to reason about, reuse, or migrate
- Prone to state confusion and accidental changes

As part of the migration to AWS, a **fundamental redesign of the Infrastructure as Code (IaC) strategy** was required.  
This redesign needed to support:
- Safe cloud migration
- Clear ownership boundaries
- Reproducibility and teardown
- Environment isolation
- Real-world DevOps operational discipline

This ADR documents how infrastructure is defined, organized, executed, and governed in this project.

---

## 2. Decision

The project adopts a **Terraform-only Infrastructure as Code strategy** with:

- Strict separation between **reusable modules** and **environment orchestration**
- Explicit, environment-scoped Terraform execution
- Manual, human-controlled Terraform applies (excluded from CI/CD)
- Clear dependency management and minimal implicit behavior

This approach prioritizes **correctness, safety, and reasoning clarity** over speed or automation volume.

---

## 3. Decision Drivers

The decision was driven by the following factors:

- Need for predictable and auditable infrastructure changes
- Prevention of Terraform state corruption
- Desire to reflect real enterprise DevOps workflows
- Support for clean migration and teardown
- Alignment with Free Tier and cost-aware constraints
- Clear separation of responsibility between:
  - Infrastructure provisioning
  - Application delivery
  - Runtime configuration

---

## 4. Infrastructure as Code Strategy

### 4.1 Terraform as the Sole IaC Tool

Terraform is used exclusively for infrastructure provisioning.

**Principles Applied**
- No manual AWS Console changes
- All resources defined declaratively
- Infrastructure treated as immutable and reproducible
- State represents the single source of truth

This ensures that:
- Infrastructure can be recreated reliably
- Changes are reviewable via code
- Drift is minimized and detectable

---

### 4.2 Modular Terraform Design

Infrastructure is decomposed into **reusable, single-responsibility modules**, including but not limited to:
- Networking (VPC, subnets, routing)
- Load balancing (ALB)
- Container platform (ECS, ASG)
- IAM roles and policies
- Container registry (ECR)

**Module Design Rules**
- Modules contain **only resource definitions**
- Modules do **not** reference other modules
- Modules contain no environment-specific logic
- Inputs and outputs are explicit and well-defined

This prevents:
- Recursive module dependencies
- Hidden coupling
- Fragile infrastructure graphs

---

### 4.3 Environment-Scoped Orchestration

Terraform execution occurs **only within environment directories**, such as:

infra/terraform/environments/dev

**Environment directories are responsible for:**
- Wiring modules together
- Supplying environment-specific variables
- Defining resource relationships

Important Constraint:
Terraform must never be executed from the module directories.

This pattern:
- Mirrors real enterprise Terraform usage
- Enables multi-environment expansion (dev, staging, prod)
- Reduces blast radius of changes

### 4.4 State Management Strategy

For this project:
- Terraform state is managed locally
- Single-engineer workflow is assumed
- State is destroyed along with infrastructure

Rationale
- Simplifies setup
- Avoids unnecessary cloud resources
- Matches internship and evaluation constraints

Documented Future Enhancement
- Remote state via S3 backend
- State locking using DynamoDB
- Multi-user collaboration support

## 5. CI/CD Exclusion from Infrastructure Changes
Terraform execution is explicitly excluded from CI/CD pipelines.

**Rationale**
Allowing CI/CD systems to:
- Apply infrastructure
- Modify Terraform state

**Introduces significant risk:**
- Accidental destructive changes
- State corruption
- Reduced human oversight
- Difficult rollbacks

**Instead:**
- CI/CD is responsible only for application delivery
- Infrastructure changes require deliberate human approval
- This reflects mature DevOps governance, not reduced automation capability.

## 6. Environment Strategy
### 6.1 Single Active Environment

**The project operates with a single active environment (dev) due to:**
- Free Tier cost constraints
- Single-engineer scope
- Focus on correctness over scale

**This decision avoids:**
- Artificial complexity
- Redundant infrastructure
- Misleading production claims

### 6.2 Future Multi-Environment Readiness

**The directory structure and Terraform design allow for:**
- staging
- production
to be added without refactoring core modules.

**This ensures:**
- Architectural scalability
- Enterprise-aligned growth path

## 7. Consequences
**Positive Consequences**
- Predictable and auditable infrastructure changes
- Clear separation of responsibilities
- Reduced risk of destructive actions
- Clean teardown and cost control
- Strong interview defensibility

**Trade-offs**
- Infrastructure changes are not fully automated
- Manual Terraform execution requires discipline
- Slower iteration compared to aggressive automation
- These trade-offs were accepted intentionally to favor safety and clarity.

## 8. Relationship to Other ADRs
**This decision directly supports:**
ADR-001: Technology Stack Selection
ADR-002: Container Orchestration Strategy
ADR-004: CI/CD Responsibility Boundaries

Together, these ADRs establish a coherent and defensible DevOps architecture.

## 9. Summary
**This Infrastructure as Code and Environment Strategy:**
- Treats infrastructure as a controlled system
- Prioritizes safety over blind automation
- Enables reproducibility, auditability, and cost awareness
- Reflects how real DevOps teams manage cloud platforms
**The strategy reinforces the project’s core philosophy:**
Infrastructure should be boring, predictable, and explainable.

---