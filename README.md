# Cloud DevOps Migration Platform  
**Azure-to-AWS Migration | Terraform | ECS | CI/CD | Observability**

---

## Overview

This repository contains a **production-aligned Cloud DevOps migration project** completed as part of the **Sparknet DevOps Internship Program**.

The project demonstrates the **end-to-end lifecycle of migrating an intentionally misconfigured Azure-based application to AWS**, applying real-world DevOps engineering practices rather than tutorial-style shortcuts.

The focus is on:

- Identifying hidden misconfigurations
- Rebuilding infrastructure using **AWS-native services**
- Applying **Infrastructure as Code (Terraform)**
- Designing and validating **CI/CD pipelines**
- Debugging real deployment and runtime failures
- Practicing **cost-aware and security-first cloud operations**
- Producing **professional, interview-ready documentation**

This is not a “hello-world” deployment.  
It is a **failure-driven, reasoning-heavy DevOps project** designed to reflect how production systems are actually built, broken, fixed, and explained.

---

## Project Scope

The platform includes:

- A **Node.js backend API** deployed on AWS
- Containerization using **Docker**
- Infrastructure provisioning using **Terraform**
- Container orchestration via **Amazon ECS**
- Traffic routing through **Application Load Balancer (ALB)**
- Image storage in **Amazon ECR**
- CI/CD automation using **GitHub Actions**
- Observability through **Amazon CloudWatch**
- Secure integration with **MongoDB Atlas**
- Static frontend delivery via **Amazon S3 + CloudFront**
- Strict **cost controls and lifecycle management**

All infrastructure was:
- Provisioned via code
- Validated with evidence
- **Responsibly destroyed after completion** to avoid cloud costs

---

## Engineering Philosophy

This project follows these core principles:

- **Correctness over speed**
- **Infrastructure before workload**
- **Explicit dependencies over implicit behavior**
- **Fail-fast applications**
- **Observability before optimization**
- **Documentation as a first-class artifact**
- **Cost awareness as an engineering responsibility**

Every issue encountered is:
- Diagnosed
- Root-caused
- Fixed or intentionally deferred
- Clearly documented with rationale

---

## High-Level Architecture

The platform follows a **cloud-native, production-aligned AWS architecture**, designed with cost awareness, observability, and explicit dependency management.

All infrastructure is provisioned using **Terraform**, and workloads are deployed using **immutable container images**.

---

## Architecture Diagram 

![Cloud DevOps Migration Platform – End-to-End AWS Architecture](docs/architecture/full-end-to-end-architecture.png)


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


## Project Phases & Lifecycle

The project was executed using a **strict phase-based lifecycle**, mirroring how production DevOps teams plan, build, validate, pause, and tear down infrastructure.

Each phase had:
- A clearly defined objective
- Explicit entry and exit criteria
- Verification through logs, outputs, and evidence
- Documentation before moving forward

No phases were skipped, and no assumptions were made without validation.

---

### Phase 1 — Planning & Architecture Design

**Objective**
- Understand the original Azure-based project
- Identify intentional misconfigurations
- Design a production-aligned AWS target architecture

**Key Activities**
- Analyzed Sparknet internship requirements
- Reviewed broken Azure Terraform, Docker, and CI/CD logic
- Defined AWS-native architecture (ECS, ALB, ECR, CloudWatch)
- Selected tools based on learning depth and cost constraints
- Created a phase-by-phase execution roadmap

**Outcome**
- Clear architectural direction
- Execution plan aligned with real-world DevOps workflows

---

### Phase 2 — Application & Docker Validation

**Objective**
- Ensure the application was container-ready *before* cloud deployment

**Key Activities**
- Reviewed Node.js backend startup behavior
- Identified MongoDB as a hard runtime dependency
- Added and validated `/health` endpoint
- Fixed Dockerfile issues and added `.dockerignore`
- Built and tested Docker images locally
- Validated logs and failure behavior

**Outcome**
- Application confirmed suitable for ECS
- Fail-fast behavior preserved intentionally

---

### Phase 3 — AWS Infrastructure (Terraform)

**Objective**
- Build a clean, AWS-native platform using Infrastructure as Code only

