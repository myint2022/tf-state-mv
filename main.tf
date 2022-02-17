terraform {
  cloud {
    organization = "max_account"
    workspaces {
      name = "tf-state-mv"
    }
  }

  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.2.1"
    }
  }
}

/* provider "vault" {
  address = "https://vault.pmlo.co"

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.approle_role_id
      secret_id = var.approle_secret_id
    }
  }
} */

provider "aws" {
  region              = "ap-southeast-1"
  alias               = "master"
  allowed_account_ids = [559190605129]
  access_key = var.access_key
  secret_key = var.secret_key

  #access_key = data.vault_aws_access_credentials.creds.access_key
  #secret_key = data.vault_aws_access_credentials.creds.secret_key
  #token      = data.vault_aws_access_credentials.creds.security_token
}