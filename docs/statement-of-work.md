# Statement of Work (SOW) Executive Draft

## Project Overview
This engagement aims to modernize the client's hybrid infrastructure by migrating away from a monolithic, flat-account architecture into a secure, multi-account AWS Organization. The target state leverages Amazon EKS for heterogeneous compute (Linux and Windows) and establishes an automated, self-healing diagnostic framework to drastically reduce operational MTTR.

## Engagement Milestones & Phases

### Phase 1: Discovery & Architectural Alignment
* **Activities:** Conduct workshops with C-suite and engineering leaders to align on business objectives and RTO/RPO targets[cite: 1]. Perform a current state analysis of the overlapping VPC CIDRs and fragmented logging mechanisms[cite: 1].
* **Deliverables:** Target design validation, signed-off architecture diagrams, and a finalized migration strategy[cite: 1].

### Phase 2: Core Platform & Landing Zone Construction
* **Activities:** Implement the multi-account deployment utilizing AWS Organizations[cite: 1]. Deploy the Transit Gateway hub-spoke topology and initialize the hybrid Amazon EKS platform using strict Infrastructure as Code (Terraform)[cite: 1].
* **Deliverables:** Fully provisioned foundational infrastructure, verified explicit SCP boundaries, and a validated DRY Terraform repository[cite: 1].

### Phase 3: Workload Migration & Operational Readiness
* **Activities:** Execute the Hybrid OS migration (Linux API and Windows Server services) onto the EKS worker nodes[cite: 1]. Integrate the automated SSM diagnostic scripts and route all telemetry to a unified CloudWatch/OpenSearch stack[cite: 1].
* **Deliverables:** Fully migrated workloads, game-day testing sign-off, completed operational runbooks, and formal handoff training for the client's engineering team[cite: 1].