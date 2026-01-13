data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket  = "${local.environment.s3_bucket}-tfstate"
    key     = "ENGINE/NAMEOFSERVICE-DB.tfstate"
    region  = "us-west-2"
    encrypt = true
    profile = ""
  }
}
