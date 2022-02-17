variable "namespace" {
  type    = string
  default = "pomelofashion"
}

variable "service_name" {
  type    = string
  default = "com.amazonaws.ap-southeast-1.s3"
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "enable_mfa_delete" {
  type    = bool
  default = false
}

variable "s3_bucket_logs_target" {
  type    = string
  default = "s3bucketlogsglobal"
}

variable "s3_bucket_logs_prefix" {
  type    = string
  default = "logs/"
}

variable "approle_role_id" {
  type    = string
  default = ""
}

variable "approle_secret_id" {
  type    = string
  default = ""
}

variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}

variable "s3_bucket_logs_target" {
  type    = string
  default = "maxwl-s3-log"
}

variable "enable_versioning" {
  type    = bool
  default = true
}