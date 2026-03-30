# 📸 PhotoShare – Production-Grade AWS Architecture

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Architecture](https://img.shields.io/badge/Architecture-Event--Driven-purple)

---

## Overview

PhotoShare is a **secure, scalable, event-driven cloud application** built on AWS using production-grade best practices.

The project demonstrates a fully private backend architecture where no compute resource is directly exposed to the internet. All traffic enters through a hardened Application Load Balancer, images are stored and processed without leaving the AWS network, and secrets are never hardcoded.

**What this project covers:**

- Zero public exposure of compute resources (EC2, RDS, Lambda all in private subnets)
- End-to-end encryption via HTTPS using ACM
- Event-driven image processing using S3 + Lambda
- Containerised backend running on EC2 (Docker)
- Secure secret management via AWS Secrets Manager + KMS
- Infrastructure-as-Code automation with Terraform (in progress)

---

## Architecture

![Architecture](docs/architecture.png)

---

## How It Works

1. User connects securely via **HTTPS → Application Load Balancer** (the only public entry point)
2. ALB routes traffic to **EC2 in a private subnet** (Docker container)
3. User uploads an image:
   - Image is stored in a **private S3 bucket**
   - Upload event triggers a **Lambda function** (VPC-enabled)
4. Lambda extracts image metadata and writes it **directly to RDS MySQL**
5. EC2 accesses S3 via the **S3 VPC Endpoint** (traffic never leaves the AWS backbone)
6. All activity is monitored via **CloudWatch**

---

## AWS Services Used

| Category | Service | Purpose |
|---|---|---|
| Networking | VPC, Subnets, NAT Gateway | Isolated network with public/private tiers |
| Ingress | Application Load Balancer | HTTPS termination, only public entry point |
| Certificates | ACM | SSL/TLS certificate management |
| Compute | EC2 (Dockerised) | Backend application in private subnet |
| Serverless | Lambda (VPC-enabled) | Event-driven image metadata processing |
| Storage | S3 | Private image storage with VPC endpoint |
| Database | RDS MySQL | Metadata persistence in private subnet |
| Security | IAM, Secrets Manager, KMS | Least-privilege access and encryption |
| Monitoring | CloudWatch | Dashboards and alerting |

---

## Security Design

| Control | Implementation |
|---|---|
| No public compute | EC2, RDS, and Lambda all deployed in private subnets |
| HTTPS enforced | ACM certificate + ALB listener (HTTP 80 → 443 redirect) |
| S3 Block Public Access | Enabled — bucket is not internet accessible |
| No hardcoded credentials | IAM roles used for all service-to-service access |
| Secret management | Database credentials stored in AWS Secrets Manager |
| Encryption at rest | AWS KMS used for S3, RDS, and Secrets Manager |
| Least-privilege IAM | Separate roles for EC2 (`iam_role_ec2`) and Lambda (`iam_role_lambda`) |
| Network isolation | Security groups enforce strict ingress/egress per service |
| Private S3 access | S3 VPC Gateway Endpoint — no NAT or internet required for S3 traffic |
| Observability | VPC Flow Logs + CloudWatch for audit trail and alerting |

---

## Networking Design

```
Internet
    │ HTTPS
    ▼
┌─────────────────────────────┐
│  PUBLIC SUBNET              │
│  Application Load Balancer  │
└────────────┬────────────────┘
             │ route traffic
┌────────────▼────────────────────────────┐
│  PRIVATE SUBNET                         │
│                                         │
│  EC2 (Docker)    Lambda (Image Proc.)   │
│       │                │                │
│       └────────┬───────┘                │
│                ▼                        │
│           RDS MySQL                     │
│                                         │
│  ┌──────────────────────────┐           │
│  │  S3 VPC Gateway Endpoint │           │
│  └──────────────────────────┘           │
└─────────────────────────────────────────┘
             │
    NAT Gateway (outbound only)
```

- **Public Subnets:** ALB only
- **Private Subnets:** EC2, RDS, Lambda
- **Outbound internet** (for EC2/Lambda system updates): NAT Gateway
- **S3 access:** Gateway VPC Endpoint — bypasses NAT entirely

---

## Terraform Structure (In Progress)

```
terraform/
├── versions.tf          # Provider pinning + S3 remote state
├── main.tf              # Root module
├── variables.tf         # Input variables
├── outputs.tf           # ALB DNS, RDS endpoint, S3 bucket name
├── terraform.tfvars     # ⚠️ gitignored — never committed
│
└── modules/
    ├── vpc/             # VPC, subnets, NAT Gateway, route tables, flow logs
    ├── alb/             # ALB, listeners, ACM certificate, HTTP→HTTPS redirect
    ├── ec2/             # Instance, security group, IAM role, user_data (Docker)
    ├── rds/             # RDS MySQL, subnet group, parameter group, security group
    ├── lambda/          # Function, IAM role, S3 event trigger, VPC config
    ├── s3/              # Bucket, block public access, VPC endpoint, lifecycle rules
    └── security/        # KMS key, Secrets Manager, IAM policies
```

### Remote State Configuration

```hcl
# versions.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "photoshare-tf-state"
    key            = "photoshare/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "tf-state-lock"
  }
}
```

### Resource Tagging Strategy

```hcl
locals {
  common_tags = {
    Project     = "PhotoShare"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
```

### Planned Automation

- [x] Architecture design
- [ ] VPC + Subnets + NAT Gateway + Flow Logs
- [ ] ALB + ACM (HTTPS) + HTTP redirect
- [ ] EC2 (private) + Docker user_data
- [ ] RDS MySQL (private, encrypted)
- [ ] Lambda (VPC-enabled) + S3 trigger
- [ ] S3 + VPC Gateway Endpoint + Lifecycle rules
- [ ] Secrets Manager + KMS
- [ ] CloudWatch Dashboards + Alarms
- [ ] Remote state (S3 + DynamoDB lock)

---

## Monitoring

**CloudWatch Dashboard:**
- EC2 CPU Utilisation
- Lambda Invocation count and duration

**Alarms:**
- `LambdaErrorAlarm` — triggers when Lambda errors > 0

---

## Estimated Monthly Cost (eu-central-1, light usage)

| Service | Specification | Est. Cost/mo |
|---|---|---|
| EC2 | t3.micro, private | ~$8.50 |
| RDS | db.t3.micro, MySQL | ~$15.00 |
| ALB | Application Load Balancer | ~$16.00 |
| NAT Gateway | 1 AZ | ~$32.00 |
| Lambda | Light usage (free tier) | ~$0.00 |
| S3 | Standard storage | ~$1.00 |
| Secrets Manager | 2 secrets | ~$0.80 |
| **Total** | | **~$73/mo** |

> Cost can be reduced significantly by using a single NAT Gateway (already assumed above) and right-sizing EC2/RDS for dev/test workloads.

---

## Deployment (Terraform)

```bash
git clone https://github.com/UltimateResearchProject/PhotoShareAWSProject
cd PhotoShareAWSProject/terraform/

# Initialise providers and remote state
terraform init

# Review planned changes
terraform plan -var-file="terraform.tfvars"

# Apply infrastructure
terraform apply -var-file="terraform.tfvars"
```

> **Prerequisites:** AWS CLI configured, Terraform >= 1.5.0, an S3 bucket and DynamoDB table for remote state.

---

## Testing the Application

1. Open the ALB HTTPS URL (output from `terraform output alb_dns_name`)
2. Upload an image via the UI
3. Verify:
   - Image appears in the private S3 bucket
   - Lambda was triggered (CloudWatch Logs)
   - Metadata row written to RDS MySQL

---

## Project Structure

```
PhotoShareAWSProject/
├── terraform/           # IaC — Terraform modules (in progress)
├── app/                 # Dockerised backend application
├── lambda/              # Lambda function source code
├── docs/
│   └── architecture.png
├── .gitignore
└── README.md
```

---

## Future Improvements

- [ ] Auto Scaling Group (replace single EC2 instance)
- [ ] CloudFront CDN for image delivery
- [ ] WAF (Web Application Firewall) on ALB
- [ ] CI/CD pipeline (GitHub Actions → Terraform apply)
- [ ] Multi-AZ RDS (read replica)
- [ ] S3 Intelligent-Tiering for cost optimisation
- [ ] Rekognition integration for AI-powered image tagging

---

## .gitignore (Recommended)

```
# Terraform
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
terraform.tfvars
*.tfplan

# Secrets
.env
*.pem
*.key

# OS
.DS_Store
Thumbs.db
```

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Author

**Santosh Nagaraj**

[![GitHub](https://img.shields.io/badge/GitHub-UltimateResearchProject-181717?logo=github)](https://github.com/UltimateResearchProject)

---

> ⭐ If you found this useful, consider starring the repo!