**Key Activities**
- Secured AWS account (MFA, budgets, alerts)
- Created production-grade Terraform structure
- Archived legacy Azure Terraform to avoid state drift
- Provisioned:
  - VPC and public subnets
  - Internet Gateway and routing
  - Amazon ECR
  - ECS cluster (EC2 launch type)
  - Auto Scaling Group for ECS capacity
  - Application Load Balancer and target groups
  - IAM roles with least privilege
  - CloudWatch log groups

**Outcome**
- Fully reproducible, validated AWS infrastructure
- Clear separation between platform and workload

---

### Phase 4 — CI/CD Automation

**Objective**
- Automate build and deployment without compromising infrastructure safety

**Key Activities**
- Designed GitHub Actions pipeline
- Configured secure AWS authentication for CI
- Automated Docker build and push to Amazon ECR
- Triggered ECS rolling deployments
- Debugged real-world CI failures:
  - Credential mismatches
  - Docker build context issues
  - ECS service name mismatches

**Outcome**
- Production-grade CI/CD pipeline
- Immutable image-based deployments
- Infrastructure changes intentionally excluded from CI

---

### Phase 5 — Runtime Configuration & Observability

**Objective**
- Validate application behavior in the cloud and debug runtime failures

**Key Activities**
- Used CloudWatch Logs for root-cause analysis
- Identified MongoDB environment variable mismatch
- Verified ECS task lifecycle and health checks
- Distinguished infrastructure correctness from application misconfiguration
- Integrated MongoDB Atlas (Free Tier)

**Outcome**
- Runtime issues clearly diagnosed and resolved
- Strong observability-driven debugging practice demonstrated

---

### Phase 6 — Frontend Delivery Optimization

**Objective**
- Choose the correct platform for static frontend delivery

**Key Activities**
- Identified ECS as inefficient for static React frontend
- Migrated frontend to:
  - Amazon S3 (static website hosting)
  - Amazon CloudFront (CDN + HTTPS)
- Fixed CloudFront origin and SPA routing issues
- Verified frontend-backend integration

**Outcome**
- Simplified architecture
- Reduced cost and operational complexity
- Correct service-to-workload alignment

---

### Phase 7 — Validation, Teardown & Cost Control

**Objective**
- Complete the DevOps lifecycle responsibly

**Key Activities**
- Captured validation evidence (logs, screenshots)
- Scaled compute resources to zero
- Executed full `terraform destroy`
- Cleaned up ECR images manually (AWS safety constraint)
- Ensured near-zero ongoing cloud cost

**Outcome**
- Project fully validated and safely torn down
- Demonstrated cost-aware DevOps ownership

---

## Lifecycle Summary

This project reflects a **complete DevOps lifecycle**, including:

- Planning
- Building
- Debugging
- Automation
- Optimization
- Validation
- Teardown

The emphasis throughout was on **engineering judgment**, not superficial success.

## Key Engineering Challenges & What Was Learned

This project intentionally surfaced **real-world DevOps failures** across infrastructure, CI/CD, runtime configuration, and architecture decisions.  
Each challenge strengthened engineering judgment and reinforced production best practices.

---

### 1. Infrastructure vs Application Failure Ambiguity

**Challenge**  
ECS tasks repeatedly failed, leading to initial suspicion of:
- ECS configuration
- ALB health checks
- Networking or IAM issues

**Root Cause**  
CloudWatch Logs revealed the backend was exiting due to a missing runtime configuration (`MONGO_URI`).  
The infrastructure was correct — the application was not.

**What Was Learned**
- Infrastructure can be healthy while workloads fail
- Observability is the fastest path to truth
- Logs > assumptions

**Best Practice Applied**
- Always validate logs before changing infrastructure
- Treat runtime config as a first-class dependency

---

### 2. Terraform Module Design Errors

**Challenge**  
Terraform initialization failed with deeply nested module paths and recursion errors.

**Root Cause**  
Modules incorrectly referenced other modules and environment logic was placed inside module directories.

**What Was Learned**
- Terraform modules must be **acyclic**
- Environments should *consume* modules, never define them
- Clean module boundaries prevent state corruption

**Best Practice Applied**
- Strict separation:
  - `modules/` → resources only
  - `environments/` → orchestration only

---

### 3. ECS Capacity & Scheduling Failures

**Challenge**  
ECS service showed:
- Desired tasks: 1
- Running tasks: 0

**Root Cause**  
ECS EC2 launch type requires explicit compute capacity.  
No EC2 instances were registered with the cluster.

