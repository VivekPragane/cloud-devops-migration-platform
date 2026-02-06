# ADR-005: Frontend Deployment Strategy (ECS vs S3 + CloudFront)

## Status
Accepted

---

## 1. Context

The project includes a **React-based frontend single-page application (SPA)** that initially appeared suitable for containerized deployment alongside the backend service.

During early design and implementation, the frontend was considered for deployment using:
- Amazon ECS (EC2 launch type), behind an Application Load Balancer

However, as the infrastructure and runtime behavior were validated, it became necessary to **re-evaluate whether ECS was the appropriate platform** for a static frontend workload.

This ADR documents the decision-making process that led to **abandoning ECS for frontend deployment** in favor of **Amazon S3 with CloudFront**.

---

## 2. Decision

The frontend application is deployed using:

- **Amazon S3** for static website hosting  
- **Amazon CloudFront** for CDN, HTTPS, and global distribution  

The frontend is **not deployed on ECS**.

This decision aligns the workload with the most appropriate AWS services based on its characteristics.

---

## 3. Decision Drivers

The decision was guided by the following factors:

- Workload characteristics (static vs dynamic)
- Cost efficiency under Free Tier constraints
- Operational simplicity
- ECS capacity limitations
- Reliability and scalability
- Alignment with real-world production architectures
- Clear separation of frontend and backend concerns

---

## 4. Options Considered

### Option A — Deploy Frontend on ECS (Rejected)

**Description**
- Frontend built into a Docker image
- Deployed as an ECS service
- Served via ALB

**Advantages**
- Unified deployment model with backend
- Single orchestration platform
- Familiar container-based workflow

**Observed Issues**
- ECS tasks failed due to:
  - Insufficient memory
  - Limited EC2 capacity
  - Deployment circuit breaker triggers
- Static frontend consumed compute continuously
- Increased operational overhead
- Poor cost efficiency for a non-dynamic workload

**Why It Was Rejected**
- ECS is designed for **long-running compute workloads**
- Static assets do not benefit from container orchestration
- Resource contention negatively impacted backend stability
- Violated cost-awareness principles

---

### Option B — Deploy Frontend on S3 + CloudFront (Selected)

**Description**
- Frontend built into static assets
- Assets uploaded to Amazon S3
- Served globally via CloudFront CDN
- HTTPS enabled via CloudFront

**Advantages**
- Zero compute management
- Near-zero cost
- Built-in scalability
- High availability by design
- CDN caching and performance benefits
- Simplified operational model

**Limitations**
- Requires separate deployment flow
- Different mental model from containerized workloads

---

## 5. Rationale

### 5.1 Workload-to-Platform Alignment

React SPAs:
- Are compiled into static files
- Do not require server-side execution
- Benefit from CDN caching and edge delivery

Running such workloads on ECS:
- Adds unnecessary compute
- Increases cost
- Introduces avoidable failure modes

Choosing S3 + CloudFront reflects **correct service selection**, a key DevOps skill.

---

### 5.2 Cost & Operational Efficiency

Under Free Tier constraints:
- ECS frontend deployment incurred continuous EC2 cost
- S3 + CloudFront incurred minimal to no cost
- No scaling, patching, or capacity planning required

This decision significantly reduced operational overhead.

---

### 5.3 Reliability & Scalability

With S3 + CloudFront:
- Frontend scales automatically
- No dependency on ECS health
- Backend failures do not affect frontend availability

This decoupling improves overall system resilience.

---

### 5.4 Observed Runtime Evidence

This decision was not theoretical.

It was driven by:
- ECS deployment failures
- Capacity exhaustion
- Circuit breaker events
- Real CloudWatch and ECS service behavior

The decision reflects **evidence-based engineering**, not preference.

---

## 6. Consequences

### Positive Consequences
- Reduced system complexity
- Improved cost profile
- Increased reliability
- Clear separation of responsibilities
- Industry-aligned architecture
- Easier debugging and validation

### Trade-offs
- Two deployment mechanisms instead of one
- Slightly more documentation required
- Different CI/CD flows for frontend and backend

These trade-offs were accepted intentionally.

---

## 7. Security Considerations

- S3 bucket configured for static website hosting
- CloudFront used for HTTPS termination
- No sensitive data exposed in frontend assets
- Backend access restricted to ALB endpoint

Future enhancements may include:
- Custom domain via Route 53
- ACM-managed certificates
- S3 origin access controls (OAC)

---

## 8. Relationship to Other ADRs

This ADR directly complements:
- **ADR-001:** Technology Stack Selection
- **ADR-002:** Container Orchestration Strategy
- **ADR-003:** Infrastructure as Code & Environment Strategy
- **ADR-004:** CI/CD Design & Responsibility Boundaries

Together, these decisions form a **cohesive, defensible DevOps architecture**.

---

## 9. Summary

The decision to deploy the frontend using **Amazon S3 and CloudFront** instead of ECS demonstrates:

- Correct workload-to-platform mapping
- Cost-aware cloud design
- Evidence-driven decision-making
- Willingness to revise earlier assumptions
- Mature DevOps engineering judgment


