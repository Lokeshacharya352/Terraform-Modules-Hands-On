terraform {

  backend "s3" {

    bucket = "lucky-terraform-state-file-bucket"

    key = "project-2/terraform.tfstate"

    region = "us-east-1"
  }

}