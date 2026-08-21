# Executive Architectural Reference

## 1. Problem Definition
The client currently operates a monolithic, hybrid workload (Linux API services and Windows Server enterprise services) within a single, flat AWS account. This architecture introduces severe risks:
* **Blast Radius & Security:** The lack of environment isolation and overlapping VPC CIDRs creates a massive security and operational risk; a single compromised instance or misconfiguration could impact production.
* **Operational Inefficiency:** Manual deployments and fragmented logging (split between Windows Event Viewer and Linux log files) have resulted in an unacceptably high Mean Time to Resolution (MTTR) during outages.

## 2. Strategic Recommendations & Target Architecture
To achieve a zero flat-account blast radius and sub-15-minute MTTR, we recommend a complete landing zone redesign and platform modernization:

* **Multi-Account Landing Zone:** Transition to an AWS Organization with dedicated accounts for Management, Shared Services/Network Hub, Security/Logging, and Workload Spokes (Dev, Staging, Prod). 
* **Hub-Spoke Networking:** Implement AWS Transit Gateway for centralized, micro-segmented routing, utilizing layered subnets (Public Ingress, App/Compute Private, Data Private) to strictly control traffic flow.
* **Hybrid EKS Compute:** Migrate workloads to Amazon EKS utilizing Managed Node Groups. By leveraging heterogeneous compute, both Linux (Amazon Linux 3) and Windows Server (Windows Core 2022) worker nodes can run within the same orchestrated environment while retaining strict namespace and data subnet isolation.
* **Unified Observability & Diagnostics:** Implement an automated diagnostic workflow utilizing AWS Systems Manager (SSM) Run Command to query logs without SSH/RDP access, shipping telemetry to a centralized CloudWatch/OpenSearch stack.

## 3. Trade-Off Matrix
| Architectural Decision | Pro | Con / Mitigation |
| :--- | :--- | :--- |
| **EKS for Hybrid Compute** | Unifies orchestration for both Linux and Windows workloads; simplifies CI/CD. | High learning curve for Windows on Kubernetes. *Mitigation: Standardize Helm charts and use AWS managed AMIs.* |
| **Transit Gateway (TGW)** | Highly scalable hub-and-spoke networking; centralizes security appliance routing. | Additional hourly cost per attachment. *Mitigation: Offset by utilizing cost-effective Graviton nodes for Linux compute.* |
| **SSM Run Command** | Eliminates the need for bastion hosts and direct SSH/RDP access. | Requires strict IAM policies. *Mitigation: Implement explicit SCPs and role boundaries.* |

## 4. End-to-End Request Flow
1. **Ingress:** Client request hits the AWS Application Load Balancer via the Public Ingress Subnet.
2. **Compute:** Traffic is routed to the isolated App/Compute Private Subnet, terminating on the EKS custom Ingress Controller.
3. **Identity:** The EKS Pod Identity assumes an IAM role via IRSA to securely authorize actions without static credentials.
4. **Data:** Application interacts with data stores residing in the strictly isolated Data Private Subnet.

## 5. Architecture Diagrams

### Multi-Account & Hub-Spoke Topology
```mermaid
graph TD
    subgraph AWS Organization [AWS Organization - Multi-Account Strategy]
        
        subgraph Hub [Network Hub & Shared Services Account]
            TGW((AWS Transit Gateway))
            ANFW[AWS Network Firewall]
            TGW --- ANFW
            CentralLogs[(Centralized CloudWatch/OpenSearch)]
        end

        subgraph SpokeProd [Workload Spoke Account - Production]
            VPC[Spoke VPC]
            subgraph EKS [Amazon EKS Platform]
                Ingress[Custom CNI / Ingress Controller]
                Linux[Linux Managed Node Group<br/>AL2023]
                Windows[Windows Managed Node Group<br/>Windows Core 2022]
                Ingress --> Linux
                Ingress --> Windows
            end
            VPC --- EKS
        end
        
        Hub <-->|VPC Attachment| SpokeProd
    end
    
    classDef hub fill:#f9f2f4,stroke:#333,stroke-width:2px;
    classDef spoke fill:#e6f3ff,stroke:#333,stroke-width:2px;
    class Hub hub;
    class SpokeProd spoke;
```

### EKS Ingress & Pod Identity Auth Flow
```mermaid
sequenceDiagram
    participant Client
    participant ALB as AWS Application Load Balancer
    participant Ingress as EKS Ingress Controller
    participant Pod as EKS Application Pod
    participant IAM as AWS IAM (OIDC Provider)
    participant Data as AWS Data Subnet (e.g., RDS/S3)

    Client->>ALB: 1. HTTPS Request
    ALB->>Ingress: 2. Route Traffic to Worker Node
    Ingress->>Pod: 3. Forward Request to Application
    Note over Pod,IAM: IRSA / Pod Identity Flow
    Pod->>IAM: 4. Request Temp STS Credentials via OIDC Token
    IAM-->>Pod: 5. Return Short-Lived IAM Role Token
    Pod->>Data: 6. Authenticated API Call using Token
    Data-->>Pod: 7. Secure Data Response
```