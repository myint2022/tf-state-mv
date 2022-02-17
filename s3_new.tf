module "pomelo_ml_staging" {
  source  = "cloudposse/s3-log-storage/aws"
  version = "0.25.0"

  name                   = "pomelo-ml-staging-2022-FEB"
  acl                    = "private"
  sse_algorithm          = "AES256"
  lifecycle_rule_enabled = false
  versioning_enabled     = var.enable_versioning
  access_log_bucket_name = var.s3_bucket_logs_target

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
        "Resource": "arn:aws:s3:::pomelo-ml-staging-2022-FEB-17/*"
      }
    ]
  }
  POLICY

  tags = merge(local.base_bucket_tags, {
    Name        = "pomelo-ml-staging",
    Environment = "staging"
  })

  providers = {
    aws = aws.master
  }
}

resource "aws_s3_bucket_metric" "pomelo_ml_staging_bucket" {
  #TODO:
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled
  provider = aws.master

  bucket = module.pomelo_ml_staging.bucket_id
  name   = "pomelo-ml-staging-bucket"
}


/* module "pomelo_ml_staging" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket                  = "pomelo-ml-staging-2022-FEB-17"
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.pomelo_ml_staging.json

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(local.base_bucket_tags, {
    Name        = "pomelo-ml-staging"
    Environment = "production"
  })

  providers = {
    aws = aws.master
  }
}

resource "aws_s3_bucket_metric" "pomelo_ml_staging_bucket" {
  provider = aws.master
  #TODO:
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled

  bucket = module.pomelo_ml_staging.s3_bucket_id
  name   = "pomelo-ml-staging-bucket"
}

data "aws_iam_policy_document" "pomelo_ml_staging" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::pomelo-ml-staging-2022-FEB-17/*"]
    actions   = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::559190605129:root"]
    }
  }
  provider = aws.master

} */