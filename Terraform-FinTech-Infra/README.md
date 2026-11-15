# 🏦 Terraform-FinTech-Infra

> Production-grade AWS infrastructure for the **FinTech Enterprise Platform**, written entirely in Terraform.
> Five independent stacks (**S3 · Networking · IAM · ECR · EKS**) each with its own remote state, wired together through outputs and `terraform_remote_state`.

![Terraform](https://img.shields.io/badge/Terraform-~%3E%201.17-7B42BC?logo=terraform&logoColor=white)
![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.72-FF9900?logo=amazonaws&logoColor=white)
![EKS](https://img.shields.io/badge/EKS-1.36-326CE5?logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm%20Provider-~%3E%203.3-0F1689?logo=helm&logoColor=white)
![Region](https://img.shields.io/badge/Region-us--east--1-232F3E?logo=amazonaws&logoColor=white)
![State](https://img.shields.io/badge/State-S3%20%2B%20native%20locking-569A31?logo=amazons3&logoColor=white)

---

## 📑 Table of Contents

1. [Platform at a Glance](#-1-platform-at-a-glance)
2. [Deployment Order](#-2-deployment-order)
3. [Remote State & Cross-Stack Wiring](#-3-remote-state--cross-stack-wiring)
4. [Networking – Hub-and-Spoke VPC Design](#-4-networking--hub-and-spoke-vpc-design)
5. [EKS – Control Plane & Data Plane](#-5-eks--control-plane--data-plane)
6. [Blue / Green Node Group Switch](#-6-blue--green-node-group-switch)
7. [Cluster Autoscaler with IRSA](#-7-cluster-autoscaler-with-irsa)
8. [IAM – Environment Role Matrix](#-8-iam--environment-role-matrix)
9. [S3 – Compliance Storage Lifecycle](#-9-s3--compliance-storage-lifecycle)
10. [ECR – Container Registry](#-10-ecr--container-registry)
11. [Repository Tree](#-11-repository-tree)
12. [Conventions](#-12-conventions)
13. [How to Deploy](#-13-how-to-deploy)
14. [Roadmap](#-14-roadmap)

---

## 🌐 1. Platform at a Glance

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'15px','lineColor':'#6C63FF'}}}%%
flowchart LR
    DEV([👩‍💻 Engineer<br/>Ubuntu VM]):::user

    subgraph STATE["🗄️ Remote State"]
        SB[(fintech-project-statefile-bucket)]:::state
    end

    subgraph AWS["☁️ AWS · us-east-1"]
        direction TB
        S3[🪣 S3<br/>Compliance Buckets]:::s3
        NET[🌐 Networking<br/>4 VPCs + Transit Gateway]:::net
        IAM[🔐 IAM<br/>Team & CI/CD Roles]:::iam
        ECR[📦 ECR<br/>4 Repositories]:::ecr
        EKS[☸️ EKS<br/>FinTech-Cluster]:::eks
    end

    DEV -- terraform apply --> AWS
    AWS -. state .-> SB
    NET == subnets & SGs ==> EKS
    ECR == images ==> EKS
    DEV -- kubectl --> EKS

    classDef user  fill:#FFD166,stroke:#B8860B,color:#000,stroke-width:2px
    classDef state fill:#06D6A0,stroke:#047857,color:#000,stroke-width:2px
    classDef s3    fill:#4CAF50,stroke:#1B5E20,color:#fff,stroke-width:2px
    classDef net   fill:#118AB2,stroke:#073B4C,color:#fff,stroke-width:2px
    classDef iam   fill:#EF476F,stroke:#9D0208,color:#fff,stroke-width:2px
    classDef ecr   fill:#FF9F1C,stroke:#B85C00,color:#000,stroke-width:2px
    classDef eks   fill:#7B2CBF,stroke:#3C096C,color:#fff,stroke-width:2px
    style AWS fill:#F1F5FF,stroke:#6C63FF,stroke-width:2px
    style STATE fill:#E8FFF6,stroke:#06D6A0,stroke-width:2px
```

**Explanation.** The platform is split into five **independently deployable Terraform stacks**. Each stack owns one concern and one state file, which keeps the blast radius of any change small: a mistake in an IAM change can never touch a VPC. Stacks share information only through **outputs read via `terraform_remote_state`** (Networking → EKS) rather than hard-coded IDs, so resources can be rebuilt without editing other stacks. All state lives in a single versioned S3 bucket with native S3 lock files (`use_lockfile = true`), so no DynamoDB table is needed.

### 📊 Resources managed per stack

```mermaid
%%{init: {'theme':'base','themeVariables':{'pie1':'#118AB2','pie2':'#7B2CBF','pie3':'#EF476F','pie4':'#4CAF50','pie5':'#FF9F1C','pieTitleTextSize':'18px','pieSectionTextColor':'#ffffff','pieStrokeColor':'#ffffff','pieOuterStrokeColor':'#6C63FF'}}}%%
pie showData
    title Terraform-managed resources (latest apply)
    "Networking" : 106
    "EKS" : 23
    "IAM" : 16
    "S3" : 6
    "ECR" : 4
```

**Explanation.** Networking dominates the resource count because every VPC fans out into subnets, route tables, associations, security groups, VPC endpoints and a Transit Gateway attachment. EKS is small in resource count but the most complex stack operationally, since it spans AWS (cluster, node groups, IAM, OIDC) and Kubernetes (Helm release).

---

## 🚦 2. Deployment Order

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'15px'}}}%%
flowchart LR
    A[1️⃣ S3<br/>buckets]:::s3 --> B[2️⃣ Networking<br/>VPCs · TGW · NAT]:::net
    B --> C[3️⃣ IAM<br/>env roles]:::iam
    C --> D[4️⃣ ECR<br/>repositories]:::ecr
    D --> E[5️⃣ EKS<br/>cluster · nodes · autoscaler]:::eks
    B -. "remote state:<br/>private_subnet_ids<br/>private_security_group_ids" .-> E

    classDef s3  fill:#4CAF50,stroke:#1B5E20,color:#fff,stroke-width:2px
    classDef net fill:#118AB2,stroke:#073B4C,color:#fff,stroke-width:2px
    classDef iam fill:#EF476F,stroke:#9D0208,color:#fff,stroke-width:2px
    classDef ecr fill:#FF9F1C,stroke:#B85C00,color:#000,stroke-width:2px
    classDef eks fill:#7B2CBF,stroke:#3C096C,color:#fff,stroke-width:2px
```

**Explanation.** Only one ordering is mandatory: **Networking must exist before EKS**, because the EKS stack places the control plane and every node group into the private subnets and security group that Networking publishes as outputs. S3, IAM and ECR have no hard dependencies and could run in parallel, but a fixed order keeps deployments predictable and easy to audit. Destroying runs in the reverse order (EKS first, Networking last).

---

## 🔗 3. Remote State & Cross-Stack Wiring

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'14px'}}}%%
flowchart TB
    subgraph BUCKET["🗄️ s3://fintech-project-statefile-bucket"]
        direction LR
        K1[/product-s3/envs/s3.tfstate/]:::s3
        K2[/cloudnetworking/prod/networking.tfstate/]:::net
        K3[/product-iam/iam-roles.tfstate/]:::iam
        K4[/ecr/envs/ecr.tfstate/]:::ecr
        K5[/EKS/Prod/eks.tfstate/]:::eks
    end

    NETOUT["📤 Networking outputs<br/>vpc_ids · private_subnet_ids<br/>private_security_group_ids · tgw_id"]:::net
    EKSIN["📥 EKS<br/>data.terraform_remote_state.networking"]:::eks

    K2 --> NETOUT --> EKSIN

    classDef s3  fill:#4CAF50,stroke:#1B5E20,color:#fff
    classDef net fill:#118AB2,stroke:#073B4C,color:#fff
    classDef iam fill:#EF476F,stroke:#9D0208,color:#fff
    classDef ecr fill:#FF9F1C,stroke:#B85C00,color:#000
    classDef eks fill:#7B2CBF,stroke:#3C096C,color:#fff
    style BUCKET fill:#E8FFF6,stroke:#06D6A0,stroke-width:2px
```

**Explanation.** Each stack writes to its own key in the state bucket, so `terraform destroy` on one stack only empties that stack's state file; the file itself remains (with `resources: []`) and is reused on the next apply. EKS consumes Networking through `terraform_remote_state` and filters the `FinTech-App` private subnets down to three Availability Zones with a `data "aws_subnets"` lookup. This is the **producer/consumer** pattern used by large platform teams: the network team owns the VPC, application stacks only read from it.

---

## 🌐 4. Networking – Hub-and-Spoke VPC Design

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'14px'}}}%%
flowchart TB
    INET((🌍 Internet)):::inet

    TGW{{🔀 Transit Gateway<br/>FinTech-TGW<br/>routes 10.0.0.0/8}}:::tgw

    subgraph EDGE["🛡️ FinTech-Edge · 10.10.0.0/16"]
        E1[Public ×3<br/>443 in]:::pub
        E2[Private ×3]:::priv
    end

    subgraph APP["⚙️ FinTech-App · 10.20.0.0/16"]
        A1[Public ×3<br/>80/443 in]:::pub
        A2[Private ×6<br/>EKS lives here]:::eksn
        A3[NAT Gateway]:::nat
        A4[Endpoints: ecr.api · ecr.dkr<br/>secretsmanager · kms · S3]:::ep
    end

    subgraph DB["🗃️ FinTech-Database · 10.30.0.0/16"]
        D1[Private only ×6<br/>Postgres 5432 · Kafka 9092 · OpenSearch 443]:::priv
        D2[Endpoint: kms · S3]:::ep
    end

    subgraph OPS["🧰 FinTech-Ops · 10.40.0.0/16"]
        O1[Public ×3]:::pub
        O2[Private ×3<br/>Vault 8200]:::priv
        O3[NAT Gateway]:::nat
    end

    INET <--> E1
    INET <--> A1
    A2 --> A3 --> INET
    O2 --> O3 --> INET
    E2 <--> TGW
    A2 <--> TGW
    D1 <--> TGW
    O2 <--> TGW

    classDef inet fill:#FFD166,stroke:#B8860B,color:#000,stroke-width:2px
    classDef tgw  fill:#F72585,stroke:#7A0E3E,color:#fff,stroke-width:3px
    classDef pub  fill:#90E0EF,stroke:#0077B6,color:#000
    classDef priv fill:#0077B6,stroke:#03045E,color:#fff
    classDef eksn fill:#7B2CBF,stroke:#3C096C,color:#fff,stroke-width:2px
    classDef nat  fill:#FB8500,stroke:#9A4D00,color:#fff
    classDef ep   fill:#06D6A0,stroke:#047857,color:#000
    style EDGE fill:#E0F7FF,stroke:#118AB2,stroke-width:2px
    style APP  fill:#F3E8FF,stroke:#7B2CBF,stroke-width:2px
    style DB   fill:#FFE8EE,stroke:#EF476F,stroke-width:2px
    style OPS  fill:#FFF4E0,stroke:#FB8500,stroke-width:2px
```

**Explanation.** Four purpose-built VPCs are created from **one reusable child module** (`Networking/module`) driven by a `for_each` over `vpc_setup` in `terraform.tfvars`, so adding a VPC is a data change, not a code change.

| VPC | Role | Internet exposure | Key controls |
|---|---|---|---|
| **FinTech-Edge** | Ingress / WAF tier | Public 443 only | No NAT, private egress limited to `10.0.0.0/8` |
| **FinTech-App** | EKS workloads | Public 80/443 via LB, private via NAT | Interface endpoints keep ECR, Secrets Manager and KMS traffic off the internet |
| **FinTech-Database** | Data tier | **None** (no public subnets, no NAT) | Ingress only from the App (and Ops for OpenSearch) CIDRs |
| **FinTech-Ops** | Tooling / Vault | Egress via NAT only | Vault 8200 reachable only from `10.0.0.0/8` |

The **Transit Gateway** is the single hub that connects all VPCs; every private route table sends `10.0.0.0/8` to it. This replaces a mesh of VPC peerings and is the standard enterprise topology for regulated (PCI-DSS) segmentation.

---

## ☸️ 5. EKS – Control Plane & Data Plane

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'14px'}}}%%
flowchart TB
    subgraph CP["🧠 Control Plane · aws_eks_cluster.eks_control_plane"]
        API[Kubernetes API<br/>v1.36 · private + public endpoint]:::cp
        AUTH[Access mode: API<br/>access entries]:::cp
        OIDC[OIDC issuer → IAM OIDC provider<br/>enables IRSA]:::oidc
    end

    subgraph DP["💪 Data Plane · private subnets of FinTech-App"]
        direction LR
        CB[🔵 core_data_plane_blue<br/>t3.medium · 1 / 1–10]:::blue
        CG[🟢 core_data_plane_green<br/>t3.medium · 0 / 0–10]:::green
        MB[🔵 ml_data_plane_blue<br/>taint: dedicated=ml-inference<br/>0 / 0–10]:::blue
        MG[🟢 ml_data_plane_green<br/>taint: dedicated=ml-inference<br/>0 / 0–10]:::green
    end

    ROLE[🔐 eks_fintech_worker_node_role<br/>WorkerNode · CNI · ECR ReadOnly]:::iam
    CA[📈 Cluster Autoscaler<br/>Helm chart 9.60.0 · v1.36.2]:::ca
    KC[💻 ~/.kube/config<br/>written by terraform_data]:::kc

    API --> DP
    ROLE --> DP
    CA -- resizes ASGs --> DP
    API --> KC

    classDef cp    fill:#3A0CA3,stroke:#10002B,color:#fff,stroke-width:2px
    classDef oidc  fill:#F72585,stroke:#7A0E3E,color:#fff
    classDef blue  fill:#4361EE,stroke:#14213D,color:#fff,stroke-width:2px
    classDef green fill:#2DC653,stroke:#155D27,color:#fff,stroke-width:2px
    classDef iam   fill:#EF476F,stroke:#9D0208,color:#fff
    classDef ca    fill:#FF9F1C,stroke:#B85C00,color:#000,stroke-width:2px
    classDef kc    fill:#FFD166,stroke:#B8860B,color:#000
    style CP fill:#EDE7FF,stroke:#3A0CA3,stroke-width:2px
    style DP fill:#F0FFF4,stroke:#2DC653,stroke-width:2px
```

**Explanation.**

- **Control plane.** Placed in the `FinTech-App` private subnets across `us-east-1a/b/c`, protected by the App private security group. Authentication uses the modern **EKS access entries** API (no `aws-auth` ConfigMap). Root and the `hassan_iam_role` DevOps role are granted access explicitly.
- **Data plane.** Four managed node groups share one worker IAM role. Only `core_data_plane_blue` runs a node by default; the other three are **provisioned at zero** so they cost nothing until scaled. ML groups carry a `NO_SCHEDULE` taint so only ML inference pods (with a matching toleration) land on them.
- **Safe rollouts.** Every node group uses `create_before_destroy` and `max_unavailable = 1`: new capacity comes up before old nodes are drained.
- **Developer experience.** A `terraform_data` resource runs `aws eks update-kubeconfig` automatically after the cluster is created, so `kubectl` works immediately on the deploying machine.

---

## 🔁 6. Blue / Green Node Group Switch

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'15px'}}}%%
stateDiagram-v2
    direction LR
    [*] --> Blue
    Blue --> Both : node_color = "both"<br/>green nodes come up
    Both --> Green : node_color = "green"<br/>pods drained, blue removed
    Green --> Both : next upgrade
    Both --> Blue : rollback

    Blue : 🔵 BLUE only
    Both : 🔵🟢 BLUE + GREEN
    Green : 🟢 GREEN only

    classDef blue fill:#4361EE,color:#fff,stroke:#14213D,stroke-width:2px
    classDef both fill:#7B2CBF,color:#fff,stroke:#3C096C,stroke-width:2px
    classDef green fill:#2DC653,color:#fff,stroke:#155D27,stroke-width:2px
    class Blue blue
    class Both both
    class Green green
```

**Explanation.** A single validated variable, `node_color` (`blue` | `green` | `both`), drives the `count` of every node group:

```hcl
count = var.node_color == "blue"  || var.node_color == "both" ? 1 : 0   # blue groups
count = var.node_color == "green" || var.node_color == "both" ? 1 : 0   # green groups
```

Upgrades become a **zero-downtime, three-step change in `terraform.tfvars`**: switch to `both`, let workloads move to the new nodes, then switch to the new colour. Rollback is the same change in reverse. The current value is `both`, so all four groups exist.

---

## 📈 7. Cluster Autoscaler with IRSA

```mermaid
%%{init: {'theme':'base','themeVariables':{'actorBkg':'#7B2CBF','actorTextColor':'#ffffff','actorBorder':'#3C096C','signalColor':'#118AB2','signalTextColor':'#073B4C','noteBkgColor':'#FFD166','noteTextColor':'#000','activationBkgColor':'#06D6A0','sequenceNumberColor':'#ffffff'}}}%%
sequenceDiagram
    autonumber
    participant Pod as 📦 Pending Pod
    participant CA as 📈 cluster-autoscaler<br/>(kube-system SA)
    participant OIDC as 🪪 EKS OIDC Provider
    participant STS as 🔐 AWS STS
    participant ASG as ⚙️ Node Group ASG

    Pod->>CA: Unschedulable (no capacity)
    CA->>OIDC: Present projected SA token
    OIDC-->>STS: Token signed by cluster issuer
    STS->>STS: Check sub = system:serviceaccount:kube-system:cluster-autoscaler<br/>and aud = sts.amazonaws.com
    STS-->>CA: Temporary credentials for<br/>FinTech-Cluster-Cluster-Autoscaler-Role
    activate CA
    CA->>ASG: DescribeNodegroup / SetDesiredCapacity
    ASG-->>Pod: New node joins → Pod scheduled
    deactivate CA
    Note over CA,ASG: Idle nodes are removed later, down to min_size
```

**Explanation.** The autoscaler is installed by Terraform with the official Helm chart, and it gets AWS permissions through **IAM Roles for Service Accounts (IRSA)**, with no access keys anywhere:

1. **`aws_iam_policy`**: least-privilege actions to read and resize Auto Scaling Groups. `eks:DescribeNodegroup` allows scaling **up from zero**, which the green and ML groups rely on.
2. **`aws_iam_role`**: trusts *only* the `kube-system/cluster-autoscaler` service account of *this* cluster (`sub` + `aud` conditions).
3. **`aws_iam_role_policy_attachment`**: binds policy to role.
4. **`helm_release`**: installs the chart, annotates the service account with the role ARN, and auto-discovers node groups by cluster tag. It waits for IAM and for the first node group to exist.

---

## 🔐 8. IAM – Environment Role Matrix

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'14px'}}}%%
flowchart LR
    TF[[🧩 module iam_roles<br/>for_each = role_sets]]:::mod

    subgraph PLAT["platform"]
        P1[👑 FinTech-Platform-Admin<br/>EKS · KMS · VPC · RDS<br/>❌ PII data access]:::admin
    end
    subgraph QA["qa (full access)"]
        Q1[🧑‍💻 AppTeam-qa-Role]:::full
        Q2[🤖 FinTech-CI-CD-Deployer-qa]:::bot
    end
    subgraph UAT["uat (read-only)"]
        U1[🧑‍💻 AppTeam-uat-Role]:::ro
        U2[🤖 FinTech-CI-CD-Deployer-uat]:::bot
    end
    subgraph PROD["prod (read-only)"]
        R1[🧑‍💻 AppTeam-prod-Role]:::ro
        R2[🤖 FinTech-CI-CD-Deployer-prod]:::bot
    end

    TF --> PLAT & QA & UAT & PROD
    GH([🐙 GitHub Actions OIDC]):::gh -. AssumeRoleWithWebIdentity .-> Q2 & U2 & R2

    classDef mod   fill:#FFD166,stroke:#B8860B,color:#000,stroke-width:2px
    classDef admin fill:#9D0208,stroke:#370617,color:#fff,stroke-width:2px
    classDef full  fill:#2DC653,stroke:#155D27,color:#fff
    classDef ro    fill:#118AB2,stroke:#073B4C,color:#fff
    classDef bot   fill:#7B2CBF,stroke:#3C096C,color:#fff
    classDef gh    fill:#24292F,stroke:#000,color:#fff
    style PLAT fill:#FFE8EE,stroke:#9D0208
    style QA   fill:#E8FFEF,stroke:#2DC653
    style UAT  fill:#E0F7FF,stroke:#118AB2
    style PROD fill:#E0F7FF,stroke:#118AB2
```

**Explanation.** The IAM stack calls one wrapper module (`IAM/iam_roles`, built on `terraform-aws-modules/iam`) once per environment in `role_sets`. The module **derives permissions from the environment name**: environments listed in `read_only_environments` (`uat`, `prod`) automatically receive restricted actions, enforcing least privilege without per-environment code. Guardrails are explicit `Deny` statements (no PII reads for platform admins, no VPC/TGW deletion for app teams), and CI/CD roles trust **GitHub Actions OIDC** scoped to this repository, so pipelines need no stored keys.

---

## 🪣 9. S3 – Compliance Storage Lifecycle

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'15px'}}}%%
flowchart LR
    N[📥 New object<br/>STANDARD]:::std -- 30 days --> IA[🧊 STANDARD_IA]:::ia
    IA -- 180 days --> GL[🏔️ GLACIER]:::gl
    GL -- 730 days --> X[🗑️ Expired]:::del
    V[🕘 Non-current version]:::ver -- 90 days --> GL2[🏔️ GLACIER]:::gl
    GL2 -- 180 days --> X2[🗑️ Deleted]:::del

    classDef std fill:#4CAF50,stroke:#1B5E20,color:#fff,stroke-width:2px
    classDef ia  fill:#90E0EF,stroke:#0077B6,color:#000
    classDef gl  fill:#3A86FF,stroke:#023E8A,color:#fff
    classDef del fill:#EF476F,stroke:#9D0208,color:#fff
    classDef ver fill:#FFD166,stroke:#B8860B,color:#000
```

**Explanation.** Buckets `muntaha-fintech-dvc-data-lake` and `muntaha-fintech-applog` are created by one module with `for_each`, each with **versioning enabled** and a tiered lifecycle policy that keeps data for two years (a common retention baseline for financial audit logs) while moving cold data to cheaper storage classes automatically. Adding a bucket is a one-line change in `S3/terraform.tfvars`. Names carry a `muntaha-` prefix because S3 bucket names are global across all AWS accounts.

---

## 📦 10. ECR – Container Registry

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'15px'}}}%%
flowchart LR
    CI[🤖 CI/CD Deployer Role]:::bot -- docker push --> R
    subgraph R["📦 ECR · scan on push · MUTABLE tags"]
        direction TB
        L[fintech-ledgerservice]:::r1
        P[fintech-payment]:::r2
        B[fintech-bff]:::r3
        N[fintech-notifications]:::r4
    end
    R -- image pull via VPC endpoint --> EKS[☸️ EKS nodes]:::eks

    classDef bot fill:#7B2CBF,stroke:#3C096C,color:#fff
    classDef r1 fill:#FF9F1C,stroke:#B85C00,color:#000
    classDef r2 fill:#F72585,stroke:#7A0E3E,color:#fff
    classDef r3 fill:#4361EE,stroke:#14213D,color:#fff
    classDef r4 fill:#2DC653,stroke:#155D27,color:#fff
    classDef eks fill:#3A0CA3,stroke:#10002B,color:#fff
    style R fill:#FFF4E0,stroke:#FF9F1C,stroke-width:2px
```

**Explanation.** One repository per microservice, created with `for_each` over a set. **Image scanning on push** surfaces CVEs before an image ever reaches the cluster. Nodes pull images through the `ecr.api` / `ecr.dkr` interface endpoints and the S3 gateway endpoint in the App VPC, so image traffic never leaves the AWS network.

---

## 🌳 11. Repository Tree

```text
Terraform-FinTech-Infra/
├── 📄 README.md                      ← you are here
│
├── 🪣 S3/                            ── Stack 1 · compliance buckets
│   ├── backend.tf                    state → product-s3/envs/s3.tfstate
│   ├── providers.tf · variables.tf · locals.tf · main.tf · outputs.tf
│   ├── terraform.tfvars              bucket names, environment, tags
│   └── modules/                      reusable bucket module
│       └── main.tf · variables.tf · locals.tf · outputs.tf · versions.tf
│
├── 🌐 Networking/                    ── Stack 2 · VPCs + Transit Gateway
│   ├── backend.tf                    state → cloudnetworking/prod/networking.tfstate
│   ├── providers.tf · variables.tf · locals.tf · main.tf · outputs.tf
│   ├── terraform.tfvars              vpc_setup: Edge · App · Database · Ops
│   ├── module/                       one VPC: subnets, RTs, NAT, SGs, endpoints, TGW attach
│   │   └── main.tf · variables.tf · outputs.tf · version.tf
│   └── tgw/                          the Transit Gateway hub
│       └── main.tf · variables.tf · outputs.tf · version.tf
│
├── 🔐 IAM/                           ── Stack 3 · environment roles
│   ├── backend.tf                    state → product-iam/iam-roles.tfstate
│   ├── providers.tf · variables.tf · locals.tf · main.tf · outputs.tf
│   ├── terraform.tfvars              role_sets: platform · qa · uat · prod
│   └── iam_roles/                    wrapper over terraform-aws-modules/iam
│       └── main.tf · variables.tf · locals.tf · outputs.tf · versions.tf
│
├── 📦 ECR/                           ── Stack 4 · container registry
│   ├── backend.tf                    state → ecr/envs/ecr.tfstate
│   ├── providers.tf · variables.tf · main.tf
│   ├── terraform.tfvars
│   └── modules/
│       └── main.tf · variables.tf · outputs.tf · versions.tf
│
└── ☸️ EKS/                           ── Stack 5 · Kubernetes platform
    ├── backend.tf                    state → EKS/Prod/eks.tfstate
    ├── versions.tf                   aws ~> 6.72 · tls ~> 4.0 · helm ~> 3.3
    ├── providers.tf                  aws + helm (exec auth via aws eks get-token)
    ├── variables.tf · outputs.tf
    ├── terraform.tfvars              cluster, node names, node_color, autoscaler versions
    ├── IAM.tf                        cluster role, worker role, DevOps user/role
    ├── EKS_Control_Plane.tf          remote state, subnets, cluster, access entries
    ├── EKS_Data_Plane.tf             4 node groups (core/ml × blue/green) + kubeconfig
    ├── OIDC.tf                       IAM OIDC provider for IRSA
    ├── EKS_Cluster_Autoscaler.tf     IRSA policy/role + Helm release
    └── testapp.yaml                  sample workload for testing
```

---

## 📐 12. Conventions

| Rule | Example | Why |
|---|---|---|
| Terraform identifiers are `snake_case` | `aws_eks_cluster.eks_control_plane` | One consistent style across every stack and module |
| AWS-facing names keep their own style | `FinTech-App`, `FinTech-Cluster-Role` | Renaming them would **replace** live resources |
| Values come from `terraform.tfvars` | `node_color`, node group names | Root variables have **no defaults**: config is explicit and reviewable |
| One state file per stack | `EKS/Prod/eks.tfstate` | Small blast radius, independent lifecycles |
| `backend.tf` is never edited casually | — | Changing a key orphans existing state |
| Child modules own version pins | `modules/versions.tf` | Roots stay clean; upgrades happen in one place |

---

## 🚀 13. How to Deploy

```bash
# Run in this order: S3 → Networking → IAM → ECR → EKS
for stack in S3 Networking IAM ECR EKS; do
  cd Terraform-FinTech-Infra/$stack
  terraform init
  terraform fmt
  terraform validate
  terraform plan -var-file="terraform.tfvars" -out plan1
  terraform apply plan1
  cd - >/dev/null
done

# After EKS finishes, kubeconfig is already written:
kubectl get nodes
kubectl get pods -n kube-system
```

> ⚠️ **Destroy in reverse order** (EKS → ECR → IAM → Networking → S3). EKS depends on Networking's subnets.

---

## 🗺️ 14. Roadmap

```mermaid
%%{init: {'theme':'base','themeVariables':{'fontSize':'14px'}}}%%
timeline
    title Platform evolution
    Done : S3 compliance storage : Hub-and-spoke networking : IAM role matrix : ECR registry : EKS + blue/green + autoscaler
    Next : IAM Identity Center (SSO) – remove root keys : GitHub Actions + OIDC plan/apply roles
    Later : Argo CD (GitOps) : Karpenter evaluation : Multi-account AWS Organizations
```

**Explanation.** The infrastructure layer is in place. The next milestone is **identity hardening**: replacing long-lived credentials with IAM Identity Center for people and GitHub Actions OIDC for pipelines, which mirrors how regulated enterprises operate. After that the focus moves to GitOps-driven application delivery.
