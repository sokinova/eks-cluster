terraform {
  backend "s3" {
    bucket         = "aziza-eks-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = false
  }
}