**What Was Learned**
- ECS ≠ compute
- Orchestration and capacity are separate responsibilities

**Best Practice Applied**
- Auto Scaling Group explicitly attached to ECS cluster
- Capacity verified before deploying workloads

---

### 4. Health Checks Tied to Database Availability

**Challenge**  
ALB health checks failed whenever MongoDB was unavailable.

**Root Cause**  
The application coupled its `/health` endpoint to database connectivity.

**What Was Learned**
- Health checks should reflect *service availability*, not dependency availability
- Hard dependencies cause cascading failures

**Best Practice Applied**
- Decoupled health checks from MongoDB state
- Preserved degraded-but-running behavior

---

### 5. CI/CD Authentication & Build Failures

**Challenge**  
GitHub Actions failed due to:
- Invalid AWS credentials
- Docker build context errors
- ECS service name mismatches

**Root Cause**  
CI pipelines are unforgiving:
- One incorrect path or name breaks automation

**What Was Learned**
- CI/CD requires the same rigor as production code
- Manual success does not imply automated success

**Best Practice Applied**
- Dedicated IAM user for CI
- Immutable image-based deployments
- Explicit perceived vs actual resource names verified via AWS CLI

---

### 6. Choosing the Wrong Platform for the Frontend

**Challenge**  
Frontend deployment on ECS failed due to:
- Memory constraints
- Capacity limitations
- Deployment circuit breaker triggers

**Root Cause**  
ECS is inefficient for static frontend workloads.

**What Was Learned**
- Good DevOps decisions include **not using a service**
- Architecture should match workload characteristics

**Best Practice Applied**
- Migrated frontend to:
  - Amazon S3 (static hosting)
  - CloudFront (CDN + HTTPS)

---

### 7. Cost Management & Lifecycle Ownership

**Challenge**  
Running ECS + ALB continuously risks unnecessary billing.

**What Was Learned**
- Cost optimization is part of DevOps responsibility
- Teardown is as important as provisioning

**Best Practice Applied**
- Scale-to-zero strategy
- Full Terraform destroy after validation
- Manual cleanup where AWS safety constraints apply

---

## Key Takeaways

- Debugging beats blind automation
- Observability enables confidence
- Infrastructure correctness ≠ application correctness
- Cost awareness is a core DevOps skill
- Clean documentation multiplies technical value

This project emphasizes **engineering maturity**, not just tool usage.

## Repository Structure & Navigation Guide

This repository is organized to reflect **real-world DevOps project structure**, with clear separation between application code, infrastructure, documentation, and evidence.

Every directory serves a specific purpose and aligns with industry best practices.

---

## Top-Level Structure

```text

.
├── README.md
├── .gitignore
│
├── app/                       # Application source code
│   ├── backend/               # Backend API service
│   │   ├── Dockerfile
│   │   ├── src/
│   │   ├── config/
│   │   ├── health/
│   │   └── package.json
│   │
│   └── frontend/              # Frontend (React SPA)
│       ├── Dockerfile
│       ├── public/
│       ├── src/
│       └── package.json
│
├── infra/                     # Infrastructure & platform code
│   └── terraform/
│       ├── modules/           # Reusable Terraform modules
│       │   ├── network/       # VPC, subnets, routing
│       │   ├── alb/           # Application Load Balancer
│       │   ├── ecs/           # ECS cluster, services, tasks
│       │   ├── iam/           # IAM roles and policies
│       │   └── ecr/           # Elastic Container Registry
│       │
│       └── environments/      # Environment-level orchestration
│           ├── dev/
│           │   ├── main.tf
│           │   ├── variables.tf
│           │   ├── terraform.tfvars
│           │   └── outputs.tf
│           │
│           └── prod/           # (Optional future expansion)
│               └── README.md
│
├── docs/                      # Documentation & evidence
│   ├── images/                # Architecture diagrams
│   │   └── architecture.png
│   │
│   ├── proof-of-concepts/     # Validation evidence
│   │   ├── terraform/
│   │   ├── alb-ecs/
│   │   ├── ci-cd/
│   │   └── final-deployment/
│   │
│   └── decisions/             # ADRs, design notes (optional)
│       └── architecture-decisions.md
│
└── .github/
    └── workflows/             # CI/CD automation
        └── ci-cd.yml


```

---

## Repository Structure & Navigation Guide

