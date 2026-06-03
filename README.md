# Terraform OIDC Demo

## Overview

This project demonstrates how to deploy AWS infrastructure using Terraform from GitHub Actions without storing AWS access keys.

Authentication is implemented using OpenID Connect (OIDC), where GitHub Actions assumes an AWS IAM Role and receives temporary credentials through AWS STS.

---

## Architecture

GitHub Repository

↓

GitHub Actions Workflow

↓

GitHub OIDC Token

↓

AWS IAM Role

↓

Temporary STS Credentials

↓

Terraform Apply

↓

AWS EC2 Instance

---

## Technologies Used

* Terraform
* AWS EC2
* AWS IAM
* AWS STS
* GitHub Actions
* OpenID Connect (OIDC)

---

## Project Structure

```text
terraform-oidc-demo/
│
├── main.tf
├── provider.tf
└── .github/
    └── workflows/
        └── terraform.yml
```

---

## What This Project Does

* Creates an AWS EC2 instance using Terraform.
* Uses GitHub Actions as the CI/CD pipeline.
* Authenticates to AWS using OIDC.
* Assumes an IAM Role instead of using AWS Access Keys.
* Deploys infrastructure automatically when code is pushed to the main branch.

---

## Key Learning Outcomes

* Configuring AWS OIDC Identity Provider
* Creating IAM Roles for GitHub Actions
* Understanding AssumeRoleWithWebIdentity
* Using temporary AWS credentials
* Automating Terraform deployments with GitHub Actions

---

## Workflow

1. Developer pushes code to GitHub.
2. GitHub Actions workflow starts.
3. GitHub generates an OIDC token.
4. AWS validates the token.
5. IAM Role is assumed.
6. Temporary credentials are issued.
7. Terraform deploys infrastructure to AWS.

---

## Security Benefit

This project eliminates the need to store:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Authentication is handled using short-lived credentials issued dynamically by AWS STS.

---

Important Note

⚠️ This repository is designed to demonstrate GitHub Actions OIDC authentication with AWS and Terraform deployment. It is intentionally focused on OIDC and does not implement a remote Terraform backend.

Expected Behavior

This project uses the default local Terraform state.

When the GitHub Actions workflow runs, GitHub provisions a temporary runner and executes Terraform commands. The Terraform state file exists only for the duration of that workflow execution.

Workflow Run #1
    ↓
terraform.tfstate created
    ↓
EC2 Instance created
    ↓
Runner destroyed

Workflow Run #2
    ↓
New runner starts
    ↓
No previous state available

Because the previous state file is not available, Terraform has no knowledge of infrastructure created during earlier workflow runs.

As a result, modifying the Terraform configuration (for example, changing EC2 tags) and pushing the changes may result in the creation of a new EC2 instance instead of updating the existing one.

Why This Happens

GitHub Actions runners are ephemeral (temporary). The local Terraform state is not persisted between workflow executions.

Terraform relies on the state file to understand:

Existing infrastructure
Resource mappings
Changes that require updates
Changes that require recreation

Without the previous state file, Terraform treats the deployment as a new infrastructure deployment.

Production Approach

In real-world environments, Terraform state should be stored in a remote backend such as Amazon S3.

Terraform
    ↓
S3 Backend
    ↓
Persistent State

Using a remote backend allows multiple workflow executions to share the same Terraform state, enabling Terraform to correctly detect and update existing resources instead of creating duplicates.

Related Topic

Remote state management using:

Amazon S3 Backend
DynamoDB State Locking

is intentionally excluded from this repository because it is covered as a separate Terraform project focused on Terraform State Management concepts.
