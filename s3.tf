resource "aws_s3_bucket" "pomelo-ml-production-2022-02-13" {
  #TODO:
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled
  provider            = aws.master
  acceleration_status = "Enabled"
  acl                 = "private"
  arn                 = "arn:aws:s3:::pomelo-ml-production-2022-02-13"
  bucket              = "pomelo-ml-production-2022-02-13"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = "9000"
  }

  force_destroy = "true"
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
  website_endpoint = "pomelo-ml-production-2022-02-13.s3-website-ap-southeast-1.amazonaws.com"

  tags = merge(local.base_bucket_tags, {
    Name        = "pomelo-ml-production",
    Environment = "staging"
  })
}

resource "aws_s3_bucket_policy" "max-2022-s3" {
  provider   = aws.master
  depends_on = [aws_s3_bucket.pomelo-ml-production-2022-02-13]
  bucket     = "pomelo-ml-production-2022-02-13"

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
        "Resource": "arn:aws:s3:::pomelo-ml-production-2022-02-13/*"
      }
    ]
  }
  POLICY
}

/* module "pomelo_ml_production" {

  source = "terraform-aws-modules/s3-bucket/aws"

  version       = "2.14.1"
  bucket        = "pomelo-ml-production-2022-02-13"
  acl           = "private"
  force_destroy = "true"
  versioning = {
    enabled    = true
    mfa_delete = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
      max_age_seconds = 9000
    }

  ]

  website = {
    index_document = "index.html"
  }


  tags = merge(local.base_bucket_tags, {
    Name        = "pomelo-ml-production",
    Environment = "staging"
  })

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
        "Resource": "arn:aws:s3:::pomelo-ml-production-2022-02-13/*"
    }
]
}
  POLICY

  providers = {
    aws = aws.master
  }

} */