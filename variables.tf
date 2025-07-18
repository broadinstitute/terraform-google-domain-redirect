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

variable "path_redirect" {
  default     = ""
  description = "The target path to redirect"
  type        = string
}

variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "strip_query" {
  default     = false
  description = "Strip URL query parameters"
  type        = bool
}

variable "redirect_response_code" {
  default     = "MOVED_PERMANENTLY_DEFAULT"
  description = "HTTP status code to use for the redirect"
  type        = string
}
