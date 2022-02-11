locals {
  base_bucket_tags = {
    Department = "technology"
    Team       = "all"
    Schedule   = "na"
    Tier       = "backend"
  }
  master_account_id = data.aws_caller_identity.current.account_id

  #production_account_id = "559190605129"
}