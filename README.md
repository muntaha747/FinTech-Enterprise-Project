<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f2027,50:2c5364,100:00c9a7&height=240&section=header&text=FinTech%20Enterprise%20Project&fontSize=52&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=EKS%20%7C%20DevSecOps%20%7C%20MLOps%20%7C%20GenAI%20%7C%20Platform%20Engineering&descAlignY=60&descSize=18" alt="banner"/>

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=22&pause=1000&color=00C9A7&center=true&vCenter=true&width=800&lines=A+replica+of+real-world+FinTech+platforms;EKS+%2B+Karpenter+%2B+GitOps+%2B+DevSecOps;MLOps+%26+GenAI+microservices+for+prediction;Built+for+Platform+%2F+Senior+DevOps+Engineers)](https://git.io/typing-svg)

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=FF9900)
![Kubernetes](https://img.shields.io/badge/EKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Karpenter](https://img.shields.io/badge/Karpenter-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MLflow](https://img.shields.io/badge/MLflow-0194E2?style=for-the-badge&logo=mlflow&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Status](https://img.shields.io/badge/Status-Actively%20Evolving-00c9a7?style=for-the-badge)

</div>

---

## 🌟 About This Project

> **This repository is a replica of the FinTech platform from my past projects and professional work experience.**

It is an **EKS-based, multi-tier FinTech platform** made of four layers: **Frontend → BFF → Application → Database**. It also includes an **MLOps** layer with several microservices for model training and data prediction, plus **AI / GenAI** services.

The project **will be upgraded over time**. Each upgrade showcases a modern tool, skill or concept, with **DevSecOps security** as the main concern throughout. It mirrors the toolset and skillset expected of a **Platform Engineer / Senior DevOps Engineer in a FinTech organisation**.

> ⚠️ **Note:** this README describes the target architecture. The [Roadmap](#-roadmap) shows what is done and what is planned. Items marked ✅ exist in the repo and items marked 🔜 are planned.

---

## 🏗️ High-Level Architecture

```mermaid
flowchart TB
    User([👤 Customer]) --> CF[☁️ CloudFront + WAF + Shield]
    CF --> ALB[⚖️ AWS ALB / Ingress]

    subgraph EKS["☸️ Amazon EKS Cluster (Karpenter-autoscaled)"]
        direction TB
        subgraph FE["🎨 Frontend Layer"]
            WEB[React / Next.js Web App]
        end
        subgraph BFF["🔀 BFF Layer"]
            BFFWEB[Web BFF]
            BFFMOB[Mobile BFF]
        end
        subgraph APP["⚙️ Application Layer"]
            AUTH[Auth Service]
            ACC[Accounts Service]
            PAY[Payments Service]
            TXN[Transactions Service]
            NOTIF[Notification Service]
        end
        subgraph ML["🤖 MLOps & AI Layer"]
            FRAUD[Fraud Detection API]
            CREDIT[Credit Scoring API]
            TRAIN[Training Pipeline]
            GENAI[GenAI Assistant / RAG]
        end
        MESH{{🕸️ Istio Service Mesh - mTLS}}
    end

    subgraph DB["🗄️ Database Layer"]
        RDS[(Aurora PostgreSQL)]
        REDIS[(ElastiCache Redis)]
        S3[(S3 Data Lake)]
        VEC[(Vector DB / pgvector)]
    end

    ALB --> WEB --> BFFWEB & BFFMOB
    BFFWEB & BFFMOB --> AUTH & ACC & PAY & TXN
    PAY --> FRAUD
    ACC --> CREDIT
    TXN --> NOTIF
    AUTH & ACC & PAY & TXN --> RDS
    AUTH --> REDIS
    TRAIN --> S3
    GENAI --> VEC
    FRAUD & CREDIT --> S3

    style EKS fill:#0f2027,stroke:#00c9a7,color:#fff,stroke-width:2px
    style FE fill:#1e3c72,stroke:#4facfe,color:#fff
    style BFF fill:#5b247a,stroke:#c471f5,color:#fff
    style APP fill:#134e5e,stroke:#71b280,color:#fff
    style ML fill:#7f1d1d,stroke:#ff9966,color:#fff
    style DB fill:#232526,stroke:#f7971e,color:#fff
```

---

## 🔐 DevSecOps Pipeline

```mermaid
flowchart LR
    DEV[👨‍💻 Commit] --> PRE[🪝 pre-commit<br/>gitleaks]
    PRE --> SAST[🔍 SAST<br/>SonarQube · Semgrep]
    SAST --> SCA[📦 SCA<br/>Trivy · Snyk]
    SCA --> BUILD[🐳 Docker Build]
    BUILD --> SCAN[🛡️ Image Scan<br/>Trivy · Grype]
    SCAN --> SBOM[📄 SBOM + Sign<br/>Syft · Cosign]
    SBOM --> IAC[🏗️ IaC Scan<br/>Checkov · tfsec]
    IAC --> GIT[📂 GitOps Repo]
    GIT --> ARGO[🐙 ArgoCD]
    ARGO --> ADM[🚧 Admission<br/>Kyverno · OPA]
    ADM --> RUN[☸️ EKS Runtime]
    RUN --> FALCO[🦅 Falco<br/>Runtime Security]
    RUN --> OBS[📊 Prometheus · Grafana · Loki]

    style DEV fill:#4facfe,color:#000
    style SAST fill:#f7971e,color:#000
    style SCA fill:#f7971e,color:#000
    style SCAN fill:#ff416c,color:#fff
    style SBOM fill:#c471f5,color:#fff
    style IAC fill:#f7971e,color:#000
    style ARGO fill:#ef7b4d,color:#fff
    style ADM fill:#ff416c,color:#fff
    style RUN fill:#326ce5,color:#fff
    style FALCO fill:#00c9a7,color:#000
```

---

## 🤖 MLOps Lifecycle

```mermaid
flowchart LR
    DATA[(📥 Raw Data<br/>S3 Data Lake)] --> ING[🔄 Ingestion<br/>Airflow · Kafka]
    ING --> FEAT[🧮 Feature Store<br/>Feast]
    FEAT --> TRAIN[🏋️ Training<br/>Kubeflow · SageMaker]
    TRAIN --> TRACK[📒 Tracking<br/>MLflow]
    TRACK --> REG[🗃️ Model Registry]
    REG --> SERVE[🚀 Serving<br/>KServe · Seldon]
    SERVE --> API[🔌 Prediction APIs<br/>Fraud · Credit]
    API --> MON[📈 Monitoring<br/>Evidently · Prometheus]
    MON -->|drift detected| TRAIN

    style DATA fill:#232526,color:#fff
    style TRAIN fill:#7f1d1d,color:#fff
    style TRACK fill:#0194e2,color:#fff
    style SERVE fill:#134e5e,color:#fff
    style MON fill:#f7971e,color:#000
```

---

## 🧠 AI / GenAI Capabilities

```mermaid
mindmap
  root((🧠 AI & GenAI))
    🗣️ LLM Apps
      Customer Support Assistant
      Financial Q&A Chatbot
      Statement Summarisation
    📚 RAG
      Amazon Bedrock Knowledge Bases
      LangChain
      LlamaIndex
      pgvector / OpenSearch
    🛡️ Guardrails
      Bedrock Guardrails
      PII Redaction
      Prompt Injection Defence
    🤖 Agents
      Bedrock Agents
      MCP Servers
      Tool-calling workflows
    📊 Predictive ML
      Fraud Detection
      Credit Scoring
      Churn Prediction
    🔭 LLMOps
      Prompt Versioning
      Evaluation
      Cost and Token Tracking
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
| **IaC** | **Terraform**, Terragrunt, Crossplane (planned) |
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

## 📊 Skill Coverage

```mermaid
pie showData title Platform Engineering Focus Areas
    "Kubernetes / EKS" : 20
    "Infrastructure as Code" : 15
    "DevSecOps" : 20
    "CI/CD & GitOps" : 12
    "Observability / SRE" : 10
    "MLOps" : 13
    "GenAI / LLMOps" : 10
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
    Frontend + BFF services           :         a1, after f2, 21d
    Core microservices + Aurora       :         a2, after a1, 28d
    section DevSecOps
    CI/CD + scanning + signing        :         d1, after f2, 21d
    Kyverno, Falco, Vault             :         d2, after d1, 21d
    section GitOps & Obs
    ArgoCD + Prometheus + Grafana     :         g1, after d1, 21d
    section MLOps & AI
    Fraud / credit model + MLflow     :         m1, after a2, 28d
    GenAI RAG assistant + guardrails  :         m2, after m1, 28d
```

| Status | Item |
|:--:|---|
| ✅ | Repository scaffold, README, `.gitignore` |
| ✅ | Terraform: VPC, EKS cluster, Karpenter IAM and controller |
| ✅ | Karpenter NodePool / EC2NodeClass starter manifests |
| 🔜 | Frontend, BFF and application microservices |
| 🔜 | CI/CD with scanning, SBOM and image signing |
| 🔜 | ArgoCD GitOps, Kyverno policies, Falco |
| 🔜 | Observability stack (Prometheus, Grafana, Loki, Tempo) |
| 🔜 | MLOps pipeline (MLflow, KServe, Feast, Airflow) |
| 🔜 | GenAI assistant with RAG and guardrails |

---

## 📁 Repository Structure

```text
FinTech-Enterprise-Project/
├── terraform/            # AWS infra: VPC, EKS, Karpenter
├── k8s/
│   └── karpenter/        # NodePool + EC2NodeClass
├── .gitignore
└── README.md
```

---

## 🚀 Getting Started

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # edit values
terraform init
terraform plan
terraform apply

aws eks update-kubeconfig --name fintech-enterprise-eks --region us-east-1
kubectl apply -f ../k8s/karpenter/
```

> 💸 This creates billable AWS resources (EKS control plane, NAT gateway, EC2). Run `terraform destroy` when you are done.

---

<div align="center">

### 👩‍💻 Built by a DevOps engineer, for DevOps engineers

⭐ Star this repo to follow along as it grows.

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:00c9a7,50:2c5364,100:0f2027&height=120&section=footer" alt="footer"/>

</div>
