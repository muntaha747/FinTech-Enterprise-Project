<div align="center">

<img src="https://capsule-render.vercel.app/api?type=venom&color=0:0f2027,40:203a43,70:2c5364,100:00c9a7&height=280&section=header&text=FinTech%20Enterprise%20Project&fontSize=56&fontColor=ffffff&animation=twinkling&fontAlignY=40&desc=4%20VPCs%20%7C%20Transit%20Gateway%20%7C%20EKS%20%7C%20GitOps%20%7C%20MLOps&descAlignY=62&descSize=20" alt="banner"/>

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=22&pause=1000&color=00C9A7&center=true&vCenter=true&width=900&lines=A+replica+of+real-world+FinTech+platforms;5+microservices+on+Amazon+EKS;Edge+%C2%B7+App+%C2%B7+Data+%C2%B7+Ops+VPCs+joined+by+a+Transit+Gateway;Argo+CD+GitOps+%2B+Kubeflow+%2F+MLflow+%2F+KServe+MLOps;Built+for+Platform+%2F+Senior+DevOps+Engineers)](https://git.io/typing-svg)

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=FF9900)
![Kubernetes](https://img.shields.io/badge/Amazon%20EKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Argo CD](https://img.shields.io/badge/Argo%20CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Istio](https://img.shields.io/badge/Istio-466BB0?style=for-the-badge&logo=istio&logoColor=white)
![Vault](https://img.shields.io/badge/Vault-FFEC6E?style=for-the-badge&logo=vault&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Kafka](https://img.shields.io/badge/Kafka-231F20?style=for-the-badge&logo=apachekafka&logoColor=white)
![MLflow](https://img.shields.io/badge/MLflow-0194E2?style=for-the-badge&logo=mlflow&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)

![Microservices](https://img.shields.io/badge/Microservices-5-00c9a7?style=flat-square)
![VPCs](https://img.shields.io/badge/VPCs-Edge%20%7C%20App%20%7C%20Data%20%7C%20Ops-ff9900?style=flat-square)
![Layers](https://img.shields.io/badge/Layers-CI%2FCD%20%7C%20Edge%20%7C%20Network%20%7C%20Orchestration%20%7C%20App%20%7C%20Data-blueviolet?style=flat-square)
![Region](https://img.shields.io/badge/Region-us--east--1-232F3E?style=flat-square)
![Status](https://img.shields.io/badge/Status-Actively%20Evolving-brightgreen?style=flat-square)

</div>

---

## 📑 Table of Contents

- [About](#-about-this-project)
- [Project Overview & Architecture](#%EF%B8%8F-project-overview--architecture)
- [Tech Stack](#-tech-stack)
- [Live Traffic Flow](#-live-traffic-flow)
- [Microservices](#-microservices)
- [Request Flow](#-request-flow-making-a-payment)
- [Security by Layer](#%EF%B8%8F-security-by-layer)
- [CI/CD & GitOps](#-cicd--gitops)
- [MLOps](#-mlops-lifecycle)
- [Observability](#-observability)
- [Infrastructure Build: Networking & IAM](#%EF%B8%8F-infrastructure-build-networking--iam)
- [Roadmap](#%EF%B8%8F-roadmap)

---

## 🌟 About This Project

> **This repository is a replica of the FinTech platform from my past projects and professional work experience.**

It is an **AWS FinTech platform on Amazon EKS** built from **6 infrastructure layers** (CI/CD & DevTools → Edge → Network → Orchestration → Application → Data) plus two cross-cutting pillars (**Identity & Access** and **Observability**). It runs across **4 VPCs** (edge, app, data, ops) joined by a **Transit Gateway**.

- 🌐 **Edge:** Route 53, CloudFront, WAF, Shield Advanced and API Gateway
- ⚙️ **Microservices:** **5** services on EKS: BFF (Node.js), Payment (Go), Ledger (Java), Fraud (Python) and Notification (Node.js)
- 🗄️ **Data:** MySQL, Valkey, MongoDB, OpenSearch and Kafka
- 🛠️ **Ops:** Prometheus, Grafana, Argo CD, Vault, Kubeflow and MLflow
- 🤖 **MLOps:** Airflow, Kubeflow, MLflow and KServe for fraud scoring, monitored by Evidently AI and WhyLogs

The project grows in stages. Each stage adds a layer of the architecture below, with security built in at every layer.

<div align="center">

| ⚙️ Microservices | 🧱 Layers | 🏢 VPCs | 🧰 Tools | ☁️ Region |
|:---:|:---:|:---:|:---:|:---:|
| **5** | **6 + 2 pillars** | **4** | **48** | **us-east-1** |

</div>

---

## 🗺️ Project Overview & Architecture

<div align="center">

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=20&pause=900&color=00C9A7&center=true&vCenter=true&width=900&lines=6+infrastructure+layers+%C2%B7+2+cross-cutting+pillars;4+VPCs+%C2%B7+1+Transit+Gateway+%C2%B7+Amazon+EKS;48+tools+%C2%B7+one+consistent+architecture)](https://git.io/typing-svg)

</div>

### 🧱 FinTech Infrastructure Layers (AWS)

<div align="center">

<img src="docs/diagrams/infrastructure-layers.svg" width="100%" alt="Animated stack of six infrastructure layers (CI/CD, Edge, Network, Orchestration, Application, Data) with Identity and Access and Observability as cross-cutting pillars"/>

</div>

### 🏛️ Regional Architecture: 4 VPCs on AWS

<div align="center">

<img src="docs/diagrams/architecture-overview.svg" width="100%" alt="Animated regional architecture: edge, app, data and ops VPCs connected by a Transit Gateway, with EKS microservices, data stores, ops tooling, VPC endpoints to ECR, S3 and KMS, and NAT egress"/>

<sub>🎬 Animated: request, response, Transit Gateway, data, metrics, GitOps, endpoint and egress traffic.</sub>

</div>

### 🧰 Tech Stack

**48 tools**, every one of them shown in the two diagrams above, grouped exactly like the layers.

#### 🚀 01 · CI/CD & DevTools

<sub>Build, test and ship apps, infrastructure and ML models</sub>

![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)
![Argo CD](https://img.shields.io/badge/Argo%20CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![KServe](https://img.shields.io/badge/KServe-1F6FEB?style=for-the-badge)
![MLflow](https://img.shields.io/badge/MLflow-0194E2?style=for-the-badge&logo=mlflow&logoColor=white)

#### 🌐 02 · Edge

<sub>First contact for every request</sub>

![Route 53](https://img.shields.io/badge/Route%2053-8C4FFF?style=for-the-badge&logo=amazonroute53&logoColor=white)
![CloudFront](https://img.shields.io/badge/CloudFront-8C4FFF?style=for-the-badge)
![AWS WAF](https://img.shields.io/badge/AWS%20WAF-DD344C?style=for-the-badge)
![Shield Advanced](https://img.shields.io/badge/Shield%20Advanced-DD344C?style=for-the-badge)
![API Gateway](https://img.shields.io/badge/API%20Gateway-FF4F8B?style=for-the-badge&logo=amazonapigateway&logoColor=white)

#### 🕸️ 03 · Network

<sub>Isolate, connect and load-balance traffic</sub>

![Amazon VPC](https://img.shields.io/badge/Amazon%20VPC-8C4FFF?style=for-the-badge)
![Public Subnets](https://img.shields.io/badge/Public%20Subnets-43E97B?style=for-the-badge)
![Private Subnets](https://img.shields.io/badge/Private%20Subnets-326CE5?style=for-the-badge)
![Transit Gateway](https://img.shields.io/badge/Transit%20Gateway-FF7A00?style=for-the-badge)
![NAT Gateway](https://img.shields.io/badge/NAT%20Gateway-FF4081?style=for-the-badge)
![ALB](https://img.shields.io/badge/ALB-8C4FFF?style=for-the-badge)
![VPC Endpoints](https://img.shields.io/badge/VPC%20Endpoints-C471F5?style=for-the-badge)

#### ☸️ 04 · Orchestration

<sub>Run, scale, secure and roll out workloads</sub>

![Amazon EKS](https://img.shields.io/badge/Amazon%20EKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Calico](https://img.shields.io/badge/Calico-FB8C00?style=for-the-badge)
![Istio](https://img.shields.io/badge/Istio-466BB0?style=for-the-badge&logo=istio&logoColor=white)
![Argo Rollouts](https://img.shields.io/badge/Argo%20Rollouts-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![KEDA](https://img.shields.io/badge/KEDA-2A5CAA?style=for-the-badge)
![Karpenter](https://img.shields.io/badge/Karpenter-FF9900?style=for-the-badge)

#### ⚙️ 05 · Application

<sub>Business logic and ML pipelines</sub>

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Kubeflow](https://img.shields.io/badge/Kubeflow-326CE5?style=for-the-badge&logo=kubeflow&logoColor=white)

#### 🗄️ 06 · Data

<sub>Store, cache, search and stream</sub>

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Valkey](https://img.shields.io/badge/Valkey-6983FF?style=for-the-badge)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![OpenSearch](https://img.shields.io/badge/OpenSearch-005EB8?style=for-the-badge&logo=opensearch&logoColor=white)
![Apache Kafka](https://img.shields.io/badge/Apache%20Kafka-231F20?style=for-the-badge&logo=apachekafka&logoColor=white)

#### 🔑 · Identity & Access

<sub>Least privilege and secrets across every layer</sub>

![AWS IAM](https://img.shields.io/badge/AWS%20IAM-DD344C?style=for-the-badge)
![HashiCorp Vault](https://img.shields.io/badge/HashiCorp%20Vault-FFEC6E?style=for-the-badge&logo=vault&logoColor=white)
![AWS KMS](https://img.shields.io/badge/AWS%20KMS-DD344C?style=for-the-badge)

#### 🔭 · Observability

<sub>Metrics, logs, runtime security and ML drift across every layer</sub>

![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Loki](https://img.shields.io/badge/Loki-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Logstash](https://img.shields.io/badge/Logstash-005571?style=for-the-badge&logo=logstash&logoColor=white)
![Falco](https://img.shields.io/badge/Falco-00AEC7?style=for-the-badge)
![Evidently AI](https://img.shields.io/badge/Evidently%20AI-ED0400?style=for-the-badge)
![WhyLogs](https://img.shields.io/badge/WhyLogs-6B48FF?style=for-the-badge)
![CloudWatch](https://img.shields.io/badge/CloudWatch-FF4F8B?style=for-the-badge&logo=amazoncloudwatch&logoColor=white)

#### ☁️ · Shared AWS Services

<sub>Reached privately through VPC endpoints</sub>

![Amazon ECR](https://img.shields.io/badge/Amazon%20ECR-FF9900?style=for-the-badge)
![Amazon S3](https://img.shields.io/badge/Amazon%20S3-569A31?style=for-the-badge&logo=amazons3&logoColor=white)

<details>
<summary><b>📋 Every tool and what it does (table)</b></summary>

| Layer | Tool | Role in this project |
|---|---|---|
| CI/CD & DevTools | **Git** | source control |
| CI/CD & DevTools | **GitHub Actions** | CI pipelines |
| CI/CD & DevTools | **Apache Airflow** | ML & data workflows |
| CI/CD & DevTools | **Argo CD** | GitOps delivery |
| CI/CD & DevTools | **Terraform** | infrastructure as code |
| CI/CD & DevTools | **KServe** | model serving |
| CI/CD & DevTools | **MLflow** | experiments & registry |
| Edge | **Route 53** | DNS |
| Edge | **CloudFront** | CDN · TLS |
| Edge | **AWS WAF** | L7 firewall |
| Edge | **Shield Advanced** | DDoS protection |
| Edge | **API Gateway** | REST API front door |
| Network | **Amazon VPC** | 4 VPCs |
| Network | **Public Subnets** | internet-facing |
| Network | **Private Subnets** | workloads & data |
| Network | **Transit Gateway** | VPC hub |
| Network | **NAT Gateway** | outbound only |
| Network | **ALB** | L7 load balancer |
| Network | **VPC Endpoints** | private AWS access |
| Orchestration | **Amazon EKS** | Kubernetes |
| Orchestration | **Calico** | network policy |
| Orchestration | **Istio** | mTLS service mesh |
| Orchestration | **Argo Rollouts** | canary · blue-green |
| Orchestration | **KEDA** | event-driven pod scaling |
| Orchestration | **Karpenter** | node autoscaling |
| Application | **Node.js** | BFF · Notification |
| Application | **Go** | Payment |
| Application | **Java** | Ledger |
| Application | **Python** | Fraud |
| Application | **Kubeflow** | ML pipelines |
| Data | **MySQL** | transactions · ledger |
| Data | **Valkey** | cache · sessions |
| Data | **MongoDB** | documents |
| Data | **OpenSearch** | search · logs |
| Data | **Apache Kafka** | event-driven (EDA) |
| Identity & Access | **AWS IAM** | roles · policies |
| Identity & Access | **HashiCorp Vault** | secrets |
| Identity & Access | **AWS KMS** | encryption keys |
| Observability | **Prometheus** | metrics |
| Observability | **Grafana** | dashboards · alerts |
| Observability | **Loki** | logs |
| Observability | **Logstash** | log pipeline |
| Observability | **Falco** | runtime security |
| Observability | **Evidently AI** | model drift |
| Observability | **WhyLogs** | data profiling |
| Observability | **CloudWatch** | AWS telemetry |
| Shared AWS Services | **Amazon ECR** | container images |
| Shared AWS Services | **Amazon S3** | artifacts · data · state |

**Total: 48 tools**

</details>

### 📋 Layers at a glance

| # | Layer | Tools | Purpose |
|:-:|---|---|---|
| 01 | 🚀 **CI/CD & DevTools** | Git · GitHub Actions · Airflow · Argo CD · Terraform (IaC) · KServe · MLflow | Build, test, ship apps, infrastructure and ML models |
| 02 | 🌐 **Edge** | Route 53 (DNS) · CloudFront (CDN) · AWS WAF · AWS Shield Advanced · API Gateway (REST) | First contact: DNS, caching, L7 filtering, DDoS protection, API front door |
| 03 | 🕸️ **Network** | Public subnets · Private subnets · AWS Transit Gateway · NAT Gateway · ALB · VPC endpoints | Isolate, connect and load-balance traffic |
| 04 | ☸️ **Orchestration** | Kubernetes (EKS) · Calico · Istio · Argo Rollouts · KEDA · Karpenter | Run, scale, secure and progressively deliver workloads |
| 05 | ⚙️ **Application** | BFF (Node.js) · Payment (Go) · Ledger (Java) · Fraud (Python) · Notification (Node.js) · Kubeflow ML Pipelines | Business logic and ML pipelines |
| 06 | 🗄️ **Data** | MySQL · Valkey · MongoDB · OpenSearch · Kafka (event-driven architecture) | Store, cache, search and stream data |
| 🔑 | **Identity & Access** | AWS IAM (roles, policies) · HashiCorp Vault | Least privilege and secrets, across every layer |
| 🔭 | **Observability** | Prometheus · Grafana · Loki · Logstash · Falco · Evidently AI · WhyLogs · CloudWatch | Metrics, logs, runtime security and ML/data drift, across every layer |

```mermaid
mindmap
  root((🏦 FinTech Platform))
    🚀 CI/CD & DevTools
      Git
      GitHub Actions
      Airflow
      Argo CD
      Terraform IaC
      KServe
      MLflow
    🌐 Edge
      Route 53
      CloudFront
      WAF
      Shield Advanced
      API Gateway
    🕸️ Network
      Public Subnets
      Private Subnets
      Transit Gateway
      NAT Gateway
      ALB
    ☸️ Orchestration
      Kubernetes EKS
      Calico
      Istio
      Argo Rollouts
      KEDA
      Karpenter
    ⚙️ Application
      BFF · Node.js
      Payment · Go
      Ledger · Java
      Fraud · Python
      Notification · Node.js
      Kubeflow Pipelines
    🗄️ Data
      MySQL
      Valkey
      MongoDB
      OpenSearch
      Kafka EDA
    🔑 Identity and Access
      IAM Roles and Policies
      HashiCorp Vault
    🔭 Observability
      Prometheus
      Grafana
      Loki
      Logstash
      Falco
      Evidently AI
      WhyLogs
      CloudWatch
```

### 🗺️ VPC breakdown & service flow

| VPC | What runs there | How it connects |
|---|---|---|
| 🚪 **VPC A · Edge** `10.10.0.0/16` | Route 53 · CloudFront · WAF + Shield Advanced · API Gateway | Internet-facing. API Gateway forwards to the app VPC's ALB (VPC Link via Transit Gateway) |
| ⚙️ **VPC B · App** `10.20.0.0/16` | ALB → Amazon EKS: BFF, Payment, Ledger, Fraud, Notification services · KServe · Airflow · Kubeflow · Istio · Calico · KEDA · Karpenter | Transit Gateway to data and ops · VPC endpoints to ECR and S3 · NAT Gateway for outbound calls |
| 🗄️ **VPC C · Data** `10.30.0.0/16` | MySQL · Valkey · Kafka · MongoDB · OpenSearch | Private only. Reached through the Transit Gateway · VPC endpoints to KMS and S3 |
| 🛠️ **VPC D · Ops** `10.40.0.0/16` | Prometheus · Grafana · Argo CD · HashiCorp Vault · Kubeflow · MLflow | Scrapes metrics and syncs GitOps through the Transit Gateway · VPC endpoint to S3 · NAT for alerting |
| 🔀 **Transit Gateway** | Hub for all 4 VPCs | `10.0.0.0/8 → TGW` in every route table |
| ☁️ **Shared AWS services** | Amazon ECR · Amazon S3 · AWS KMS | Reached privately through VPC endpoints, never over the internet |

```mermaid
flowchart LR
    U([👤 Customer]):::u --> R53[🧭 Route 53]:::e --> CF[☁️ CloudFront]:::e --> WAF[🧱 WAF + Shield]:::s --> API[🔌 API Gateway]:::e
    API ==>|VPC Link · TGW| ALB[⚖️ ALB]:::n
    subgraph EKS["☸️ Amazon EKS · Istio · Calico · KEDA · Karpenter"]
        BFF[🔀 BFF · Node.js]:::a --> PAY[💸 Payment · Go]:::a
        BFF --> LED[📒 Ledger · Java]:::a
        PAY --> FR[🕵️ Fraud · Python]:::a
        PAY --> NOT[🔔 Notification · Node.js]:::a
        FR --> KS[🚀 KServe]:::m
    end
    ALB --> BFF
    PAY & LED ==>|TGW| MY[(🐬 MySQL)]:::d
    BFF ==>|TGW| VK[(⚡ Valkey)]:::d
    PAY ==>|TGW| KF{{📨 Kafka}}:::d
    KF --> NOT
    NOT ==>|TGW| MG[(🍃 MongoDB)]:::d
    LED ==>|TGW| OS[(🔎 OpenSearch)]:::d
    EKS -.->|metrics| PR[🔥 Prometheus]:::o --> GR[📈 Grafana]:::o
    AR[🐙 Argo CD]:::o -.->|GitOps sync| EKS
    VT[🔐 Vault]:::o -.->|secrets| EKS
    KF2[🧪 Kubeflow + 🌬️ Airflow]:::m -->|models| ML[📒 MLflow]:::o --> KS

    classDef u fill:#ff9a9e,stroke:#fff,color:#000,stroke-width:2px
    classDef e fill:#4facfe,stroke:#fff,color:#000
    classDef s fill:#ff416c,stroke:#fff,color:#fff
    classDef n fill:#43e97b,stroke:#fff,color:#000
    classDef a fill:#0f3a2c,stroke:#43e97b,color:#fff
    classDef m fill:#f7971e,stroke:#fff,color:#000
    classDef d fill:#3a1424,stroke:#ff416c,color:#fff,stroke-width:2px
    classDef o fill:#c471f5,stroke:#fff,color:#fff
    style EKS fill:#0b2235,stroke:#326ce5,color:#fff,stroke-width:2px
```

---

## 🚦 Live Traffic Flow

<div align="center">

<img src="docs/diagrams/traffic-flow.svg" width="100%" alt="Animated diagram of traffic flowing from the customer through CloudFront, the edge VPC, the Transit Gateway, the app VPC and the data and ops VPCs"/>

<sub>🎬 Animated: every moving dot is a real traffic type travelling through the network.</sub>

</div>

### 🛣️ Hop by hop: one payment request through the network

```mermaid
sequenceDiagram
    autonumber
    actor C as 👤 Customer
    participant R53 as 🧭 Route 53
    participant CF as ☁️ CloudFront + 🧱 WAF
    participant API as 🔌 API Gateway (edge VPC)
    participant TGW as 🔀 Transit Gateway
    participant ALB as ⚖️ ALB (app VPC)
    participant POD as 💸 payment pod (EKS)
    participant SM as 🔐 HashiCorp Vault (ops VPC)
    participant DB as 🐬 MySQL (data VPC)
    participant PSP as 🌍 Payment network

    C->>R53: api.fintech.example → resolve
    R53-->>C: CloudFront edge IP
    C->>CF: HTTPS request (TLS 1.3)
    CF->>CF: WAF rules · rate limit · Shield Advanced
    CF->>API: Forward to the REST API
    API->>TGW: VPC Link to 10.20.x.x → route 10.0.0.0/8 → TGW
    TGW->>ALB: Deliver into the app VPC
    ALB->>POD: Route via BFF to the payment service
    POD->>SM: Fetch DB credentials via TGW (Istio mTLS)
    SM-->>POD: Secret
    POD->>TGW: Query 10.30.x.x → route 10.0.0.0/8 → TGW
    TGW->>DB: Deliver into data VPC (10.30.11.0/24)
    DB-->>TGW: Rows
    TGW-->>POD: Rows
    POD->>PSP: Authorise card via NAT Gateway (outbound only)
    PSP-->>POD: ✅ Approved
    POD-->>ALB: 200 OK
    ALB-->>TGW: Response
    TGW-->>API: Response
    API-->>CF: Response
    CF-->>C: ✅ Payment complete
```

### 🧭 How a packet picks its path (route table decision)

```mermaid
flowchart LR
    P([📦 Packet leaves a pod]):::start --> Q1{Destination inside<br/>my own /16?}:::q
    Q1 -->|yes| L[🏠 local route<br/>stays in the VPC]:::local
    Q1 -->|no| Q2{AWS service with<br/>a VPC endpoint?}:::q
    Q2 -->|S3| G[🟢 Gateway endpoint<br/>prefix-list route]:::gw
    Q2 -->|ECR · KMS| I[🟣 Interface endpoint<br/>private DNS → ENI]:::ifep
    Q2 -->|no| Q3{Destination in<br/>10.0.0.0/8?}:::q
    Q3 -->|yes| T[🔀 Transit Gateway<br/>to another VPC]:::tgw
    Q3 -->|no| Q4{VPC has a<br/>NAT Gateway?}:::q
    Q4 -->|yes · app| N[🔁 NAT → IGW<br/>outbound internet]:::nat
    Q4 -->|no · data| X[⛔ Dropped<br/>no internet path]:::drop

    classDef start fill:#4facfe,stroke:#fff,color:#000,stroke-width:2px
    classDef q fill:#ffd200,stroke:#fff,color:#000
    classDef local fill:#8fd3f4,stroke:#fff,color:#000
    classDef gw fill:#43e97b,stroke:#fff,color:#000
    classDef ifep fill:#c471f5,stroke:#fff,color:#fff
    classDef tgw fill:#ff9900,stroke:#fff,color:#000,stroke-width:2px
    classDef nat fill:#ff4081,stroke:#fff,color:#fff
    classDef drop fill:#434343,stroke:#ff416c,color:#fff,stroke-width:2px
```

### 🛡️ Security checkpoints on the way in

```mermaid
flowchart LR
    A[👤 Internet]:::i --> B[🛡️ Shield Advanced<br/>DDoS]:::s1 --> C[🧱 WAF<br/>L7 rules]:::s2 --> D[☁️ CloudFront<br/>TLS]:::s3 --> E[🔌 API Gateway<br/>throttling]:::s4 --> F[🔀 Transit Gateway<br/>10.0.0.0/8]:::s5 --> G[⚖️ ALB<br/>listener rules]:::s6 --> H[🐯 Calico<br/>network policy]:::s7 --> I[🕸️ Istio<br/>mTLS]:::s8 --> J[⚙️ Service]:::ok

    classDef i fill:#ff9a9e,color:#000
    classDef s1 fill:#ff416c,color:#fff
    classDef s2 fill:#ff6a3d,color:#fff
    classDef s3 fill:#f7971e,color:#000
    classDef s4 fill:#ffd200,color:#000
    classDef s5 fill:#ff9900,color:#000
    classDef s6 fill:#84fab0,color:#000
    classDef s7 fill:#4facfe,color:#000
    classDef s8 fill:#c471f5,color:#fff
    classDef ok fill:#43e97b,color:#000,stroke:#fff,stroke-width:3px
```

---

## 🧩 Microservices

All five services run on **Amazon EKS in the app VPC**, behind the **ALB**, inside the **Istio** mesh with **Calico** network policies. **KEDA** scales pods on load and Kafka lag, and **Karpenter** adds nodes.

<div align="center">

| # | Service | Language | Responsibility | Calls | Data (data VPC) |
|:-:|---|:-:|---|---|---|
| 1 | 🔀 **BFF Service** | Node.js | Single API for web and mobile; aggregates and shapes responses | Payment, Ledger | Valkey (sessions, cache) |
| 2 | 💸 **Payment Service** | Go | Payment initiation and orchestration | Fraud, Ledger, Kafka | MySQL |
| 3 | 📒 **Ledger Service** | Java | Double-entry ledger and balances | – | MySQL, OpenSearch (search, audit) |
| 4 | 🕵️ **Fraud Service** | Python | Real-time fraud scoring | KServe model | MongoDB (fraud cases) |
| 5 | 🔔 **Notification Service** | Node.js | Email, SMS and push from payment events | – | Kafka (consumer), MongoDB |

</div>

| ML component | Where | Role |
|---|---|---|
| 🚀 **KServe** | app VPC (EKS) | Serves the fraud model to the Fraud Service |
| 🌬️ **Airflow** | app VPC (EKS) | Orchestrates data and training workflows |
| 🧪 **Kubeflow** | app + ops VPCs | ML pipelines: train and evaluate |
| 📒 **MLflow** | ops VPC | Experiment tracking and model registry |

### 🕸️ Service Dependency Map

```mermaid
flowchart LR
    ALB[⚖️ ALB]:::net --> BFF([🔀 BFF · Node.js]):::svc
    BFF --> PAY([💸 Payment · Go]):::svc
    BFF --> LED([📒 Ledger · Java]):::svc
    PAY --> FR([🕵️ Fraud · Python]):::svc
    PAY --> LED
    FR --> KS[🚀 KServe]:::ml
    PAY -->|PaymentCompleted| KF{{📨 Kafka}}:::data
    KF --> NOT([🔔 Notification · Node.js]):::svc
    BFF -.-> VK[(⚡ Valkey)]:::data
    PAY -.-> MY[(🐬 MySQL)]:::data
    LED -.-> MY
    LED -.-> OS[(🔎 OpenSearch)]:::data
    FR -.-> MG[(🍃 MongoDB)]:::data
    NOT -.-> MG
    ML[📒 MLflow]:::ml -.->|model version| KS

    classDef net fill:#43e97b,stroke:#fff,color:#000
    classDef svc fill:#4facfe,stroke:#fff,color:#000,stroke-width:2px
    classDef ml fill:#f7971e,stroke:#fff,color:#000
    classDef data fill:#3a1424,stroke:#ff416c,color:#fff,stroke-width:2px
```

---

## 💸 Request Flow: Making a Payment

```mermaid
sequenceDiagram
    autonumber
    actor C as 👤 Customer
    participant API as 🔌 API Gateway
    participant BFF as 🔀 BFF Service
    participant PAY as 💸 Payment Service
    participant FR as 🕵️ Fraud Service
    participant KS as 🚀 KServe
    participant LED as 📒 Ledger Service
    participant K as 📨 Kafka
    participant NT as 🔔 Notification Service

    C->>API: POST /payments (via Route 53 · CloudFront · WAF)
    API->>BFF: Forward through Transit Gateway → ALB
    BFF->>PAY: Create payment
    PAY->>FR: Score transaction
    FR->>KS: Predict
    KS-->>FR: risk score
    alt 🟢 Low risk
        FR-->>PAY: risk = 0.04
        PAY->>LED: Post debit / credit entries (MySQL)
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
    BFF-->>API: Response
    API-->>C: Show result
```

---

## 🛡️ Security by Layer

Every layer in the architecture adds its own control, and nothing depends on a single defence.

```mermaid
flowchart TB
    subgraph L1["🌐 Edge"]
        E1[Shield Advanced · WAF · CloudFront TLS · API Gateway throttling]
    end
    subgraph L2["🕸️ Network"]
        E2[4 isolated VPCs · private subnets · security groups · Transit Gateway routing · VPC endpoints]
    end
    subgraph L3["☸️ Orchestration"]
        E3[Calico network policies · Istio mTLS · Argo Rollouts safe releases]
    end
    subgraph L4["🔑 Identity & Access"]
        E4[IAM least-privilege roles · GitHub OIDC for CI · HashiCorp Vault secrets · KMS encryption]
    end
    subgraph L5["🔭 Detection"]
        E5[Falco runtime security · Prometheus + Grafana alerts · Loki · Logstash · CloudWatch]
    end
    subgraph L6["🤖 Model & Data Trust"]
        E6[Evidently AI drift · WhyLogs data profiling · MLflow model lineage]
    end

    L1 --> L2 --> L3 --> L4 --> L5 --> L6

    style L1 fill:#ff416c,stroke:#fff,color:#fff
    style L2 fill:#43e97b,stroke:#fff,color:#000
    style L3 fill:#f7971e,stroke:#fff,color:#000
    style L4 fill:#ffd200,stroke:#fff,color:#000
    style L5 fill:#00c9a7,stroke:#fff,color:#000
    style L6 fill:#c471f5,stroke:#fff,color:#fff
```

---

## 🔁 CI/CD & GitOps

**GitHub Actions** builds, **Terraform** provisions, **Argo CD** (ops VPC) syncs and **Argo Rollouts** releases progressively onto **EKS** (app VPC). Models follow the same path through **Airflow → Kubeflow → MLflow → KServe**.

```mermaid
flowchart LR
    subgraph SRC["🌿 Source"]
        G[Git · GitHub]:::s
    end
    subgraph CI["🐙 CI · GitHub Actions"]
        T[Lint + test]:::ci --> B[Build image]:::ci --> P[Push to ECR]:::ci
        TF[Terraform plan / apply]:::ci
    end
    subgraph CD["🔁 CD · Argo (ops VPC)"]
        A[Argo CD sync]:::cd --> R[Argo Rollouts<br/>canary / blue-green]:::cd
    end
    subgraph ENV["☸️ EKS environments"]
        Q[qa]:::env --> U[uat]:::env --> PR[prod]:::env
    end
    subgraph ML["🤖 Model delivery"]
        AF[Airflow]:::ml --> KF[Kubeflow pipelines]:::ml --> MF[MLflow registry]:::ml --> KS[KServe]:::ml
    end

    G --> T
    G --> TF
    P -->|update image tag| G
    G -->|watch| A
    R --> Q
    PR -.->|Prometheus metrics gate| R
    MF -.->|new model version| A

    classDef s fill:#f05032,color:#fff
    classDef ci fill:#2088ff,color:#fff
    classDef cd fill:#ef7b4d,color:#fff
    classDef env fill:#43e97b,color:#000
    classDef ml fill:#f7971e,color:#000
    style SRC fill:#2b1a1a,stroke:#f05032,color:#fff
    style CI fill:#12263f,stroke:#2088ff,color:#fff
    style CD fill:#3a1a10,stroke:#ef7b4d,color:#fff
    style ENV fill:#0b3d2e,stroke:#43e97b,color:#fff
    style ML fill:#3d2400,stroke:#f7971e,color:#fff
```

> 🔐 CI never stores AWS keys: GitHub Actions assumes the `FinTech-CI-CD-Deployer-<env>` IAM role through **GitHub OIDC**, as defined in the IAM module below.

---

## 🤖 MLOps Lifecycle

```mermaid
flowchart LR
    DATA[(📥 MySQL · MongoDB<br/>Kafka · S3)]:::d --> AF[🌬️ Airflow<br/>ingest + orchestrate]:::p
    AF --> KF[🧪 Kubeflow Pipelines<br/>train + evaluate]:::t
    KF --> MF[📒 MLflow<br/>track + register]:::t
    MF --> GATE{✅ Meets<br/>threshold?}:::g
    GATE -->|yes| KS[🚀 KServe<br/>serve]:::s
    GATE -->|no| KF
    KS --> FR[🕵️ Fraud Service]:::s
    FR --> MON[📉 Evidently AI drift<br/>📊 WhyLogs profiles<br/>🔥 Prometheus]:::m
    MON -->|drift detected| AF

    classDef d fill:#3a1424,stroke:#ff416c,color:#fff
    classDef p fill:#4facfe,color:#000
    classDef t fill:#f7971e,color:#000
    classDef g fill:#ffd200,color:#000
    classDef s fill:#43e97b,color:#000
    classDef m fill:#c471f5,color:#fff
```

### 🔁 Model Lifecycle States

```mermaid
stateDiagram-v2
    [*] --> Experiment: Kubeflow run
    Experiment --> Registered: logged in MLflow
    Registered --> Canary: KServe canary
    Canary --> Production: metrics healthy
    Production --> Drifted: Evidently AI / WhyLogs alert
    Drifted --> Experiment: retrain via Airflow
    Canary --> Registered: rollback
    Production --> Archived: replaced by new version
    Archived --> [*]
```

---

## 📊 Observability

The **ops VPC** collects telemetry from every layer over the **Transit Gateway**.

```mermaid
flowchart LR
    subgraph SRC["📡 Sources"]
        P1[5 microservices]
        P2[EKS nodes + Istio]
        P3[AWS: API Gateway · ALB · TGW]
        P4[KServe models]
    end
    subgraph COL["🔌 Collect"]
        PR[🔥 Prometheus<br/>metrics]
        LS[🧾 Logstash<br/>log pipeline]
        CW[☁️ CloudWatch<br/>AWS telemetry]
        FA[🦅 Falco<br/>runtime events]
        EV[📉 Evidently AI · 📊 WhyLogs<br/>ML + data drift]
    end
    subgraph STORE["💾 Store"]
        LK[(🪵 Loki)]
        OS[(🔎 OpenSearch)]
    end
    subgraph VIZ["📈 Visualise & Alert"]
        GF[Grafana dashboards + alerts]
    end

    P1 & P2 --> PR
    P1 & P2 --> LS --> LK & OS
    P3 --> CW
    P2 --> FA
    P4 --> EV
    PR & LK & CW & FA & EV --> GF

    style SRC fill:#12263f,stroke:#4facfe,color:#fff
    style COL fill:#2a1245,stroke:#c471f5,color:#fff
    style STORE fill:#3d2400,stroke:#f7971e,color:#fff
    style VIZ fill:#0b3d2e,stroke:#43e97b,color:#fff
```

---

## 📈 Skill Coverage

```mermaid
pie showData title Platform Engineering Focus Areas
    "Networking (VPC, TGW, Edge)" : 18
    "Kubernetes / EKS" : 18
    "Infrastructure as Code" : 14
    "CI/CD and GitOps" : 12
    "Security and IAM" : 12
    "Data platforms" : 10
    "Observability" : 8
    "MLOps" : 8
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
    Terraform: [0.3, 0.9]
    Transit Gateway: [0.35, 0.8]
    Argo CD: [0.4, 0.85]
    Karpenter: [0.5, 0.75]
    KEDA: [0.35, 0.6]
    Calico: [0.45, 0.65]
    Istio: [0.75, 0.8]
    Vault: [0.7, 0.75]
    Falco: [0.3, 0.6]
    KServe: [0.8, 0.6]
    Evidently AI: [0.55, 0.45]
```

---

## 🏗️ Infrastructure Build: Networking & IAM

<div align="center">

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=20&pause=900&color=FF9900&center=true&vCenter=true&width=900&lines=4+isolated+VPCs+joined+by+a+Transit+Gateway;Private+VPC+endpoints+%E2%80%94+no+internet+for+AWS+traffic;Least-privilege+IAM+roles+per+environment;Multi+state+files+in+one+encrypted+S3+backend;Terraform+1.17.1+%7C+AWS+provider+6.72+%7C+IAM+module+6.8.2)](https://git.io/typing-svg)

![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.17.1-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.72-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![IAM Module](https://img.shields.io/badge/terraform--aws--modules%2Fiam-6.8.2-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Region](https://img.shields.io/badge/Region-us--east--1-232F3E?style=for-the-badge&logo=amazonaws&logoColor=FF9900)
![State](https://img.shields.io/badge/State-S3%20%2B%20native%20lock-569A31?style=for-the-badge&logo=amazons3&logoColor=white)

</div>

This section documents what has been **built so far** in `infra-modules/`.

### 🧭 Build Journey

```mermaid
timeline
    title Infrastructure work completed
    State backend : S3 state bucket : Encrypted state : Native S3 lock file (no DynamoDB)
    IAM : Reusable child module : Platform, App team and CI/CD roles : One root stack per environment (ops, qa, uat, prod)
    Networking : Reusable network module : 4 VPCs from one for_each : Gateway + Interface VPC endpoints
    Connectivity : Transit Gateway hub : Subnets round-robin across 3 AZs : Corrected CIDRs 10.10 to 10.40
    Hardening : Fixed SG and AZ bugs : Private SG limited to VPC CIDR : Pinned latest Terraform, provider and module versions
```

---

### 🌐 Networking: 4 VPCs + Transit Gateway

One reusable module (`prod/Networking/network/`) is called **once per VPC** from the root module with `for_each`. Each VPC gets its own subnets, route tables, security groups and VPC endpoints. A **Transit Gateway** (`transit_gateway.tf`) joins them all.

<div align="center">

<img src="docs/diagrams/network-topology.svg" width="100%" alt="Animated hub-and-spoke diagram: edge, app, data and ops VPCs with their subnets per AZ, connected through a Transit Gateway"/>

</div>

```mermaid
flowchart TB
    INET((🌍 Internet)):::net

    subgraph REGION["☁️ AWS us-east-1 · AZs 1a · 1b · 1c"]
        direction TB

        subgraph EDGE["🚪 EDGE · 10.10.0.0/16"]
            EIGW[🌐 IGW]:::gw
            EPUB[public 10.10.1-3.0/24<br/>🔌 API Gateway · WAF]:::pub
            EPRIV[private 10.10.11-13.0/24]:::priv
        end

        subgraph APP["⚙️ APP · 10.20.0.0/16"]
            AIGW[🌐 IGW]:::gw
            ANAT[🔁 NAT Gateway]:::gw
            APUB[public 10.20.1-3.0/24<br/>⚖️ ALB]:::pub
            ACP[EKS control plane<br/>10.20.11-13.0/24]:::priv
            ADP[EKS data plane<br/>10.20.21-23.0/24]:::priv
        end

        subgraph DATA["🗄️ DATA · 10.30.0.0/16 · no internet"]
            DDB[MySQL · MongoDB · OpenSearch<br/>10.30.11-13.0/24]:::priv
            DKF[Kafka + Valkey<br/>10.30.21-23.0/24]:::priv
        end

        subgraph OPS["🛠️ OPS · 10.40.0.0/16"]
            OIGW[🌐 IGW]:::gw
            OPUB[public 10.40.1-3.0/24]:::pub
            OPRIV[Prometheus · Grafana · Argo<br/>Vault · Kubeflow · MLflow<br/>10.40.11-13.0/24]:::priv
        end

        TGW{{"🔀 TRANSIT GATEWAY<br/>10.0.0.0/8"}}:::tgw

        subgraph AWS["🔒 AWS services via VPC endpoints"]
            S3[(🪣 S3)]:::gwep
            DYN[(⚡ DynamoDB)]:::gwep
            ECR[📦 ECR]:::ifep
            SEC[🔑 Secrets · 📜 Logs]:::ifep
            KMS[🔐 KMS]:::ifep
            SSM[🖥️ SSM]:::ifep
        end
    end

    INET <--> EIGW --- EPUB
    INET <--> AIGW
    INET <--> OIGW --- OPUB
    ADP -->|outbound| ANAT --> AIGW

    EPRIV <==> TGW
    ACP <==> TGW
    ADP <==> TGW
    DDB <==> TGW
    DKF <==> TGW
    OPRIV <==> TGW

    ADP -.-> S3 & ECR & SEC
    DDB -.-> S3 & DYN & KMS
    OPRIV -.-> S3 & SSM

    classDef net fill:#ff9a9e,stroke:#fff,color:#000,stroke-width:2px
    classDef gw fill:#ff9900,stroke:#fff,color:#000
    classDef pub fill:#84fab0,stroke:#0b3d2e,color:#000
    classDef priv fill:#8fd3f4,stroke:#12263f,color:#000
    classDef tgw fill:#ff7a00,stroke:#ffd200,color:#000,stroke-width:3px
    classDef gwep fill:#43e97b,stroke:#fff,color:#000,stroke-width:2px
    classDef ifep fill:#c471f5,stroke:#fff,color:#fff,stroke-width:2px

    style REGION fill:#0f2027,stroke:#ff9900,color:#fff,stroke-width:3px
    style EDGE fill:#10372b,stroke:#84fab0,color:#fff,stroke-width:2px
    style APP fill:#12263f,stroke:#4facfe,color:#fff,stroke-width:2px
    style DATA fill:#2b1a1a,stroke:#ff416c,color:#fff,stroke-width:2px
    style OPS fill:#2a1245,stroke:#c471f5,color:#fff,stroke-width:2px
    style AWS fill:#1a1a1a,stroke:#ffd200,color:#fff,stroke-width:2px
```

> 🟠 thick arrows = **Transit Gateway** · 🟢/🟣 dotted arrows = **VPC endpoints** · 🌐 = Internet Gateway

| VPC | CIDR | Public subnets | Private subnets | NAT | Gateway endpoints | Interface endpoints |
|---|---|:-:|:-:|:-:|---|---|
| 🚪 **edge** | `10.10.0.0/16` | 3 | 3 | – | s3 | – |
| ⚙️ **app** | `10.20.0.0/16` | 3 | 6 (EKS control + data plane) | ✅ | s3 | ecr.api, ecr.dkr, logs, secretsmanager |
| 🗄️ **data** | `10.30.0.0/16` | – | 6 (DBs + Kafka/Valkey) | – | s3, dynamodb | kms |
| 🛠️ **ops** | `10.40.0.0/16` | 3 | 3 | – | s3 | ssm, ssmmessages, ec2messages |

**In simple words:**
- 🏢 Each **VPC is a separate building** with its own address range. The `10.10 / 10.20 / 10.30 / 10.40` CIDRs never overlap, so they can all be joined.
- 🔀 The **Transit Gateway is the central hub** that connects the buildings. Every private route table has one route, `10.0.0.0/8 → TGW`, and traffic inside a VPC stays local because its own `/16` is more specific.
- 🌐 **Public subnets** face the internet through an **Internet Gateway**.
- 🔐 **Private subnets** can't be reached from outside. Apps, databases and monitoring live here.
- 🔁 **NAT Gateway** (app): pods can call out, for example to a payment network, but nothing can come in.
- 🚇 **VPC endpoints** are private tunnels to AWS services, so ECR, S3, Secrets Manager and KMS are reached **without the internet**.
- 🗄️ The **data VPC has no internet path at all**. It's reachable only through the TGW.
- 🏗️ Subnets go **round-robin across 3 AZs** (1a → 1b → 1c → 1a …), so 6 subnets give 2 per AZ, and the first 3 (one per AZ) host the TGW attachment and endpoint ENIs.

#### 🔀 How the root module creates all 4 VPCs

```mermaid
flowchart LR
    L["📄 locals.tf<br/>vpcs = { edge, app, data, ops }"]:::loc --> M{"🔁 module network<br/>for_each = local.vpcs"}:::mod
    M --> E["🚪 module.network[edge]"]:::edge
    M --> A["⚙️ module.network[app]"]:::app
    M --> D["🗄️ module.network[data]"]:::data
    M --> O["🛠️ module.network[ops]"]:::ops
    E & A & D & O --> R["📦 Each instance creates:<br/>VPC · subnets · route tables<br/>SGs · NAT/IGW if public<br/>Gateway + Interface endpoints"]:::res
    R --> T["🔀 transit_gateway.tf<br/>attach + route every VPC<br/>(for_each = local.vpcs)"]:::tgw

    classDef loc fill:#ffd200,stroke:#fff,color:#000,stroke-width:2px
    classDef mod fill:#7B42BC,stroke:#fff,color:#fff,stroke-width:2px
    classDef edge fill:#84fab0,stroke:#fff,color:#000
    classDef app fill:#4facfe,stroke:#fff,color:#000
    classDef data fill:#ff416c,stroke:#fff,color:#fff
    classDef ops fill:#c471f5,stroke:#fff,color:#fff
    classDef res fill:#0f2027,stroke:#00c9a7,color:#fff,stroke-width:2px
    classDef tgw fill:#ff7a00,stroke:#ffd200,color:#000,stroke-width:2px
```

#### 🚇 VPC endpoints: Gateway vs Interface

```mermaid
flowchart LR
    subgraph GW["🟢 Gateway endpoint · S3 / DynamoDB · FREE"]
        direction LR
        P1[🖥️ Private workload]:::wl --> RT[🗺️ Private route table<br/>prefix list → vpce]:::rt --> G[(🪣 S3 / DynamoDB)]:::svc
    end
    subgraph IF["🟣 Interface endpoint · ECR, Secrets, KMS, SSM, Logs"]
        direction LR
        P2[🖥️ Private workload]:::wl -->|DNS: service.us-east-1.amazonaws.com| DNS[🔎 Private DNS<br/>→ endpoint private IP]:::dns
        DNS --> SG[🛡️ Endpoint SG<br/>443 from VPC CIDR]:::sg --> ENI[🔌 ENI in each AZ<br/>1a · 1b · 1c]:::eni --> I[☁️ AWS service]:::svc
    end

    classDef wl fill:#4facfe,stroke:#fff,color:#000
    classDef rt fill:#43e97b,stroke:#fff,color:#000
    classDef dns fill:#ffd200,stroke:#fff,color:#000
    classDef sg fill:#ff416c,stroke:#fff,color:#fff
    classDef eni fill:#c471f5,stroke:#fff,color:#fff
    classDef svc fill:#ff9900,stroke:#fff,color:#000,stroke-width:2px
    style GW fill:#0b3d2e,stroke:#43e97b,color:#fff,stroke-width:2px
    style IF fill:#2a1245,stroke:#c471f5,color:#fff,stroke-width:2px
```

**How the endpoint code works** (`network/main.tf`):

| Resource | What it does |
|---|---|
| `data.aws_region.current` | Reads the provider's region, so endpoint names are never hardcoded |
| `aws_vpc_endpoint.gateway` | `for_each = toset(var.gateway_endpoints)` creates one free Gateway endpoint per service and attaches it to the private route tables |
| `aws_security_group.endpoint_sg` | Created only if `interface_endpoints` isn't empty. Allows HTTPS 443 from the VPC CIDR |
| `aws_vpc_endpoint.interface` | `for_each = toset(var.interface_endpoints)` places an ENI in the first private subnet of each AZ (`private_subnet_ids_per_az`). `private_dns_enabled = true` means application code needs **no changes** |

```hcl
# Per-VPC input: just two simple lists
gateway_endpoints   = ["s3", "dynamodb"]
interface_endpoints = ["secretsmanager", "kms"]
```

#### 🔀 Transit Gateway: how VPCs talk to each other

```mermaid
sequenceDiagram
    autonumber
    participant POD as ⚙️ app pod 10.20.21.15
    participant ART as 🗺️ app private route table
    participant TGW as 🔀 Transit Gateway
    participant TRT as 📋 TGW route table
    participant DB as 🐬 MySQL 10.30.11.20

    POD->>ART: Send to 10.30.11.20
    ART->>ART: 10.20.0.0/16 local? ✖ · 10.0.0.0/8 → TGW ✅
    ART->>TGW: Forward via app attachment
    TGW->>TRT: Look up 10.30.11.20
    TRT-->>TGW: 10.30.0.0/16 → data attachment (propagated)
    TGW->>DB: Deliver into data VPC
    DB-->>TGW: Reply to 10.20.21.15
    TGW-->>POD: 10.20.0.0/16 → app attachment
    Note over POD,DB: Routing opens the path · security groups still decide what is allowed
```

| Block (`transit_gateway.tf`) | What it does |
|---|---|
| `aws_ec2_transit_gateway.main` | The hub router. Every attachment auto-associates and auto-propagates its CIDR |
| `aws_ec2_transit_gateway_vpc_attachment.vpc` | `for_each = local.vpcs` plugs every VPC in using one private subnet per AZ |
| `aws_route.private_to_tgw` | `10.0.0.0/8 → TGW` in every private route table |
| `aws_route.public_to_tgw` | The same route in public route tables (edge, app, ops) |

> ➕ **Reusable:** add a VPC to `locals.tf` and it's created, attached to the TGW and routed automatically.

#### 📦 What one `terraform apply` creates

| Resource | Count |
|---|:-:|
| VPCs | 4 |
| Subnets (9 public + 18 private) | 27 |
| Route tables (3 public + 4 private) | 7 |
| Internet Gateways / NAT Gateway / Elastic IP | 3 / 1 / 1 |
| Security groups (public, private, endpoint) | 10 |
| Gateway endpoints | 5 |
| Interface endpoints | 8 |
| Transit Gateway / attachments / TGW routes | 1 / 4 / 7 |

> 💰 **Cost note:** Gateway endpoints are free. Interface endpoints cost about $7.30 per AZ per month each (8 × 3 AZs ≈ $175 per month), the NAT Gateway about $33 per month, and TGW attachments about $36 per month each (≈ $146 per month), all before data charges.

---

### 🔐 IAM: Least-Privilege Roles per Environment

A **child module** (`iam/child-module/`) wraps `terraform-aws-modules/iam/aws//modules/iam-role` **v6.8.2** and defines three roles. Each **environment stack** (`iam/environments/*`) turns on only the roles it needs, using feature flags.

```mermaid
flowchart TB
    CM{{"🧩 iam/child-module<br/>terraform-aws-modules/iam 6.8.2"}}:::mod

    subgraph ROLES["🎭 Roles defined in the child module"]
        direction LR
        R1["👑 FinTech-Platform-Admin<br/>VPC + RDS full · eks:* · KMS manage<br/>⛔ DENY s3:GetObject, dynamodb:GetItem,<br/>rds-db:connect, kms:Decrypt (PII guard)"]:::plat
        R2["👩‍💻 AppTeam-env-Role<br/>qa: eks/rds/ecr full<br/>uat/prod: read-only + rds-db:connect env_user<br/>⛔ DENY delete VPC/Subnet/TGW, terminate EC2"]:::prod
        R3["🤖 FinTech-CI-CD-Deployer-env<br/>GitHub OIDC trust (this repo only)<br/>ECR push · EKS update · Secrets read"]:::cicd
    end

    CM --> R1 & R2 & R3

    subgraph ENVS["🌍 Environment stacks"]
        direction LR
        OPS["🛠️ product-ops-role<br/>enable_platform_role"]:::env
        QA["🧪 product-qa-role<br/>enable_product_role<br/>enable_cicd_role"]:::env
        UAT["🧷 product-uat-role<br/>enable_product_role<br/>enable_cicd_role"]:::env
        PRD["🏦 product-prod-role<br/>enable_product_role<br/>enable_cicd_role"]:::env
    end

    OPS -.-> R1
    QA -.-> R2 & R3
    UAT -.-> R2 & R3
    PRD -.-> R2 & R3

    classDef mod fill:#7B42BC,stroke:#fff,color:#fff,stroke-width:2px
    classDef plat fill:#ff9900,stroke:#fff,color:#000
    classDef prod fill:#4facfe,stroke:#fff,color:#000
    classDef cicd fill:#43e97b,stroke:#fff,color:#000
    classDef env fill:#0f2027,stroke:#00c9a7,color:#fff,stroke-width:2px
    classDef warn fill:#3a1a10,stroke:#ff416c,color:#fff,stroke-width:2px,stroke-dasharray: 5 5
    style ROLES fill:#16222a,stroke:#ffd200,color:#fff,stroke-width:2px
    style ENVS fill:#12263f,stroke:#4facfe,color:#fff,stroke-width:2px
```

#### 🤖 How GitHub Actions gets AWS access (no stored keys)

```mermaid
sequenceDiagram
    autonumber
    participant GH as 🐙 GitHub Actions
    participant OIDC as 🎫 GitHub OIDC
    participant STS as 🔐 AWS STS
    participant ROLE as 🤖 CI-CD-Deployer role
    participant AWS as ☁️ ECR / EKS

    GH->>OIDC: Request ID token for this job
    OIDC-->>GH: JWT (sub = repo:muntaha747/FinTech-Enterprise-Project:*)
    GH->>STS: AssumeRoleWithWebIdentity(JWT)
    STS->>ROLE: Check trust policy condition on sub
    alt ✅ Repo matches
        STS-->>GH: Short-lived credentials
        GH->>AWS: Push image / update cluster
    else ⛔ Any other repo
        STS-->>GH: AccessDenied
    end
```

---

### 🗃️ Multi State Files in One Remote Backend

Every stack keeps its **own state file** inside a single encrypted S3 bucket, **`fintech-project-statefile-bucket`**. Locking uses Terraform's **native S3 lock file** (`use_lockfile = true`), so no DynamoDB table is needed.

<div align="center">

<img src="docs/diagrams/state-backend.svg" width="100%" alt="Animated diagram of eight Terraform stacks each writing its own state file into one encrypted S3 bucket"/>

</div>

**Why split the state?**
- 💥 **Smaller blast radius:** a bad apply on QA IAM can't touch prod networking.
- ⚡ **Faster plans:** each stack only refreshes its own resources.
- 🔒 **Parallel work:** different teams or pipelines lock different files.
- 🧑‍⚖️ **Access control:** bucket policies can restrict who reads which prefix.

```mermaid
flowchart LR
    subgraph STACKS["📂 Terraform root stacks"]
        direction TB
        N["🌐 prod/Networking"]:::net
        I1["🛠️ iam/product-ops-role"]:::iam
        I2["🧪 iam/product-qa-role"]:::iam
        I3["🧷 iam/product-uat-role"]:::iam
        I4["🏦 iam/product-prod-role"]:::iam
        S1["🪣 qa/s3"]:::s3
        S2["🪣 stage/s3"]:::s3
        S3["🪣 prod/s3"]:::s3
    end

    subgraph BUCKET["🔐 s3://fintech-project-statefile-bucket · encrypted · native lock"]
        direction TB
        K1["product-networking/envs/prod/networking.tfstate"]:::kn
        K2["product-iam/envs/iam-ops-role.tfstate"]:::ki
        K3["product-iam/envs/iam-qa-role.tfstate"]:::ki
        K4["product-iam/envs/iam-uat-role.tfstate"]:::ki
        K5["product-iam/envs/iam-prod-role.tfstate"]:::ki
        K6["product-name/envs/qa/s3.tfstate"]:::ks
        K7["product-name/envs/stage/s3.tfstate"]:::ks
        K8["product-name/envs/prod/s3.tfstate"]:::ks
    end

    N --> K1
    I1 --> K2
    I2 --> K3
    I3 --> K4
    I4 --> K5
    S1 --> K6
    S2 --> K7
    S3 --> K8

    classDef net fill:#4facfe,stroke:#fff,color:#000
    classDef iam fill:#ff9900,stroke:#fff,color:#000
    classDef s3 fill:#43e97b,stroke:#fff,color:#000
    classDef kn fill:#12263f,stroke:#4facfe,color:#fff
    classDef ki fill:#3d2400,stroke:#ff9900,color:#fff
    classDef ks fill:#0b3d2e,stroke:#43e97b,color:#fff
    style STACKS fill:#0f2027,stroke:#00c9a7,color:#fff,stroke-width:2px
    style BUCKET fill:#1a1a1a,stroke:#ffd200,color:#fff,stroke-width:3px
```

| Stack | State key |
|---|---|
| 🌐 prod/Networking | `product-networking/envs/prod/networking.tfstate` |
| 🛠️ iam/product-ops-role | `product-iam/envs/iam-ops-role.tfstate` |
| 🧪 iam/product-qa-role | `product-iam/envs/iam-qa-role.tfstate` |
| 🧷 iam/product-uat-role | `product-iam/envs/iam-uat-role.tfstate` |
| 🏦 iam/product-prod-role | `product-iam/envs/iam-prod-role.tfstate` |
| 🪣 qa/s3 | `product-name/envs/qa/s3.tfstate` |
| 🪣 stage/s3 | `product-name/envs/stage/s3.tfstate` |
| 🪣 prod/s3 | `product-name/envs/prod/s3.tfstate` |

#### 🔒 How native S3 locking protects state

```mermaid
sequenceDiagram
    autonumber
    actor A as 👩‍💻 Engineer A
    actor B as 👨‍💻 Engineer B
    participant S3 as 🪣 S3 state bucket

    A->>S3: terraform apply → create networking.tfstate.tflock
    S3-->>A: 🔒 Lock acquired
    B->>S3: terraform apply (same stack)
    S3-->>B: ⛔ Error acquiring the state lock
    A->>S3: Write new networking.tfstate (encrypted)
    A->>S3: Delete .tflock
    S3-->>A: 🔓 Lock released
    B->>S3: Retry → lock acquired ✅
```

---

### 📌 Pinned Versions

| Component | Version | Where |
|---|---|---|
| Terraform | `>= 1.17.1` | every `versions.tf` + CI (`terraform_version: "1.17.1"`) |
| AWS provider | `~> 6.72` (locked at 6.72.0) | every `versions.tf` + `.terraform.lock.hcl` |
| terraform-aws-modules/iam | `6.8.2` | `iam/child-module/main.tf` (all 3 roles) |

### ✅ Fixes Applied During the Build

- 🐞 `availability_zones.all.name` → `.names` (public subnets)
- 🐞 Restored the missing `resource "aws_security_group" "public"` header around dangling `dynamic` blocks
- 🐞 Variable typos: `sting` → `string`, `cidr_block` → `cidr_blocks`, `Environment` default `{}` → `"prod"`
- 🛡️ Private SG no longer hardcodes `0.0.0.0/0` ingress. Rules now come from the root module (VPC CIDR only)
- 🔁 VPC endpoint code rewritten: no hardcoded region, no fragile `slice()`, no `[0]` index crash, descriptions + tags added (clears the KICS findings)
- 📌 Pinned latest Terraform, AWS provider and IAM module versions everywhere
- 🗺️ CIDRs re-planned to `10.10 / 10.20 / 10.30 / 10.40` with edge subnets fixed to sit inside `10.10.0.0/16`
- 🏗️ Subnets now round-robin across 3 AZs, and TGW and endpoints use one subnet per AZ
- 🐞 `outputs.tf`: `aws.subnet` → `aws_subnet`, added CIDR, public subnet and route table outputs
- 🔐 `product-prod-role` now uses real module inputs (`enable_product_role`, `enable_cicd_role`)
- 🪣 `stage/s3` has its own state key, no longer sharing prod's

### 🚀 How to Deploy the Networking Stack

```bash
cd infra-modules/prod/Networking
terraform init -reconfigure          # connect to the S3 backend
terraform plan -out=network.tfplan   # review: 4 VPCs, 27 subnets, 13 endpoints, 1 TGW
terraform apply network.tfplan
```

### 🔜 Next Up

- [x] Transit Gateway connecting edge ↔ app ↔ data ↔ ops
- [x] Separate state key for `stage/s3`
- [x] Fix `product-prod-role` role flags
- [ ] VPC Flow Logs (PCI-DSS / SOC 2)
- [ ] Lock down the default security group (CIS 5.4)
- [ ] EKS subnet tags (`kubernetes.io/role/elb`, `internal-elb`)
- [ ] `default_tags` in the provider + unique route table names
- [ ] TGW segmentation (separate route tables so edge can't reach data directly)
- [ ] EKS + Karpenter in the app VPC

---

## 🗺️ Roadmap

```mermaid
gantt
    title Project Roadmap
    dateFormat  YYYY-MM-DD
    axisFormat  %b %Y
    section Foundation
    Repo, README, state backend, IAM     :done,    f1, 2026-11-01, 8d
    Network: 4 VPCs + Transit Gateway    :done,    f2, 2026-11-07, 5d
    section Edge
    Route 53, CloudFront, WAF, Shield, API Gateway :active, e1, 2026-11-12, 10d
    section Orchestration
    EKS + Karpenter + KEDA               :         o1, after e1, 14d
    Calico + Istio                       :         o2, after o1, 10d
    section Data
    MySQL, Valkey, MongoDB, OpenSearch, Kafka :    d1, after o1, 14d
    section Application
    BFF, Payment, Ledger, Fraud, Notification :    a1, after d1, 28d
    section Delivery
    GitHub Actions + Argo CD + Argo Rollouts  :    g1, after o2, 14d
    section Observability and Security
    Prometheus, Grafana, Loki, Logstash, CloudWatch : s1, after g1, 14d
    Vault + Falco                        :         s2, after s1, 10d
    section MLOps
    Airflow, Kubeflow, MLflow, KServe    :         m1, after a1, 21d
    Evidently AI + WhyLogs               :         m2, after m1, 10d
```

```mermaid
timeline
    title Evolution of the Platform
    Phase 1 - Foundation : State backend and IAM : 4 VPCs and Transit Gateway
    Phase 2 - Edge and Platform : Route 53, CloudFront, WAF, Shield, API Gateway : EKS, Karpenter, KEDA, Calico, Istio
    Phase 3 - Data and Services : MySQL, Valkey, MongoDB, OpenSearch, Kafka : BFF, Payment, Ledger, Fraud, Notification
    Phase 4 - Delivery and Operations : GitHub Actions, Argo CD, Argo Rollouts : Prometheus, Grafana, Loki, Logstash, CloudWatch, Vault, Falco
    Phase 5 - Intelligence : Airflow, Kubeflow, MLflow, KServe : Evidently AI and WhyLogs
```

| Status | Item |
|:--:|---|
| ✅ | Repository, README and animated architecture diagrams |
| ✅ | Terraform remote backend: multi state files in S3 with native locking |
| ✅ | IAM: reusable child module and roles for ops, qa, uat and prod (GitHub OIDC for CI/CD) |
| ✅ | Network: 4 VPCs (edge, app, data, ops), VPC endpoints and Transit Gateway |
| 🚧 | Network hardening: Flow Logs, default SG lockdown, EKS subnet tags, default tags |
| 🔜 | Edge: Route 53, CloudFront, WAF, Shield Advanced, API Gateway |
| 🔜 | Orchestration: EKS, Karpenter, KEDA, Calico, Istio |
| 🔜 | Data: MySQL, Valkey, MongoDB, OpenSearch, Kafka |
| 🔜 | Application: BFF, Payment, Ledger, Fraud and Notification services |
| 🔜 | Delivery: GitHub Actions, Argo CD, Argo Rollouts |
| 🔜 | Identity and observability: Vault, Falco, Prometheus, Grafana, Loki, Logstash, CloudWatch |
| 🔜 | MLOps: Airflow, Kubeflow, MLflow, KServe, Evidently AI, WhyLogs |

---

## 📁 Repository Structure

```text
FinTech-Enterprise-Project/
├── .github/workflows/            # Terraform CI pipelines (GitHub OIDC → AWS)
├── docs/diagrams/                # animated SVG diagrams used in this README
├── infra-modules/
│   ├── iam/
│   │   ├── child-module/         # 3 roles via terraform-aws-modules/iam 6.8.2
│   │   └── environments/
│   │       ├── product-ops-role/ # platform admin role
│   │       ├── product-qa-role/  # app team + CI/CD roles
│   │       ├── product-uat-role/ # app team + CI/CD roles
│   │       └── product-prod-role/
│   ├── prod/
│   │   ├── Networking/           # root: backend, provider, locals (4 VPCs), module call, transit_gateway.tf
│   │   │   └── network/          # child: VPC, subnets, NAT, SGs, VPC endpoints
│   │   └── s3/
│   ├── qa/   (s3, EKS)
│   └── stage/ (s3)
├── .gitignore
└── README.md
```

---

<div align="center">

### 👩‍💻 Built by a DevOps engineer, for DevOps engineers

⭐ Star this repo to follow along as it grows.

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:00c9a7,50:2c5364,100:0f2027&height=140&section=footer" alt="footer"/>

</div>
