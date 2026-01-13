terraform {

  backend "s3" {
    bucket  = "ENVIRONMENT-tfstate"             # You will need to change the "ENVIRONMENT" to the target environment
    key     = "ENGINE/NAMEOFSERVICE-DB.tfstate" # Seen as a file path in S3. This will be deployed at the HEAD of the s3 bucket.
    region  = "us-west-2"
    encrypt = true
    profile = "" # If deploying manually
  }
}