This repository is organized to reflect **real-world DevOps project structure**, with a clear separation of concerns across application code, infrastructure, CI/CD, and documentation.

---

## Directory Breakdown showing below

### `app/`
Contains all application-level code.

#### `backend/`
- Node.js API  
- Dockerized for Amazon ECS deployment  
- Implements health endpoint and runtime configuration handling  

#### `frontend/`
- React single-page application (SPA)  
- Built for static hosting  
- Deployed using Amazon S3 and CloudFront  

---

### `infra/terraform/`
Holds all **Infrastructure as Code (IaC)**.

#### `modules/`
- Reusable Terraform modules  
- Each module manages a **single responsibility**  
- No environment-specific logic inside modules  

#### `environments/dev/`
- Environment-specific orchestration  
- Wires Terraform modules together  
- **The only location where Terraform is executed**

> ⚠️ Terraform is intentionally excluded from CI/CD to prevent state corruption and uncontrolled infrastructure changes.

---

### `docs/`
Documentation and proof artifacts.

#### `images/`
- Architecture diagrams  
- Visual explanations used in README and reports  

#### `proof-of-concepts/`
Screenshots and evidence of:
- Terraform apply executions  
- AWS Console validation  
- CI/CD pipeline runs  
- Final deployment verification  

---

### `.github/workflows/`
CI/CD automation configuration.

#### `ci-cd.yml`
- Builds Docker images  
- Pushes images to Amazon ECR  
- Triggers ECS deployments  
- Uses scoped IAM credentials for security  

---

## How to Navigate This Repository

### If you are a reviewer or interviewer:
1. Start with `README.md`
2. Review `docs/images/architecture.png`
3. Skim `infra/terraform/environments/dev`
4. Inspect `.github/workflows/ci-cd.yml`
5. Check `docs/proof-of-concepts/` for validation evidence

---

### If you are resuming work:
1. Read `README.md`
2. Check Terraform state under `infra/terraform/environments/dev`
3. Scale resources consciously before running workloads

---

## Design Intent

This structure ensures:

- Clear ownership boundaries  
- Safe and controlled infrastructure changes  
- Easy onboarding for new engineers  
- Strong auditability and traceability  
- Clean and reviewable Git history  

It mirrors how **production-grade DevOps repositories** are organized and maintained.

---

## How to Run, Validate & Tear Down (Operational Guide)

This section documents **how the platform is operated safely**, following real-world DevOps operational discipline.

All actions are intentional, reversible, and cost-aware.

---

## Prerequisites

Before running any infrastructure or workloads, ensure the following are installed and configured:

- AWS CLI (configured with valid credentials)
- Terraform (compatible version as defined in `provider.tf`)
- Docker
- Git
- Access to a MongoDB Atlas cluster (Free Tier)

Verify AWS access:
```bash
aws sts get-caller-identity

Running the Infrastructure
    ⚠️ Terraform must be executed only from the environment directory.

Step 1 — Navigate to the Terraform Environment
- cd infra/terraform/environments/dev

Step 2 — Initialize Terraform
- terraform init

Step 3 — Review the Execution Plan
- terraform plan

Step 4 — Apply Infrastructure
- terraform apply

This provisions:
- Networking (VPC, subnets, routing)
- ECS cluster and compute capacity
- Application Load Balancer
- IAM roles and policies
- CloudWatch log groups

Running the Application (CI/CD)**
Application deployments are not performed manually.

Deployment Flow
- Code pushed to the main branch
- GitHub Actions pipeline triggers automatically
- Docker image is built
- Image is pushed to Amazon ECR
- ECS service performs a rolling deployment
- No manual ECS or Docker commands are required for deployments

Validation & Verification
Infrastructure Validation
- Confirm Terraform apply completed without errors
- Verify resources in AWS Console:
    -ECS Cluster
    -ALB
    -EC2 instances
    -Target group health

Application Validation
- Check CloudWatch Logs for backend startup messages
- Confirm /health endpoint responds successfully
- Verify ALB target group shows healthy targets

Frontend Validation
- Access the CloudFront distribution URL
- Confirm SPA loads correctly
- Validate API integration with backend

Observability & Debugging
All runtime debugging is performed using Amazon CloudWatch Logs.
Key indicators:

- Container startup logs
- Environment variable validation
- MongoDB connection status
- ECS task lifecycle events

This ensures issues are correctly classified as:

- Infrastructure-related
- CI/CD-related
- Application runtime-related

Cost Control & Safe Pause
- To prevent unnecessary cloud costs, compute resources are intentionally scaled down when not in use.
- Scale ECS Service to Zero
aws ecs update-service \
  --cluster <cluster-name> \
  --service <service-name> \
  --desired-count 0

Scale Auto Scaling Group to Zero
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name <asg-name> \
  --min-size 0 \
  --desired-capacity 0 \
  --max-size 0

This preserves infrastructure while stopping all compute billing.

Tear Down (Final Cleanup)
Once validation and documentation are complete, all infrastructure is destroyed responsibly.

Step 1 — Navigate to Terraform Environment
- cd infra/terraform/environments/dev

Step 2 — Destroy Infrastructure
- terraform destroy

Important Notes
- ECR repositories may require manual image deletion before destroy
- MongoDB Atlas resources are managed separately
- CloudFront distributions may take time to fully delete

```

