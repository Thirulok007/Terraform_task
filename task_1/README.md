# Terraform Multi-Region EC2 Deployment

## Project Overview

This project demonstrates how to launch Linux EC2 instances in two different AWS regions using a single Terraform configuration file.

## Technologies Used

* AWS EC2
* Terraform
* AWS CLI
* Git & GitHub

## Prerequisites

Before starting, ensure the following tools are installed and configured:

* AWS Account
* AWS CLI
* Terraform
* Git

## Configuration Steps

### Step 1: Configure AWS CLI

```bash
aws configure
```

Provide:

* AWS Access Key ID
* AWS Secret Access Key
* Default Region: ap-south-1
* Output Format: json

Verify configuration:

```bash
aws sts get-caller-identity
```

### Step 2: Create Project Directory

```bash
mkdir terraform-multi-region-ec2
cd terraform-multi-region-ec2
```

### Step 3: Create Terraform Configuration

Create a file named `main.tf`.

The configuration uses:

* Mumbai Region (ap-south-1)
* Virginia Region (us-east-1)

Two Linux EC2 instances are created using separate provider aliases within a single Terraform file.

### Step 4: Initialize Terraform

```bash
terraform init
```

### Step 5: Review Execution Plan

```bash
terraform plan
```

Expected output:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

### Step 6: Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

Expected output:

```text
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

## Resources Created

### Mumbai Region

* Region: ap-south-1
* Instance Type: t3.micro
* Instance Name: Mumbai-EC2

### Virginia Region

* Region: us-east-1
* Instance Type: t3.micro
* Instance Name: Virginia-EC2

## Verification

Verify the instances from the AWS Management Console:

### Mumbai Region

EC2 → Instances → Mumbai-EC2

### Virginia Region

EC2 → Instances → Virginia-EC2

Both instances should be in the Running state.

## Outcome

Successfully launched Linux EC2 instances in two different AWS regions using a single Terraform configuration file.
