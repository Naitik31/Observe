# variable "tags" {
#   type        = map(string)
#   description = "Common tags for all IAM resources"
#   default     = {}
# }


variable "roles" {
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

variable "enable_role" {
  description = "Deploy role module?"
  type        = bool
}

variable "alb_controller_role" {
  type = object({
    role_name           = string
    oidc_sa             = string
    inline_policy_json  = string
    managed_policy_arns = list(string)
  })
}

variable "enable_alb_iam_role" {
  type    = bool
  default = false
  description = "Enable creation of ALB IAM Role (IRSA)"
}