## Security, Cost Controls & Best Practices

Security and cost management were treated as **core engineering responsibilities**, not post-deployment afterthoughts.  
All design decisions were guided by **least privilege**, **blast-radius reduction**, and **cost-aware cloud usage**.

---

## Security Practices

### 1. AWS Account Security

**Measures Implemented**
- Root account MFA enabled
- Dedicated IAM users created for:
  - Terraform operations
  - CI/CD automation
- Root credentials never used for daily operations

**Why This Matters**
- Prevents catastrophic account compromise
- Aligns with AWS Well-Architected Framework
- Mirrors enterprise security posture

---

### 2. IAM & Least-Privilege Access

**Implementation**
- Separate IAM roles created for:
  - ECS task execution
  - ECS application runtime
- CI/CD IAM user scoped to:
  - ECR push permissions
  - ECS service update permissions
- No wildcard (`*`) permissions where avoidable

**Best Practice Applied**
- Identity-based access control
- Role separation between infrastructure and workloads
- Explicit permission boundaries

---

### 3. Secrets & Configuration Management

**Practices Followed**
- No secrets hardcoded in:
  - Source code
  - Dockerfiles
  - CI/CD pipelines
- Sensitive configuration injected at runtime via:
  - ECS task definition environment variables

**Current Limitation**
- AWS Secrets Manager intentionally not used to stay within Free Tier constraints

**Best Practice Alignment**
- Runtime configuration over baked-in secrets
- Clear separation between code and configuration

---

### 4. Network Security

**Design Choices**
- Custom VPC with controlled routing
- ALB exposed publicly
- ECS tasks placed behind ALB
- MongoDB Atlas access restricted via IP allowlist

**Trade-Off Acknowledged**
- Public subnets used for simplicity and cost control
- Private subnet model documented as future enhancement

---

### 5. Container Security

**Practices Applied**
- Minimal base images
- No credentials inside images
- Immutable image deployment model
- Images rebuilt on every deployment

**Planned Enhancements**
- Trivy image scanning integrated into CI/CD
- Fail pipeline on high/critical vulnerabilities

---

## Cost Control Strategy

Cost optimization was treated as an **active DevOps responsibility**, not a cleanup task.

---

### 1. Account-Level Guardrails

**Implemented**
- AWS budgets with minimal threshold alerts
- Billing alarms enabled
- Region restricted to `ap-south-1`

**Outcome**
- Early warning against unexpected billing
- Safe experimentation in a paid account

---

### 2. Resource Selection & Sizing

**Cost-Aware Choices**
- ECS EC2 launch type with:
  - `t3.micro` instances
- MongoDB Atlas M0 Free Tier
- S3 + CloudFront for frontend instead of ECS

**Rationale**
- Free Tier compatibility
- Predictable cost profile
- Minimal idle spend

---

### 3. Scale-to-Zero Strategy

**Practices**
- ECS service scaled to zero when idle
- Auto Scaling Group scaled to zero
- EC2 instances terminated automatically

**Outcome**
- Near-zero runtime cost
- Infrastructure preserved for resumption

---

### 4. Controlled Teardown

**Final Cleanup**
- Terraform destroy executed after validation
- Manual ECR image cleanup where required
- CloudFront distribution deletion managed carefully

**Why This Matters**
- Prevents orphaned resources
- Demonstrates lifecycle ownership

---

