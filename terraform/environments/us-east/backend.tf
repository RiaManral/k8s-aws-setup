terraform {
  backend "s3" {
    bucket       = "k8s-aws-setup-tfstate"
    key          = "us-east/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
