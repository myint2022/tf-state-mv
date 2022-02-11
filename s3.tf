resource "aws_s3_bucket" "max-2022-s3-bucket" {
  #TODO:
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled
  provider = aws.master

  acceleration_status = "Enabled"
  acl                 = "private"
  arn                 = "arn:aws:s3:::max-2022-s3-bucket-${random_id.s3.hex}"
  bucket              = "max-2022-s3-bucket-${random_id.s3.hex}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = "9000"
  }

  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = var.enable_versioning
    mfa_delete = var.enable_mfa_delete
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-ap-southeast-1.amazonaws.com"
  website_endpoint = "max-2022-s3-bucket-${random_id.s3.hex}.s3-website-ap-southeast-1.amazonaws.com"

  tags = merge(local.base_bucket_tags, {
    Name        = "max-2022-s3-bucket",
    Environment = "staging"
  })
}

resource "aws_s3_bucket_policy" "max-2022-s3-bucket" {
  provider = aws.master

  bucket = "max-2022-s3-bucket-${random_id.s3.hex}"

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "s3:*",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::559190605129:root"
        },
        "Resource": "arn:aws:s3:::max-2022-s3-bucket-${random_id.s3.hex}/*"
      }
    ]
  }
  POLICY
}


resource "random_id" "s3" {
  byte_length = 8
}

