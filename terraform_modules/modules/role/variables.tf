variable "roles" {
  description = "IAM roles configuration map"
  type = map(object({
    role_name            = string
    assume_role_policy   = optional(object({ Service = string }))
    assume_oidc_provider = optional(bool, false)
    oidc_issuer          = optional(string)
    oidc_sa              = optional(string)
    managed_policy_arns  = optional(list(string), [])
    inline_policy_json   = optional(string, null)
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}