terraform {
  backend "s3" {
    bucket = "my-tfs-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
