# Highly Available 2-Tier Web Architecture on AWS using Terraform

## Project Overview

This project demonstrates how to deploy a **Highly Available 2-Tier Web Architecture on AWS using Terraform (Infrastructure as Code)**. The infrastructure automatically provisions networking, compute, storage, and load balancing resources in AWS.

The architecture uses **two EC2 web servers placed in different Availability Zones** behind an **Application Load Balancer (ALB)** to ensure high availability and fault tolerance.

All infrastructure components are created using **Terraform configuration files**, making the deployment automated, repeatable, and scalable.

---

## Architecture

Internet
↓
Application Load Balancer
↓
EC2 Instance 1 (Subnet 1) | EC2 Instance 2 (Subnet 2)

Resources are deployed inside a custom **Virtual Private Cloud (VPC)**.

---

## AWS Resources Created

* Virtual Private Cloud (VPC)
* 2 Public Subnets
* Internet Gateway
* Route Table
* Security Group
* 2 EC2 Instances (Web Servers)
* Application Load Balancer
* Target Group and Listener
* S3 Bucket

---

## Technologies Used

* Terraform
* AWS EC2
* AWS VPC
* AWS Application Load Balancer
* AWS S3
* Linux (Ubuntu)
* Apache Web Server

---

## Project Structure

```
terraform-2tier-project
│
├── main.tf
├── variables.tf
└── outputs.tf
```

---

## Prerequisites

Before running this project, make sure you have:

* AWS Account
* Terraform Installed
* AWS CLI Installed
* Configured AWS Credentials

Configure AWS credentials:

```
aws configure
```

---

## How to Deploy the Project

Initialize Terraform:

```
terraform init
```

Check execution plan:

```
terraform plan
```

Deploy infrastructure:

```
terraform apply
```

Type **yes** when prompted.

---

## Output

After deployment, Terraform will generate a **Load Balancer DNS URL**.

Example:

```
myalb-123456.us-east-1.elb.amazonaws.com
```

Open this URL in a browser to access the **load-balanced web application**.

---

## Features

* Infrastructure as Code using Terraform
* Highly Available architecture across multiple Availability Zones
* Load balancing using AWS Application Load Balancer
* Automated web server installation using EC2 user data
* Secure networking using VPC and Security Groups

---

## Future Improvements

* Add Auto Scaling Group
* Add RDS Database for 3-Tier Architecture
* Implement HTTPS using SSL/TLS
* Store Terraform state in S3 backend
* Add monitoring using CloudWatch

---

## Author

Hari
