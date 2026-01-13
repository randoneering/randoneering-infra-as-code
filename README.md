# randoneering-iac

Infrastructure as Code repository providing Terraform modules and deployment templates for cloud infrastructure across AWS, Azure, and GCP.

## Overview

This repository contains reusable Terraform modules and ready-to-use deployment templates for common infrastructure patterns. The modules focus on database infrastructure, AWS services, and supporting resources.

## Repository Structure

```
randoneering-iac/
├── terraform-modules/     # Reusable Terraform modules
│   ├── aws_backup/       # AWS Backup configuration
│   ├── db/               # Database modules
│   │   ├── db_init/      # Database initialization
│   │   ├── documentdb/   # AWS DocumentDB
│   │   ├── rds/          # RDS (Aurora and non-Aurora)
│   │   ├── security_group/
│   │   └── subnet_group/
│   ├── iam/              # IAM roles and policies
│   ├── kms/              # KMS key management
│   ├── route53/          # DNS configuration
│   └── s3/               # S3 bucket configuration
└── deploy-templates/     # Deployment templates
    ├── aws/              # AWS deployment examples
    ├── azure/            # Azure deployment examples
    └── gcp/              # GCP deployment examples
```

## Terraform Modules

### Database Modules

#### RDS Aurora
Located in `terraform-modules/db/rds/aurora/`

Provisions AWS RDS Aurora clusters (PostgreSQL or MySQL). Supports:
- Aurora PostgreSQL (default: 15.12)
- Aurora MySQL (default: 8.0)
- Automated backups with environment-specific retention
- CloudWatch logs integration
- Multi-AZ deployment
- Backtrack for MySQL clusters

#### RDS Non-Aurora
Located in `terraform-modules/db/rds/nonaurora/`

Provisions standard RDS instances for PostgreSQL or MySQL.

#### DocumentDB
Located in `terraform-modules/db/documentdb/`

Provisions AWS DocumentDB clusters for MongoDB-compatible workloads.

#### Database Supporting Modules
- **security_group**: Database security group configuration
- **subnet_group**: Database subnet group setup
- **db_init**: Database initialization scripts (PostgreSQL)

### AWS Service Modules

- **aws_backup**: Automated backup plans and vault configuration
- **iam**: IAM roles, policies, and permission management
- **kms**: KMS key creation and policy management
- **route53**: DNS zone and record management
- **s3**: S3 bucket creation with versioning and lifecycle policies

## Deployment Templates

Pre-configured deployment examples are in `deploy-templates/` for:

### AWS
- **RDS Aurora**: PostgreSQL and MySQL Aurora deployments
- **RDS Non-Aurora**: Standard PostgreSQL and MySQL instances
- **DocumentDB**: MongoDB-compatible cluster deployments

### Azure & GCP
Templates for Azure and GCP are available in their respective directories.

## Usage

### Using Modules

Reference modules from this repository in your Terraform configuration:

```hcl
module "postgres_aurora" {
  source = "git::https://github.com/your-org/randoneering-iac.git//terraform-modules/db/rds/aurora"

  service     = "myapp"
  environment = "prod"
  engine      = "aurora-postgresql"

  # Additional configuration...
}
```

### Using Deployment Templates

1. Copy the relevant template directory from `deploy-templates/`
2. Update `backend.tf` with your state backend configuration
3. Customize `locals.tf` with your environment-specific values
4. Review and adjust `main.tf` as needed
5. Run standard Terraform workflow:

```bash
terraform init
terraform plan
terraform apply
```

## Module Features

### Environment-Aware Defaults

Modules adjust settings based on the `environment` variable:

**Production (`prod`)**
- Backup retention: 14 days
- Backup window: 01:00-03:00
- Maintenance window: Tuesday 05:00-06:00

**Non-Production**
- Backup retention: 3 days
- Backup window: 12:00-14:00
- Maintenance window: Sunday 05:00-06:00

### Sensible Defaults

Most modules provide default values for common configurations:
- Default instance sizes (e.g., `db.t4g.medium` for Aurora)
- Standard naming conventions based on service name
- Environment-appropriate backup and maintenance windows
- CloudWatch logs enabled by default

## Requirements

- Terraform >= 1.0
- AWS provider credentials configured
- Appropriate IAM permissions for resource creation

## Contributing

This is an open source project. Contributions are welcome.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Notes

- The default master username for databases is `randoneering` (configurable)
- Master passwords are randomly generated if not provided
- Security groups reference pre-existing groups (`db_postgres_default`, `db_mysql_default`)
- Monitoring requires a pre-existing IAM role named `rds-monitoring-role`
