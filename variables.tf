variable "bucket_name" {
  description = "Globally unique name for the S3 bucket."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be between 3 and 63 characters."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete a non-empty bucket."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable S3 bucket versioning."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ARN or ID. Null uses SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Keys when SSE-KMS is used."
  type        = bool
  default     = true
}

variable "public_access_block" {
  description = "S3 public access block configuration."
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })

  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for object expiration, transitions, and noncurrent versions."
  type = list(object({
    id                                 = string
    enabled                            = bool
    prefix                             = optional(string)
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))

  default = []

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      rule.expiration_days != null || rule.noncurrent_version_expiration_days != null || length(rule.transitions) > 0
    ])
    error_message = "Each lifecycle rule must define expiration_days, noncurrent_version_expiration_days, or at least one transition."
  }
}

variable "bucket_policy" {
  description = "Optional JSON bucket policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the S3 bucket."
  type        = map(string)
  default     = {}
}
