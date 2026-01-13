terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = ">= 1.3.0"
    }
    secretsmanager = {
      source  = "keeper-security/secretsmanager"
      version = ">= 1.1.4"
    }
    keeper = {
      source  = "keeper-security/keeper"
      version = ">= 1.2.0"
    }
  }
}