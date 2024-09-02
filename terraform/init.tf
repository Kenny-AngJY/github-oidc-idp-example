terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"
    }
  }

  required_version = "~> 1.9"
}

provider "aws" {
  region = "ap-southeast-1"
  # These default tags below will be applied to the resource if no tags are explictly defined in the resource.
  default_tags {
    tags = local.default_tags
  }
}