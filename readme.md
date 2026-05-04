# Currency Insight Tracker V2
> **Enterprise-Grade Containerized Architecture with AWS ECS Fargate, Terraform & Full CI/CD Automation**

This repository represents the advanced evolution of the Currency Insight Tracker. Moving beyond the limitations of simple serverless functions, V2 implements a **Production-Ready Cloud Architecture** focused on scalability, security, and automated delivery.

---

## Why V2? (Engineering Transformation)
The shift from V1 (Serverless) to V2 (Containerized) was a strategic move to master modern DevOps practices:
- **Zero Cold Starts**: Migrated to **ECS Fargate** for consistent, high-performance API responses.
- **Modern Infrastructure**: Implemented a **Custom VPC** with Public/Private subnets for strict network isolation.
- **Infrastructure as Code (IaC)**: 100% of the AWS resources are managed via **Terraform**, ensuring reproducibility and version control.
- **Full-Stack Automation**: Integrated **GitHub Actions** for seamless CI/CD, from code push to CloudFront invalidation.

---

## Tech Stack
### **Infrastructure & DevOps**
- **Cloud**: AWS (VPC, ECS Fargate, ALB, ECR, S3, DynamoDB, CloudFront)
- **IaC**: Terraform (Modular Architecture)
- **CI/CD**: GitHub Actions
- **Containerization**: Docker (Multi-stage builds)

### **Application Layer**
- **Backend**: Python (FastAPI) - *Asynchronous API for high concurrency*
- **Frontend**: React (Vite) - *Optimized static assets served via CloudFront*

---

## System Architecture
The architecture is designed for high availability and security:
1. **Frontend**: React app hosted on **S3**, distributed via **CloudFront** (CDN).
2. **Traffic Control**: **Application Load Balancer (ALB)** routes `/api/*` traffic to the backend.
3. **Compute**: **ECS Fargate** runs containerized FastAPI tasks in Private Subnets.
4. **Data**: **DynamoDB** provides a serverless, scalable NoSQL data store.



---

## CI/CD Pipeline Flow
The project utilizes two distinct pipelines for specialized deployment:

### **Backend (Container Deployment)**
1. Trigger: `git push` to `back/**`
2. Build: Create Docker image with optimized multi-stage build.
3. Registry: Push image to **Amazon ECR**.
4. Deploy: **Force new deployment** on ECS Service to pull the latest image.

### **Frontend (Static Deployment)**
1. Trigger: `git push` to `front/**`
2. Build: `npm run build` with environment variables.
3. Sync: Upload assets to **S3** and delete old files.
4. Invalidation: Clear **CloudFront** cache for immediate global updates.

---

## 🗺 Implementation Status
- [x] **Phase 1**: Application Modernization (FastAPI & Docker)
- [x] **Phase 2**: Infrastructure as Code (Terraform VPC, ECS, ALB)
- [x] **Phase 3**: Automated CI/CD (GitHub Actions)