# Terraform AWS Infrastructure with CI/CD

This project provisions AWS infrastructure using Terraform with a modular approach, managed through a GitHub Actions CI/CD pipeline supporting two environments: **test** and **prod**.

---

## Provisioned Resources

| Module | Resources |
|--------|-----------|
| `module/vpc` | VPC, Public Subnet, Internet Gateway, Route Table |
| `module/sg` | Security Group (SSH + HTTP inbound, all outbound) |
| `module/ec2` | EC2 Instance (Ubuntu 22.04, t3.micro) |
| `module/s3` | S3 Bucket |
| `module/iam` | IAM User, IAM Group, IAM User-Group Membership |

All resources are environment-prefixed (e.g. `test-vpc`, `prod-vpc`) to keep environments isolated.

---

## Project Structure

```
├── main.tf                  # Root module, calls all child modules
├── variable.tf              # Root variable declarations
├── output.tf                # Root outputs
├── backend.tf               # S3 remote state configuration
├── envs/
│   ├── prod.tfvars          # Prod environment variable values
│   └── test.tfvars          # Test environment variable values
├── module/
│   ├── vpc/                 # VPC module
│   ├── sg/                  # Security Group module
│   ├── ec2/                 # EC2 module
│   ├── s3/                  # S3 module
│   └── iam/                 # IAM module
└── .github/
    └── workflows/
        └── terraform.yml    # GitHub Actions CI/CD pipeline
```

---

## Environments

| Environment | Branch | State File | Auto Apply |
|-------------|--------|------------|------------|
| test | `test` | `test/terraform.tfstate` | Yes |
| prod | `main` | `prod/terraform.tfstate` | No (manual approval) |

State files are stored remotely in S3 bucket `terraform-statefile-with-module-bkt` with encryption and state locking enabled.

---

## CI/CD Pipeline

The pipeline is triggered automatically on every push to `test` or `main` branch.

### Pipeline Stages

```
Stage 1: Security Scan
Stage 2: Lint & Validate
Stage 3: Terraform Plan
Stage 4: Manual Approval  ← prod only
Stage 5: Terraform Apply
```

### Stage Details

**Stage 1 - Security Scan**
Runs `tfsec` to scan all Terraform files for security misconfigurations before anything else executes. Configured with `soft_fail` so warnings don't block the pipeline.

**Stage 2 - Lint & Validate**
Runs `terraform fmt -check` to enforce consistent formatting and `terraform validate` to catch any configuration errors early.

**Stage 3 - Terraform Plan**
Initializes Terraform with the environment-specific state key, runs `terraform plan` using the correct `.tfvars` file, and uploads the plan as a pipeline artifact for the apply stage to consume.

**Stage 4 - Manual Approval (prod only)**
When pushing to `main`, the pipeline pauses here and waits for a human to click "Review deployments" in the GitHub Actions UI. This uses a GitHub Environment (`production`) with required reviewers configured. The apply stage cannot run until approval is granted.

**Stage 5 - Terraform Apply**
Downloads the saved plan artifact from Stage 3 and runs `terraform apply`. For `test` this runs automatically. For `prod` it only runs after approval in Stage 4.

### Flow Diagram

```
Push to test:
  Security Scan → Lint & Validate → Plan → Apply (auto)

Push to main:
  Security Scan → Lint & Validate → Plan → [Manual Approval] → Apply
```

---

## GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS credentials for Terraform to authenticate |
| `AWS_SECRET_ACCESS_KEY` | AWS credentials for Terraform to authenticate |

---

## GitHub Environment Setup

A GitHub Environment named `production` must be configured with required reviewers to enable the manual approval gate on prod deployments.

Go to: repo Settings → Environments → `production` → add required reviewers.

---

## Remote State

State is stored in S3 with per-environment isolation:

```
s3://terraform-statefile-with-module-bkt/
├── prod/terraform.tfstate
└── test/terraform.tfstate
```

The `key` is injected dynamically by the pipeline via `-backend-config="key=<env>/terraform.tfstate"` so both environments use the same `backend.tf` without conflict.
