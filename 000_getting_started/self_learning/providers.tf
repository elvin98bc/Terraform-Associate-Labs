terraform { 
  cloud { 
    organization = "elvin98bc-devops-learning" 

    workspaces { 
      name = "getting-started" 
    } 
  }

  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "elvin98bc-devops-learning"

  #   workspaces {
  #     name = "getting-started"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta1"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
}

provider "aws" {
  region  = "ap-southeast-2"
  alias  = "asia2"  
}