# Define provider and region
provider "aws" {
  profile = "captain"
  region  = var.region
  # Define a path to the aws credentials
  shared_credentials_files = var.credentials
}

# Define terraform and aws provider minimum versions
terraform {
  required_version = ">=1.12"

  # Configure S3 bucket as backend
  backend "s3" {
    bucket         = "rschool-tfstates"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "tf_lockid"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