## DevOps & Engineering Best Practices

### Infrastructure as Code (IaC)
- Terraform used exclusively for infrastructure
- No manual console changes
- Modular, reusable codebase

---

### CI/CD Discipline
- CI/CD handles:
  - Build
  - Push
  - Deploy
- CI/CD does **not** handle:
  - Terraform apply
  - Infrastructure changes

**Rationale**
- Prevents state corruption
- Aligns with enterprise separation of concerns

---

### Observability-First Debugging
- CloudWatch Logs as the primary debugging tool
- Logs used to differentiate:
  - Infra failures
  - App failures
  - Configuration issues

---

### Fail-Fast Philosophy
- Application exits clearly on misconfiguration
- Errors surfaced early via logs
- Prevents silent partial failures

---

### Documentation as a Deliverable
- Every failure documented
- Every fix justified
- Evidence captured via screenshots
- Decisions recorded for interviews and audits

---

## Summary

This project demonstrates **production-grade DevOps thinking** by:

- Securing systems before scaling them
- Controlling cost before adding features
- Debugging with evidence, not assumptions
- Treating teardown as part of delivery
- Aligning architecture with workload needs

These practices reflect how **real cloud platforms are built, operated, and responsibly retired**.

## Future Improvements & Production Enhancements

While the project meets all internship and evaluation objectives, several enhancements were **intentionally deferred** to maintain cost control, scope discipline, and clarity of learning outcomes.

The following improvements represent **realistic next steps** for evolving this platform toward a full production-grade system.

---

## 1. Secrets Management & Configuration Hardening

### Planned Enhancements
- Migrate runtime secrets to **AWS Secrets Manager**
- Inject secrets into ECS tasks using:
  - Secrets Manager ARNs
  - Secure environment variable references
- Rotate credentials automatically

### Why This Matters
- Eliminates plaintext secrets in task definitions
- Improves auditability and compliance
- Aligns with enterprise security standards

---

## 2. Private Networking & Zero-Trust Architecture

### Planned Enhancements
- Move ECS tasks to **private subnets**
- Restrict outbound access using NAT Gateway
- Use **security groups as primary trust boundaries**

### Benefits
- Reduced attack surface
- Improved defense-in-depth
- Better isolation between tiers

---

## 3. CI/CD Security & Quality Gates

### Planned Enhancements
- Integrate **Trivy** for container image scanning
- Fail CI pipeline on:
  - High or critical vulnerabilities
- Add linting and unit test stages

### Benefits
- Shift-left security
- Enforced quality standards
- Early detection of regressions

---

## 4. Blue/Green & Safer Deployments

### Planned Enhancements
- Enable ECS deployment circuit breaker
- Implement:
  - Blue/Green deployments
  - Automated rollback on failure
- Integrate ALB weighted routing

### Benefits
- Zero-downtime deployments
- Reduced production risk
- Safer experimentation

---

## 5. Observability & Monitoring Expansion

### Planned Enhancements
- Create CloudWatch dashboards for:
  - ECS service health
  - ALB request metrics
  - Error rates and latency
- Add alerting for:
  - Task failures
  - Unhealthy targets
  - Budget threshold breaches

### Optional Enhancements
- Prometheus + Grafana integration
- Distributed tracing (OpenTelemetry)

---

## 6. Infrastructure & State Management Improvements

### Planned Enhancements
- Remote Terraform state using:
  - S3 backend
  - DynamoDB state locking
- Multi-environment support:
  - `dev`
  - `staging`
  - `prod`

### Benefits
- Safer collaboration
- Reduced risk of state corruption
- Enterprise-ready IaC workflows

---

## 7. Frontend Enhancements

### Planned Enhancements
- Custom domain with Route 53
- HTTPS via ACM-managed certificates
- Cache invalidation automation on deploy

### Benefits
- Improved user experience
- Better SEO and security posture

---

## 8. Security & Compliance Enhancements

### Planned Enhancements
- AWS WAF integration
- IAM Access Analyzer
- Automated security posture checks
- Log retention and archival policies

### Benefits
- Stronger compliance readiness
- Improved threat detection

---

## Summary

These enhancements are **not theoretical** — they represent the natural evolution path of a real-world cloud platform.

They were intentionally deferred to:
- Preserve focus on core DevOps principles
- Avoid unnecessary cloud costs
- Maintain clarity of scope


