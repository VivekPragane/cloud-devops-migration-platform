# ADR-002: Container Orchestration Strategy (ECS EC2 vs Fargate)

## Status
Accepted

---

## 1. Context

As part of the migration from an Azure-based deployment to AWS, a decision was required on **how containerized workloads would be orchestrated** in the target cloud environment.

The project involves:
- A containerized Node.js backend API
- CI/CD-driven deployments
- Cost-sensitive execution under Free Tier constraints
- A strong emphasis on **understanding infrastructure behavior**, not just abstracting it away

AWS provides two primary execution models for Amazon ECS:
- **ECS with EC2 launch type**
- **ECS with Fargate launch type**

Both options are production-grade, but they represent **very different operational philosophies**.  
This ADR documents the reasoning behind the selected approach.

---

## 2. Decision

**Amazon ECS using the EC2 launch type** was selected as the primary container orchestration strategy for this project.

The decision was made intentionally to:
- Gain deeper visibility into container scheduling and capacity management
- Understand ECS internals rather than fully abstracted execution
- Maintain tighter control over cost and lifecycle behavior

---

## 3. Decision Drivers

The decision was guided by the following factors:

- Desire to understand container orchestration fundamentals
- Need for explicit control over compute capacity
- Cost-awareness and Free Tier constraints
- Observability and debuggability
- Alignment with real-world DevOps learning outcomes
- Avoidance of unnecessary abstraction during a learning-focused migration

---

## 4. Options Considered

### Option A — ECS with Fargate

**Description**
- Serverless container execution
- AWS manages compute, scaling, and instance lifecycle
- Simplified operational model

**Advantages**
- No EC2 instance management
- Reduced operational overhead
- Faster initial setup

**Limitations**
- Higher cost for sustained workloads
- Limited visibility into underlying capacity behavior
- Less opportunity to learn orchestration internals
- Fewer tuning and optimization levers

---

### Option B — ECS with EC2 (Selected)

**Description**
- ECS schedules containers onto EC2 instances
- Compute capacity managed via Auto Scaling Groups
- Explicit instance lifecycle and capacity control

**Advantages**
- Full visibility into:
  - Capacity availability
  - Task placement failures
  - Resource constraints
- Lower cost under Free Tier using `t3.micro`
- Strong learning value for DevOps fundamentals
- Easier correlation between infrastructure state and workload behavior

**Limitations**
- Requires managing EC2 lifecycle
- Slightly higher operational complexity
- Requires correct IAM, AMI, and ASG configuration

---

## 5. Rationale

### 5.1 Learning & Debugging Depth

This project prioritizes **engineering understanding over convenience**.

Using ECS EC2 exposes:
- Why tasks fail to place
- How capacity shortages affect deployments
- The relationship between Auto Scaling Groups and ECS clusters
- Real-world failure modes masked by serverless abstractions

This aligns directly with the project’s problem-solving objectives.

---

### 5.2 Cost Control & Predictability

Under Free Tier and low-budget constraints:
- ECS EC2 with a single `t3.micro` instance provides predictable cost
- Compute can be explicitly scaled to zero when idle
- Billing behavior is easier to reason about than Fargate’s per-second pricing

Cost control is treated as a **core DevOps responsibility**, not an afterthought.

---

### 5.3 Observability & Transparency

With ECS EC2:
- Infrastructure state (instances, capacity, logs) is fully observable
- ECS task failures can be correlated with:
  - EC2 metrics
  - CloudWatch logs
  - Scaling events

This makes root-cause analysis faster and more educational.

---

### 5.4 Real-World Relevance

Many production environments:
- Use ECS EC2 for cost efficiency
- Combine EC2-based workloads with managed services
- Require DevOps engineers to understand both orchestration and compute layers

This choice reflects **real operational environments**, not demo setups.

---

## 6. Consequences

### Positive Consequences
- Deep understanding of ECS internals
- Clear visibility into capacity and scheduling issues
- Predictable cost profile
- Strong alignment with DevOps learning goals
- Easier explanation in interviews and evaluations

### Trade-offs
- Increased responsibility for instance lifecycle management
- Slightly more complex Terraform configuration
- Longer setup time compared to Fargate

These trade-offs were accepted intentionally to maximize learning and clarity.

---

## 7. Evolution & Reassessment

This decision does **not** reject Fargate as a production option.

In future iterations:
- Fargate may be adopted for:
  - Bursty workloads
  - Lower operational overhead environments
  - Teams prioritizing velocity over infrastructure insight

The current decision is scoped specifically to:
- Internship objectives
- Learning-focused DevOps migration
- Cost-aware experimentation

---

## 8. Summary

ECS with EC2 launch type was selected to:
- Expose real container orchestration behavior
- Enable meaningful debugging and observability
- Maintain cost control
- Build foundational DevOps intuition

This decision reinforces the project’s guiding principle:

> **Abstractions are powerful, but understanding what they abstract is essential.**

