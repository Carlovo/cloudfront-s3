terraform {
  required_providers {
    # Must be in US-EAST-1, see README for more info.
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.15.0"
    }
  }

  required_version = ">= 1.5.6"
}
