# Currency Insight Tracker V2
> **Production-Grade Containerized Architecture with AWS ECS, Terraform & GitHub Actions**

This repository represents the second iteration (V2) of the Currency Insight Tracker. While V1 focused on a Serverless (Lambda) approach, V2 is engineered for **Enterprise-level scalability, fine-grained network control, and container orchestration** using a modern DevOps stack.

---

## 🏗 Why V2? (The Engineering Shift)
The transition from Serverless to a Containerized architecture was driven by several key factors:
- **Consistent Performance**: Eliminating "Cold Starts" inherent in AWS Lambda for predictable low-latency response.
- **Environment Parity**: Leveraging **Docker** to ensure the exact same environment from local development to production.
- **Granular Networking**: Moving from a public serverless environment to a custom **VPC** with Private Subnets for enhanced security.
- **Orchestration**: Managing long-running services and auto-scaling policies via **Amazon ECS (Fargate)**.

---

## 🛠 Planned Tech Stack
- **Backend**: Node.js (Express) or Python (FastAPI) - *Decoupled from the frontend.*
- **Infrastructure**: AWS (VPC, ECS Fargate, ALB, ECR, DynamoDB)
- **IaC**: Terraform (Modular design)
- **CI/CD**: GitHub Actions (Docker Build & Push to ECR, ECS Service Update)

---

## 🗺 Implementation Roadmap (TODOs)

### Phase 1: Application Modernization
- [ ] **Decouple Backend**: Refactor Lambda logic into a standalone Express/FastAPI server.
- [ ] **Containerization**: Write a multi-stage `Dockerfile` to optimize image size.
- [ ] **Local Testing**: Verify the containerized app using `docker-compose`.

### Phase 2: Infrastructure as Code (Terraform)
- [ ] **Networking (VPC)**: Design a VPC with Public/Private subnets, IGW, and NAT Gateway.
- [ ] **Load Balancing**: Configure an **Application Load Balancer (ALB)** to handle incoming traffic.
- [ ] **Container Registry**: Set up **Amazon ECR** for automated image storage.
- [ ] **Orchestration**: Define **ECS Cluster**, **Task Definitions**, and **Fargate Services**.

### Phase 3: Automated CI/CD Pipeline
- [ ] **Docker Pipeline**: Automate `docker build` and `docker push` to ECR on `git push`.
- [ ] **Deployment Automation**: Implement "Rolling Update" deployment to ECS.
- [ ] **Security Scanning**: (Bonus) Integrate Trivy or AWS Inspector for container vulnerability scanning.

### Phase 4: Observability & Security
- [ ] **Logging**: Centralize logs using **CloudWatch Logs**.
- [ ] **Monitoring**: Set up CloudWatch Alarms for CPU/Memory utilization.
- [ ] **Least Privilege**: Refine IAM roles for ECS Task Execution.

---