<div align="center">

<img src="https://capsule-render.vercel.app/api?type=venom&color=0:0f2027,40:203a43,70:2c5364,100:00c9a7&height=280&section=header&text=FinTech%20Enterprise%20Project&fontSize=56&fontColor=ffffff&animation=twinkling&fontAlignY=40&desc=14%20Microservices%20%7C%20EKS%20%7C%20DevSecOps%20%7C%20MLOps%20%7C%20GenAI&descAlignY=62&descSize=20" alt="banner"/>

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=22&pause=1000&color=00C9A7&center=true&vCenter=true&width=900&lines=A+replica+of+real-world+FinTech+platforms;14+microservices+on+Amazon+EKS;Karpenter+%2B+GitOps+%2B+DevSecOps+by+design;MLOps+%26+GenAI+for+prediction+and+assistance;Built+for+Platform+%2F+Senior+DevOps+Engineers)](https://git.io/typing-svg)

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=FF9900)
![EKS](https://img.shields.io/badge/EKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Karpenter](https://img.shields.io/badge/Karpenter-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Istio](https://img.shields.io/badge/Istio-466BB0?style=for-the-badge&logo=istio&logoColor=white)
![Vault](https://img.shields.io/badge/Vault-FFEC6E?style=for-the-badge&logo=vault&logoColor=black)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aqua&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Kafka](https://img.shields.io/badge/Kafka-231F20?style=for-the-badge&logo=apachekafka&logoColor=white)
![MLflow](https://img.shields.io/badge/MLflow-0194E2?style=for-the-badge&logo=mlflow&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)

![Microservices](https://img.shields.io/badge/Microservices-14-00c9a7?style=flat-square)
![Layers](https://img.shields.io/badge/Layers-Frontend%20%7C%20BFF%20%7C%20App%20%7C%20DB%20%7C%20ML-blueviolet?style=flat-square)
![Security](https://img.shields.io/badge/Security-DevSecOps%20First-red?style=flat-square)
![Status](https://img.shields.io/badge/Status-Actively%20Evolving-brightgreen?style=flat-square)
![PRs](https://img.shields.io/badge/PRs-Welcome-ff69b4?style=flat-square)

</div>

---

## 📑 Table of Contents

- [About](#-about-this-project)
- [Architecture](#%EF%B8%8F-high-level-architecture)
- [The 14 Microservices](#-the-14-microservices)
- [AWS Infrastructure](#%EF%B8%8F-aws-infrastructure-layout)
- [Request Flow](#-request-flow-making-a-payment)
- [Platform Layers](#-platform-layers)
- [DevSecOps](#-devsecops-pipeline)
- [GitOps & Delivery](#-gitops--delivery)
- [Security Layers](#%EF%B8%8F-defence-in-depth)
- [MLOps](#-mlops-lifecycle)
- [AI / GenAI](#-ai--genai-capabilities)
- [Observability](#-observability)
- [Tech Stack](#-tech-stack)
- [Roadmap](#%EF%B8%8F-roadmap)

---

## 🌟 About This Project

> **This repository is a replica of the FinTech platform from my past projects and professional work experience.**

It is an **EKS-based, multi-tier FinTech platform** made up of **14 microservices** across five layers: **Frontend → BFF → Application → Database**, plus an **MLOps / AI** layer for model training and data prediction.

The project **will be upgraded over time**. Each upgrade showcases a modern tool, skill or concept, with **DevSecOps security** as the main concern throughout. It mirrors the toolset and skillset expected of a **Platform Engineer / Senior DevOps Engineer in a FinTech organisation**.

> ⚠️ **Note:** this README describes the target architecture. The [Roadmap](#%EF%B8%8F-roadmap) shows what is done (✅), in progress (🚧) and planned (🔜).

<div align="center">

| 🧩 Microservices | 🏛️ Layers | 🔐 Security Controls | 🤖 ML / AI Services | ☁️ AWS Services |
|:---:|:---:|:---:|:---:|:---:|
| **14** | **5** | **20+** | **4** | **25+** |

</div>

---

## 🏗️ High-Level Architecture

```mermaid
flowchart TB
    User([👤 Customer<br/>Web & Mobile]):::user --> R53[🌐 Route 53]:::edge
    R53 --> CF[☁️ CloudFront CDN]:::edge
    CF --> WAF[🛡️ AWS WAF + Shield]:::sec
    WAF --> ALB[⚖️ ALB Ingress Controller]:::edge

    subgraph EKS["☸️ AMAZON EKS CLUSTER · Karpenter autoscaled · Istio mTLS mesh"]
        direction TB

        subgraph FE["🎨 FRONTEND LAYER"]
            S1[1 · web-frontend<br/>React / Next.js]:::fe
        end

        subgraph BFFL["🔀 BFF LAYER"]
            S2[2 · web-bff<br/>GraphQL]:::bff
            S3[3 · mobile-bff<br/>REST]:::bff
        end

        subgraph APPL["⚙️ APPLICATION LAYER"]
            S4[4 · auth-service<br/>OAuth2 / JWT]:::app
            S5[5 · customer-kyc-service]:::app
            S6[6 · accounts-service]:::app
            S7[7 · payments-service]:::app
            S8[8 · transactions-service]:::app
            S9[9 · ledger-service]:::app
            S10[10 · notification-service]:::app
        end

        subgraph MLL["🤖 MLOPS & AI LAYER"]
            S11[11 · fraud-detection-api]:::ml
            S12[12 · credit-scoring-api]:::ml
            S13[13 · model-training-pipeline]:::ml
            S14[14 · genai-assistant<br/>RAG]:::ml
        end
    end

    subgraph DBL["🗄️ DATABASE LAYER"]
        PG[(Aurora PostgreSQL)]:::db
        RD[(ElastiCache Redis)]:::db
        KF{{Kafka / MSK}}:::db
        S3[(S3 Data Lake)]:::db
        VEC[(pgvector)]:::db
    end

    ALB --> S1
    S1 --> S2 & S3
    S2 & S3 --> S4 & S6 & S7 & S8 & S14
    S4 --> S5
    S7 --> S11
    S6 --> S12
    S7 --> S9
    S8 --> S9
    S8 --> KF --> S10
    S4 --> RD
    S5 & S6 & S7 & S8 & S9 --> PG
    S13 --> S3
    S11 & S12 --> S3
    S14 --> VEC

    classDef user fill:#ff9a9e,stroke:#fff,color:#000,stroke-width:2px
    classDef edge fill:#fbc2eb,stroke:#a18cd1,color:#000
    classDef sec fill:#ff416c,stroke:#fff,color:#fff
    classDef fe fill:#4facfe,stroke:#fff,color:#000
    classDef bff fill:#c471f5,stroke:#fff,color:#fff
    classDef app fill:#43e97b,stroke:#fff,color:#000
    classDef ml fill:#f7971e,stroke:#fff,color:#000
    classDef db fill:#434343,stroke:#ffd200,color:#fff,stroke-width:2px

    style EKS fill:#0f2027,stroke:#00c9a7,color:#fff,stroke-width:3px
    style FE fill:#12263f,stroke:#4facfe,color:#fff
    style BFFL fill:#2a1245,stroke:#c471f5,color:#fff
    style APPL fill:#0b3d2e,stroke:#43e97b,color:#fff
    style MLL fill:#3d2400,stroke:#f7971e,color:#fff
    style DBL fill:#1a1a1a,stroke:#ffd200,color:#fff
```

---

## 🧩 The 14 Microservices

<div align="center">

| # | Service | Layer | Responsibility | Stack | Data Store |
|:-:|---|:-:|---|---|---|
| 1 | 🎨 **web-frontend** | Frontend | Customer web UI | React, Next.js | CDN / S3 |
| 2 | 🔀 **web-bff** | BFF | Aggregates APIs for web | Node.js, GraphQL | Redis |
| 3 | 📱 **mobile-bff** | BFF | Aggregates APIs for mobile | Node.js, REST | Redis |
| 4 | 🔑 **auth-service** | App | Login, OAuth2, JWT, MFA | Java / Spring Boot | Redis, Aurora |
| 5 | 🪪 **customer-kyc-service** | App | Onboarding and KYC checks | Python / FastAPI | Aurora |
| 6 | 🏦 **accounts-service** | App | Accounts and balances | Java / Spring Boot | Aurora |
| 7 | 💸 **payments-service** | App | Payment initiation and orchestration | Go | Aurora |
| 8 | 🔁 **transactions-service** | App | Transaction history and events | Go | Aurora, Kafka |
| 9 | 📒 **ledger-service** | App | Double-entry ledger | Java / Spring Boot | Aurora |
| 10 | 🔔 **notification-service** | App | Email, SMS and push | Python | Kafka |
| 11 | 🕵️ **fraud-detection-api** | ML | Real-time fraud scoring | Python, KServe | S3 / MLflow |
| 12 | 📊 **credit-scoring-api** | ML | Credit risk prediction | Python, KServe | S3 / MLflow |
| 13 | 🏋️ **model-training-pipeline** | ML | Feature engineering, training, evaluation | Airflow, MLflow, Kubeflow | S3, Feast |
| 14 | 🧠 **genai-assistant** | AI | RAG assistant with guardrails | Python, LangChain, Bedrock | pgvector |

</div>

> Languages and frameworks above are the target design and may change as the services are built.

### 🕸️ Service Dependency Map

```mermaid
graph LR
    S1([1 web-frontend]):::fe --> S2([2 web-bff]):::bff
    S1 --> S3([3 mobile-bff]):::bff
    S2 --> S4([4 auth]):::app
    S3 --> S4
    S2 --> S6([6 accounts]):::app
    S2 --> S7([7 payments]):::app
    S3 --> S8([8 transactions]):::app
    S2 --> S14([14 genai-assistant]):::ml
    S4 --> S5([5 customer-kyc]):::app
    S6 --> S12([12 credit-scoring]):::ml
    S7 --> S11([11 fraud-detection]):::ml
    S7 --> S9([9 ledger]):::app
    S8 --> S9
    S8 --> S10([10 notification]):::app
    S13([13 training-pipeline]):::ml -.->|publishes models| S11
    S13 -.->|publishes models| S12

    classDef fe fill:#4facfe,stroke:#fff,color:#000
    classDef bff fill:#c471f5,stroke:#fff,color:#fff
    classDef app fill:#43e97b,stroke:#fff,color:#000
    classDef ml fill:#f7971e,stroke:#fff,color:#000
```

---

## ☁️ AWS Infrastructure Layout

```mermaid
flowchart TB
    INT((🌍 Internet)):::net --> CFN[CloudFront + WAF + Shield]:::edge

    subgraph REGION["☁️ AWS Region"]
        subgraph VPC["🔒 VPC 10.0.0.0/16"]
            subgraph PUB["🌐 Public Subnets · 3 AZs"]
                ALB2[Application Load Balancer]:::pub
                NAT[NAT Gateways]:::pub
            end
            subgraph PRIV["🔐 Private Subnets · 3 AZs"]
                subgraph K["☸️ EKS Control Plane + Karpenter nodes"]
                    NP1[Spot NodePool<br/>stateless apps]:::node
                    NP2[On-Demand NodePool<br/>payments · ledger]:::node
                    NP3[GPU / High-mem NodePool<br/>ML training]:::node
                end
            end
            subgraph ISO["🧱 Isolated Data Subnets"]
                AUR[(Aurora PostgreSQL<br/>Multi-AZ)]:::data
                ECA[(ElastiCache Redis)]:::data
                MSK{{Amazon MSK}}:::data
            end
        end
        S3B[(S3 Data Lake)]:::data
        ECR[📦 ECR + Image Scanning]:::svc
        KMS[🔑 KMS · Secrets Manager]:::svc
        SEC[🛡️ GuardDuty · Security Hub · Inspector]:::svc
        BED[🧠 Bedrock · SageMaker]:::svc
    end

    CFN --> ALB2 --> K
    K --> AUR & ECA & MSK
    K --> S3B
    K -.->|VPC endpoints| ECR & KMS & BED
    NAT --> INT
    SEC -.->|monitors| VPC

    classDef net fill:#ff9a9e,color:#000
    classDef edge fill:#fbc2eb,color:#000
    classDef pub fill:#84fab0,color:#000
    classDef node fill:#8fd3f4,color:#000
    classDef data fill:#434343,stroke:#ffd200,color:#fff
    classDef svc fill:#ffecd2,color:#000
    style REGION fill:#0f2027,stroke:#ff9900,color:#fff,stroke-width:3px
    style VPC fill:#16222a,stroke:#00c9a7,color:#fff,stroke-width:2px
    style PUB fill:#10372b,stroke:#84fab0,color:#fff
    style PRIV fill:#12263f,stroke:#4facfe,color:#fff
    style ISO fill:#2b1a1a,stroke:#ff416c,color:#fff
    style K fill:#1a2b4a,stroke:#326ce5,color:#fff
```

---

## 💸 Request Flow: Making a Payment

```mermaid
sequenceDiagram
    autonumber
    actor C as 👤 Customer
    participant FE as 🎨 web-frontend
    participant BFF as 🔀 web-bff
    participant AU as 🔑 auth-service
    participant PAY as 💸 payments-service
    participant FR as 🕵️ fraud-detection-api
    participant LED as 📒 ledger-service
    participant K as 📨 Kafka
    participant NT as 🔔 notification-service

    C->>FE: Click "Send $250"
    FE->>BFF: POST /payments (JWT)
    BFF->>AU: Validate token + MFA
    AU-->>BFF: ✅ Valid
    BFF->>PAY: Create payment
    PAY->>FR: Score transaction
    alt 🟢 Low risk
        FR-->>PAY: risk = 0.04
        PAY->>LED: Post debit / credit entries
        LED-->>PAY: ✅ Committed
        PAY->>K: PaymentCompleted event
        K->>NT: Consume event
        NT-->>C: 📱 Push + email receipt
        PAY-->>BFF: 200 OK
    else 🔴 High risk
        FR-->>PAY: risk = 0.93
        PAY-->>BFF: 403 Held for review
        PAY->>K: PaymentFlagged event
        K->>NT: Consume event
        NT-->>C: ⚠️ Verify this payment
    end
    BFF-->>FE: Response
    FE-->>C: Show result
```

---

## 🧱 Platform Layers

```mermaid
flowchart TB
    L1["🎨 FRONTEND<br/>React · Next.js · CloudFront · S3"]:::l1
    L2["🔀 BFF LAYER<br/>Web BFF · Mobile BFF · GraphQL · Response shaping"]:::l2
    L3["⚙️ APPLICATION LAYER<br/>Auth · KYC · Accounts · Payments · Transactions · Ledger · Notifications"]:::l3
    L4["🤖 MLOPS / AI LAYER<br/>Fraud · Credit Scoring · Training Pipeline · GenAI RAG"]:::l4
    L5["🗄️ DATABASE LAYER<br/>Aurora · Redis · Kafka · S3 · pgvector"]:::l5
    L6["☸️ PLATFORM LAYER<br/>EKS · Karpenter · Istio · ArgoCD · Vault · Terraform"]:::l6
    L7["🔐 SECURITY & OBSERVABILITY<br/>Kyverno · Falco · Trivy · Prometheus · Grafana · Loki"]:::l7

    L1 --> L2 --> L3 --> L4 --> L5 --> L6 --> L7

    classDef l1 fill:#4facfe,color:#000,stroke:#fff,stroke-width:2px
    classDef l2 fill:#c471f5,color:#fff,stroke:#fff,stroke-width:2px
    classDef l3 fill:#43e97b,color:#000,stroke:#fff,stroke-width:2px
    classDef l4 fill:#f7971e,color:#000,stroke:#fff,stroke-width:2px
    classDef l5 fill:#434343,color:#fff,stroke:#ffd200,stroke-width:2px
    classDef l6 fill:#326ce5,color:#fff,stroke:#fff,stroke-width:2px
    classDef l7 fill:#ff416c,color:#fff,stroke:#fff,stroke-width:2px
```

---

## 🔐 DevSecOps Pipeline

```mermaid
flowchart LR
    DEV[👨‍💻 Commit]:::s0 --> PRE[🪝 pre-commit<br/>Gitleaks]:::s1
    PRE --> SAST[🔍 SAST<br/>SonarQube · Semgrep]:::s1
    SAST --> SCA[📦 SCA<br/>Trivy · Snyk]:::s1
    SCA --> BUILD[🐳 Docker Build]:::s2
    BUILD --> SCAN[🛡️ Image Scan<br/>Trivy · Grype]:::s3
    SCAN --> SBOM[📄 SBOM + Sign<br/>Syft · Cosign]:::s4
    SBOM --> IAC[🏗️ IaC Scan<br/>Checkov · tfsec]:::s1
    IAC --> GIT[📂 GitOps Repo]:::s2
    GIT --> ARGO[🐙 ArgoCD]:::s5
    ARGO --> ADM[🚧 Admission<br/>Kyverno · OPA]:::s3
    ADM --> RUN[☸️ EKS Runtime]:::s6
    RUN --> FALCO[🦅 Falco]:::s7
    RUN --> DAST[🧪 DAST<br/>OWASP ZAP]:::s1
    FALCO --> SIEM[📊 SIEM / Alerts]:::s7

    classDef s0 fill:#4facfe,color:#000
    classDef s1 fill:#f7971e,color:#000
    classDef s2 fill:#43e97b,color:#000
    classDef s3 fill:#ff416c,color:#fff
    classDef s4 fill:#c471f5,color:#fff
    classDef s5 fill:#ef7b4d,color:#fff
    classDef s6 fill:#326ce5,color:#fff
    classDef s7 fill:#00c9a7,color:#000
```

---

## 🚀 GitOps & Delivery

```mermaid
flowchart LR
    subgraph CI["🛠️ CI · GitHub Actions"]
        A1[Lint + Test]:::ci --> A2[Build Image]:::ci --> A3[Scan + Sign]:::ci --> A4[Push to ECR]:::ci
    end
    subgraph GO["📂 GitOps Repo"]
        B1[Helm values / Kustomize]:::git
    end
    subgraph CD["🐙 CD · ArgoCD"]
        C1[App of Apps]:::cd --> C2[Argo Rollouts<br/>Canary / Blue-Green]:::cd
    end
    subgraph ENV["☸️ Environments"]
        D1[dev]:::env --> D2[staging]:::env --> D3[prod]:::env
    end

    A4 -->|update tag| B1
    B1 -->|sync| C1
    C2 --> D1
    D3 -.->|metrics gate| C2

    classDef ci fill:#4facfe,color:#000
    classDef git fill:#f7971e,color:#000
    classDef cd fill:#ef7b4d,color:#fff
    classDef env fill:#43e97b,color:#000
    style CI fill:#12263f,stroke:#4facfe,color:#fff
    style GO fill:#3d2400,stroke:#f7971e,color:#fff
    style CD fill:#3a1a10,stroke:#ef7b4d,color:#fff
    style ENV fill:#0b3d2e,stroke:#43e97b,color:#fff
```

---

## 🛡️ Defence in Depth

```mermaid
flowchart TB
    subgraph L1["🌍 Layer 1 · Edge"]
        E1[WAF · Shield · CloudFront · Rate limiting]
    end
    subgraph L2["🌐 Layer 2 · Network"]
        E2[VPC isolation · Security Groups · NetworkPolicies · PrivateLink]
    end
    subgraph L3["🕸️ Layer 3 · Service Mesh"]
        E3[Istio mTLS · AuthorizationPolicy · JWT validation]
    end
    subgraph L4["☸️ Layer 4 · Cluster"]
        E4[RBAC · Pod Security Standards · Kyverno · IRSA / Pod Identity]
    end
    subgraph L5["📦 Layer 5 · Workload"]
        E5[Signed images · Non-root · Read-only FS · Falco runtime detection]
    end
    subgraph L6["🔑 Layer 6 · Data"]
        E6[KMS encryption · Vault · Secrets Manager · TLS everywhere]
    end

    L1 --> L2 --> L3 --> L4 --> L5 --> L6

    style L1 fill:#ff416c,stroke:#fff,color:#fff
    style L2 fill:#f7971e,stroke:#fff,color:#000
    style L3 fill:#ffd200,stroke:#fff,color:#000
    style L4 fill:#43e97b,stroke:#fff,color:#000
    style L5 fill:#4facfe,stroke:#fff,color:#000
    style L6 fill:#c471f5,stroke:#fff,color:#fff
```

---

## 🤖 MLOps Lifecycle

```mermaid
flowchart LR
    DATA[(📥 Raw Data<br/>S3 Data Lake)]:::d --> ING[🔄 Ingestion<br/>Airflow · Kafka]:::p
    ING --> FEAT[🧮 Feature Store<br/>Feast]:::p
    FEAT --> TRAIN[🏋️ Training<br/>Kubeflow · SageMaker]:::t
    TRAIN --> TRACK[📒 Experiment Tracking<br/>MLflow]:::t
    TRACK --> EVAL{✅ Meets<br/>threshold?}:::g
    EVAL -->|yes| REG[🗃️ Model Registry]:::t
    EVAL -->|no| TRAIN
    REG --> SERVE[🚀 Serving<br/>KServe]:::s
    SERVE --> F[🕵️ fraud-detection-api]:::s
    SERVE --> CR[📊 credit-scoring-api]:::s
    F & CR --> MON[📈 Monitoring<br/>Evidently · Prometheus]:::m
    MON -->|drift detected| TRAIN

    classDef d fill:#434343,stroke:#ffd200,color:#fff
    classDef p fill:#4facfe,color:#000
    classDef t fill:#f7971e,color:#000
    classDef g fill:#ffd200,color:#000
    classDef s fill:#43e97b,color:#000
    classDef m fill:#ff416c,color:#fff
```

### 🔁 Model Lifecycle States

```mermaid
stateDiagram-v2
    [*] --> Experiment
    Experiment --> Staging: passes evaluation
    Staging --> Canary: shadow tests OK
    Canary --> Production: metrics healthy
    Production --> Drifted: drift detected
    Drifted --> Experiment: retrain
    Canary --> Staging: rollback
    Production --> Archived: replaced by new version
    Archived --> [*]
```

---

## 🧠 AI / GenAI Capabilities

```mermaid
mindmap
  root((🧠 AI and GenAI))
    🗣️ LLM Apps
      Customer Support Assistant
      Financial Q&A Chatbot
      Statement Summarisation
    📚 RAG
      Bedrock Knowledge Bases
      LangChain
      LlamaIndex
      pgvector
      OpenSearch
    🛡️ Guardrails
      Bedrock Guardrails
      PII Redaction
      Prompt Injection Defence
    🤖 Agents
      Bedrock Agents
      MCP Servers
      Tool calling
    📊 Predictive ML
      Fraud Detection
      Credit Scoring
      Churn Prediction
    🔭 LLMOps
      Prompt Versioning
      Evaluation
      Token and Cost Tracking
```

### 🧠 GenAI Assistant Flow (RAG)

```mermaid
flowchart LR
    Q[💬 User question]:::u --> G1[🛡️ Input guardrails<br/>PII · injection]:::g
    G1 --> EMB[🔢 Embed query]:::p
    EMB --> VS[(🔎 pgvector search)]:::d
    VS --> CTX[📚 Retrieve top-k context]:::p
    CTX --> LLM[🧠 LLM · Bedrock]:::l
    LLM --> G2[🛡️ Output guardrails]:::g
    G2 --> A[✅ Answer + sources]:::u
    LLM -.-> TR[📈 Trace · cost · eval]:::m

    classDef u fill:#4facfe,color:#000
    classDef g fill:#ff416c,color:#fff
    classDef p fill:#43e97b,color:#000
    classDef d fill:#434343,stroke:#ffd200,color:#fff
    classDef l fill:#c471f5,color:#fff
    classDef m fill:#f7971e,color:#000
```

---

## 📊 Observability

```mermaid
flowchart LR
    subgraph SRC["📡 Sources"]
        P1[14 Microservices]
        P2[EKS Nodes]
        P3[Istio Mesh]
    end
    subgraph COL["🔌 Collection"]
        OT[OpenTelemetry Collector]
    end
    subgraph STORE["💾 Storage"]
        PM[(Prometheus)]
        LK[(Loki)]
        TP[(Tempo)]
    end
    subgraph VIZ["📈 Visualise & Alert"]
        GF[Grafana]
        AM[Alertmanager]
        PD[PagerDuty]
    end

    P1 & P2 & P3 --> OT
    OT --> PM & LK & TP
    PM & LK & TP --> GF
    PM --> AM --> PD

    style SRC fill:#12263f,stroke:#4facfe,color:#fff
    style COL fill:#2a1245,stroke:#c471f5,color:#fff
    style STORE fill:#3d2400,stroke:#f7971e,color:#fff
    style VIZ fill:#0b3d2e,stroke:#43e97b,color:#fff
```

---

## 🧰 Tech Stack

### ☁️ AWS Infrastructure
| Area | Tools |
|---|---|
| **Compute / Containers** | Amazon EKS, **Karpenter**, Fargate, ECR, EC2 Spot |
| **Networking** | VPC, Subnets, NAT, Transit Gateway, PrivateLink, Route 53, CloudFront, ALB/NLB |
| **Data** | Aurora PostgreSQL, ElastiCache Redis, S3, DynamoDB, MSK (Kafka) |
| **Security** | IAM, IRSA / Pod Identity, KMS, Secrets Manager, GuardDuty, Security Hub, WAF, Shield, Inspector, Config |
| **Observability** | CloudWatch, X-Ray, Managed Prometheus, Managed Grafana |
| **AI / ML** | Bedrock, SageMaker, Comprehend, Textract |

### 🏗️ Infrastructure as Code & GitOps
| Area | Tools |
|---|---|
| **IaC** | **Terraform**, Terragrunt, Crossplane |
| **GitOps** | ArgoCD, Argo Rollouts, Argo Workflows, Helm, Kustomize |
| **CI/CD** | GitHub Actions, Jenkins, Tekton |

### 🛡️ DevSecOps
| Area | Tools |
|---|---|
| **Secrets** | Gitleaks, HashiCorp Vault, External Secrets Operator |
| **SAST / DAST** | SonarQube, Semgrep, OWASP ZAP |
| **Container / Supply chain** | Trivy, Grype, Syft (SBOM), **Cosign**, SLSA |
| **IaC scanning** | Checkov, tfsec, KICS |
| **Policy** | **Kyverno**, OPA Gatekeeper, Pod Security Standards |
| **Runtime** | Falco, Tetragon, Istio mTLS, Network Policies, Cilium |
| **Compliance** | PCI-DSS, SOC 2, CIS Benchmarks (kube-bench) |

### 📊 Observability & Reliability
Prometheus · Grafana · Loki · Tempo · OpenTelemetry · Alertmanager · PagerDuty · SLO/SLI · Chaos Mesh · Velero · k6

### 🤖 MLOps & AI
MLflow · Kubeflow · KServe · Feast · Airflow · Evidently · SageMaker · Bedrock · LangChain · LlamaIndex · pgvector · Ray

---

## 📈 Skill Coverage

```mermaid
pie showData title Platform Engineering Focus Areas
    "Kubernetes / EKS" : 20
    "Infrastructure as Code" : 15
    "DevSecOps" : 20
    "CI/CD and GitOps" : 12
    "Observability / SRE" : 10
    "MLOps" : 13
    "GenAI / LLMOps" : 10
```

```mermaid
quadrantChart
    title Tooling by Impact vs Effort
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Plan carefully
    quadrant-2 Do first
    quadrant-3 Nice to have
    quadrant-4 Reconsider
    Gitleaks: [0.15, 0.7]
    Trivy: [0.2, 0.8]
    ArgoCD: [0.45, 0.85]
    Karpenter: [0.5, 0.8]
    Kyverno: [0.4, 0.75]
    Istio mTLS: [0.7, 0.8]
    Vault: [0.75, 0.7]
    KServe: [0.8, 0.6]
    Chaos Mesh: [0.6, 0.35]
    GenAI RAG: [0.7, 0.65]
```

---

## 🗺️ Roadmap

```mermaid
gantt
    title Project Roadmap
    dateFormat  YYYY-MM-DD
    axisFormat  %b %Y
    section Foundation
    Repo, README, .gitignore          :done,    f1, 2026-11-01, 3d
    Terraform VPC + EKS + Karpenter   :active,  f2, 2026-11-04, 14d
    section Application
    Frontend + 2 BFFs                 :         a1, after f2, 21d
    7 core app microservices + Aurora :         a2, after a1, 35d
    section DevSecOps
    CI/CD, scanning, signing          :         d1, after f2, 21d
    Kyverno, Falco, Vault, Istio      :         d2, after d1, 28d
    section GitOps and Observability
    ArgoCD + Rollouts                 :         g1, after d1, 14d
    Prometheus, Grafana, Loki, Tempo  :         g2, after g1, 21d
    section MLOps and AI
    Fraud and credit models + MLflow  :         m1, after a2, 28d
    Training pipeline + KServe        :         m2, after m1, 21d
    GenAI RAG assistant + guardrails  :         m3, after m2, 28d
```

```mermaid
timeline
    title Evolution of the Platform
    Phase 1 - Foundation : Repository and docs : Terraform VPC, EKS, Karpenter
    Phase 2 - Services : Frontend and BFFs : 7 application microservices : Aurora, Redis, Kafka
    Phase 3 - Security : CI/CD scanning and signing : Kyverno, Falco, Vault : Istio mTLS
    Phase 4 - Delivery : ArgoCD GitOps : Canary rollouts : Observability stack
    Phase 5 - Intelligence : MLOps pipeline : Fraud and credit scoring : GenAI RAG assistant
```

| Status | Item |
|:--:|---|
| ✅ | Repository scaffold, README, `.gitignore` |
| 🔜 | Terraform: VPC, EKS cluster, Karpenter |
| 🔜 | Frontend, 2 BFFs and 7 application microservices |
| 🔜 | CI/CD with scanning, SBOM and image signing |
| 🔜 | ArgoCD GitOps, Kyverno policies, Falco, Istio |
| 🔜 | Observability stack (Prometheus, Grafana, Loki, Tempo) |
| 🔜 | MLOps pipeline and 2 prediction APIs |
| 🔜 | GenAI assistant with RAG and guardrails |

---

## 📁 Repository Structure

```text
FinTech-Enterprise-Project/
├── .gitignore
└── README.md             # more folders are added as the project grows
```

---

<div align="center">

### 👩‍💻 Built by a DevOps engineer, for DevOps engineers

⭐ Star this repo to follow along as it grows.

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:00c9a7,50:2c5364,100:0f2027&height=140&section=footer" alt="footer"/>

</div>
