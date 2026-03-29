# 📸 PhotoShare – Production-Grade AWS Architecture (Terraform Ready)

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Terraform](https://img.shields.io/badge/IaC-Terraform-blue)
![Docker](https://img.shields.io/badge/Container-Docker-blue)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## 🚀 Overview

PhotoShare is a **secure, scalable, event-driven cloud application** built on AWS using production-grade best practices.

This architecture demonstrates:

* 🔐 Zero public exposure of compute resources
* 🔒 End-to-end encryption using HTTPS (ACM)
* ⚡ Event-driven processing using Lambda
* 📦 Containerized backend on EC2 (private)
* 🏗️ Infrastructure-as-Code ready (Terraform)

---

## 🧠 Architecture

![Architecture](docs/architecture.png)

---

## 🔄 How It Works

1. User connects securely via **HTTPS (ACM) → Application Load Balancer**
2. ALB routes traffic to **EC2 (private subnet)**
3. User uploads image:

   * Stored in **S3 (private bucket)**
   * Triggers **Lambda (inside VPC)**
4. Lambda extracts metadata and sends it via ALB
5. Backend stores metadata in **RDS (private subnet)**

---

## 🏗️ AWS Services Used

* VPC (Public + Private Subnets across AZs)
* Application Load Balancer (HTTPS + ACM)
* EC2 (Private Subnet – Dockerized App)
* S3 (Private Storage)
* Lambda (VPC-enabled Processing)
* RDS MySQL (Private Database)
* IAM (Least Privilege Access)
* Secrets Manager (Secure Credentials)
* KMS (Encryption)
* CloudWatch (Monitoring & Alerts)
* ACM (SSL/TLS Certificate Management)

---

## 🔐 Security Highlights (Production-Grade)

* ✅ EC2 deployed in **private subnet (no public IP)**
* ✅ HTTPS enforced using **ACM + ALB**
* ✅ S3 Block Public Access enabled
* ✅ RDS isolated in private subnet
* ✅ Lambda runs inside VPC
* ✅ No hardcoded credentials (IAM roles)
* ✅ Secrets stored in AWS Secrets Manager
* ✅ Encryption via AWS KMS
* ✅ Security groups enforce least privilege
* ✅ ALB is the **only public entry point**

---

## ⚙️ Key Features

* Event-driven architecture using S3 + Lambda
* Fully private backend (no direct internet exposure)
* Secure secret management
* Dockerized application deployment
* Production-ready monitoring and alerting
* Designed for Terraform automation

---

## 🌐 Networking Design

* Public Subnets:

  * ALB (Internet-facing)
* Private Subnets:

  * EC2 (Application)
  * RDS (Database)
  * Lambda (VPC-enabled)

👉 Outbound internet access handled via **NAT Gateway** (required for Lambda/EC2)

---

## 🧪 Testing the Application

1. Open the ALB HTTPS URL
2. Upload an image
3. Verify:

   * Image stored in S3
   * Lambda triggered
   * Metadata processed successfully

---

## 📊 Monitoring

CloudWatch Dashboard includes:

* EC2 CPU Utilization
* Lambda Invocations

Alarm:

* Triggered when **Lambda Errors > 0**

---

## 🏗️ Terraform (Coming Next)

This project is designed to be fully automated using Terraform.

### Planned Automation:

* VPC + Subnets + NAT Gateway
* ALB + ACM (HTTPS)
* EC2 (Private)
* RDS (Private)
* Lambda (VPC-enabled)
* S3 + Event Triggers
* Secrets Manager
* CloudWatch Dashboards & Alarms

---

## 📁 Project Structure

```
photoshare-aws-terraform/
│
├── terraform/
├── app/
├── lambda/
├── docs/
├── README.md
```

---

## 🧠 Learning Outcomes

* Designing secure VPC architectures
* Implementing private compute patterns
* Using ACM for HTTPS in ALB
* Running Lambda inside VPC
* Managing secrets securely
* Building event-driven systems
* Observability with CloudWatch

---

## 🔥 Future Improvements

* Auto Scaling Group (replace single EC2)
* CloudFront CDN integration
* WAF (Web Application Firewall)
* CI/CD pipeline (GitHub Actions)
* Terraform modules (fully production-ready)

---

## 👨‍💻 Author

**Santosh Nagaraj**
M.Sc. Computer Science (Cybersecurity) – SRH Berlin

---

## ⭐ If you found this useful, consider starring the repo!
