terraform {

  backend "s3" {
    bucket  = ""
    key     = "postgres/NAMEOFSERVICE-db.tfstate"
    region  = "us-west-2"
    encrypt = true
    profile = "profile-name"
  }
}
