# eks-production-infra

## Overview

This repository contains a comprehensive DevOps project designed to automate the deployment of a production-grade Kubernetes (EKS) cluster on AWS using Infrastructure as Code (IaC) best practices.

As a lead DevOps engineer, this project serves as a real-world showcase of how to structure reusable infrastructure modules, manage multi-environment deployments, and integrate CI/CD automation using GitHub Actions.

---

## Project Goals

- Provision a fully functional, secure, and scalable EKS cluster in AWS.
- Automate infrastructure deployment using Terraform and Terragrunt.
- Enable GitHub Actions for continuous integration and deployment (CI/CD).
- Apply infrastructure best practices like modularization, DRY principles, and environment separation.

---

## Repository Structure

```text
.
├── .github/workflows   # CI/CD pipelines via GitHub Actions
├── infra-live          # Live environments using Terragrunt
├── infra-live2/dev     # Alternate setup using plain Terraform
├── modules             # Reusable Terraform modules
└── .gitignore          # Ignored files configuration

```

---

## 🧱 Terraform Modules

### `vpc/`
- Provisions a VPC tailored for EKS.
- Includes public/private subnets and necessary AWS tags.
- Production-ready with best practices in subnetting and availability zones.

### `eks/`
- Deploys an EKS cluster with:
  - 1 Managed Node Group
  - 1 Fargate Profile
- Supports integration with EKS Blueprints for add-ons.

### `database/` *(In Progress)*
- Will provision a managed database (e.g., RDS or Aurora).
- Designed to fit into the existing network topology.

---

## ⚙️ Deployment Methods

### **1. `infra-live/` (Terragrunt-based)**
- DRY-compliant, scalable layout for multiple environments (dev, staging, prod).
- Centralized state and configuration management.
- Recommended for teams or larger environments.

> **Why Terragrunt?**  
> Terragrunt simplifies environment and state management, reduces duplication, and enforces best practices.

### **2. `infra-live2/` (Plain Terraform)**
- Direct use of Terraform modules.
- Easier for simpler environments or one-off deployments.
- Good for demos or beginners.

---

## 🔁 CI/CD with GitHub Actions

GitHub Actions automate the deployment pipeline:

- Plans and applies Terraform code.
- Validates formatting and security policies.
- Manages pull request workflows and approvals.

Workflow YAMLs are stored in `.github/workflows/`.

### 🔐 Secure Authentication with OIDC

This project uses **GitHub Actions with OIDC (OpenID Connect)** to authenticate with AWS — instead of hardcoding or storing long-lived AWS credentials.

#### Why OIDC?

- **No stored secrets**: Credentials are not checked into the repo or stored in GitHub.
- **Short-lived, scoped access**: AWS issues temporary credentials valid only for the duration of the job.
- **Improved security posture**: Reduces the risk of credential leakage and meets compliance best practices.
- **Native AWS support**: AWS now supports direct GitHub OIDC integration via IAM roles and identity providers.

> This approach follows the principle of **least privilege** and aligns with [AWS’s recommended best practices for CI/CD](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html).


---

## 🧩 EKS Add-ons via AWS Blueprints

Post-EKS deployment, we use [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints) to install critical production add-ons:

- ✅ AWS Load Balancer Controller  
- ✅ Metrics Server  
- ✅ Karpenter (auto-scaling)  
- ✅ CoreDNS, kube-proxy, and more

This ensures the cluster is fully production-ready from the start.

---

## 🏆 Why This Project?

- Modular and reusable Terraform codebase
- DRY multi-environment setup using Terragrunt
- End-to-end GitOps workflow with GitHub Actions
- GitHub Actions use **OIDC-based AWS authentication** — eliminating static credentials, improving security, and aligning with AWS IAM best practices
- Real-world production considerations baked in
- Easily extendable to other AWS components (e.g., RDS, S3, IAM)

---

## 🛠 Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/your-username/infrastructure-modules.git

# 2. Set up AWS credentials
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key

# 3. Navigate to a live environment
cd infra-live/dev

# 4. Deploy with Terragrunt
terragrunt init
terragrunt apply
