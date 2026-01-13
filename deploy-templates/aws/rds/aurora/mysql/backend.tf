terraform {

  backend "s3" {
    bucket  = ""
    key     = "aurora-mysql/NAMEOFSERVICE-db.tfstate" # Seen as a file path in S3. This will be deployed at the HEAD of the s3 bucket.
    region  = "us-west-2"
    encrypt = true
    profile = "profile-name"
  }
}
