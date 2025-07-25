variable "hostname" {
  description = "The name(s) of the website(s) and the Cloud Storage bucket to create (e.g. static.foo.com)."
  type        = list(any)
}

variable "host_redirect" {
  description = "The name of the target domain to redirect"
  type        = string
}

variable "https_redirect" {
  default     = true
  description = "Issue TLS certificate and enable HTTPS"
  type        = bool
}

variable "name" {
  default     = null
  description = "The name to use for all resources created."
  nullable    = true
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.name)) || var.name == null
    error_message = "The name value must be a valid Google resource name, alphanumeric and dashes."
  }
}

variable "path_redirect" {
  default     = ""
  description = "The target path to redirect"
  type        = string
}

variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "redirect_response_code" {
  default     = "MOVED_PERMANENTLY_DEFAULT"
  description = "HTTP status code to use for the redirect"
  type        = string
}

variable "strip_query" {
  default     = false
  description = "Strip URL query parameters"
  type        = bool
}

variable "ssl_policy" {
  default     = null
  description = "The SSL policy to use for the redirects."
  type        = string
}
