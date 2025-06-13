resource "aws_s3_bucket" "rschool-tfstates" {
  bucket = "rschool-tfstates"
  # Enable object lock
  object_lock_enabled = true
}
# Configure server side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "rschool-tfstates" {
  bucket = aws_s3_bucket.rschool-tfstates.id

  #Specify the encryption options
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

# Create an ACL for the S3 bucket to be private
resource "aws_s3_bucket_acl" "rschool-tfstates-private-acl" {
  bucket = aws_s3_bucket.rschool-tfstates.id
  acl    = "private"
}

# Enable versioning for the S3 bucket configured for the Terraform backend
resource "aws_s3_bucket_versioning" "rschool-tfstates-versioning-enabled" {
  bucket = aws_s3_bucket.rschool-tfstates.id
  versioning_configuration {
    status = "Enabled"
  }
}
