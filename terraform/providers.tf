terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  // Identifies bucket and name key for storing TF state files
  backend "s3" {
    bucket = "treysimmons.io-terraform"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "treysimmons.io"
    }
  }
}
