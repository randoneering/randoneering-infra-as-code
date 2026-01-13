data "terraform_remote_state" "tf" {
  backend = "s3"
  config = {
    bucket  = "${local.environment.environment}-tfstate"
    key     = "${local.environment.engine}/${local.environment.service}-db.tfstate"
    region  = "us-west-2"
    encrypt = true
    profile = "profile-name"

  }
}

data "aws_route53_zone" "zone" {
  name = local.environment.route53zone
}

data "aws_caller_identity" "current" {}
