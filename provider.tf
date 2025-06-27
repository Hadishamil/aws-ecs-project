terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-bucket" # Replace with your bucket name
    key            = "terraform.tfstate"         # Path to the state file
    region         = "us-east-1"                 # Match your AWS region
    dynamodb_table = "terraform-locks"           # Match your DynamoDB table name
    encrypt        = true                        # Enable server-side encryption

  }
}

# Provider configuration
provider "aws" {
  region = "us-east-1" # Configuration options
}










