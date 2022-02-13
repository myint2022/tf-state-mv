module "pomelo_ml_production" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"
  bucket  = "pomelo-ml-production-2022-02-13"
  acl     = "private"
  versioning = {
    enabled = true
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # SSE encryption for bucket
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "s3:*",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${local.master_account_id}:role/data-engineering"
        },
        "Resource": "arn:aws:s3:::pomelo-ml-production/*"
      }
    ]
  }
  POLICY
  tags = merge(local.base_bucket_tags, {
    Name        = "pomelo-ml-production",
    Environment = "staging"
    yor_trace   = "7dbb6631-4cd0-4b9c-9a40-8d6e15edc770"
  })
  providers = {
    aws = aws.master
  }
}
module "log_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        =  "pomelo-ml-production-${random_string.resource_code.result}"
  acl           = "log-delivery-write"
  force_destroy = true
  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # SSE encryption for bucket
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  
  providers = {
    aws = aws.master
  }
}
resource "aws_s3_bucket_metric" "pomelo_ml_production_bucket" {
  #TODO:
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled
  provider = aws.master
  bucket   = module.pomelo_ml_production.s3_bucket_id
  name     = "pomelo-ml-production-bucket"
}
resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}
