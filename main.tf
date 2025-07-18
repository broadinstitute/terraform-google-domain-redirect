locals {
  safe_hostname = replace(var.hostname[0], ".", "-")
}

resource "google_compute_url_map" "https_url_map" {
  name    = "${local.safe_hostname}-https-url-map"
  project = var.project

  default_url_redirect {
    host_redirect          = var.host_redirect
    path_redirect          = var.path_redirect
    redirect_response_code = var.redirect_response_code
    strip_query            = var.strip_query
  }
}

resource "google_compute_managed_ssl_certificate" "certificate" {
  name     = "${local.safe_hostname}-managed-certificate"
  project  = var.project
  provider = google-beta

  managed {
    domains = var.hostname
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${local.safe_hostname}-https-proxy"
  project          = var.project
  ssl_certificates = [google_compute_managed_ssl_certificate.certificate.self_link]
  url_map          = google_compute_url_map.https_url_map.self_link
}

resource "google_compute_url_map" "http_url_map" {
  name    = "${local.safe_hostname}-to-http-url-map"
  project = var.project

  default_url_redirect {
    host_redirect          = var.host_redirect
    https_redirect         = var.https_redirect
    path_redirect          = var.path_redirect
    strip_query            = var.strip_query
    redirect_response_code = var.redirect_response_code
  }
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${local.safe_hostname}-http-proxy"
  project = var.project
  url_map = google_compute_url_map.http_url_map.self_link
}

resource "google_compute_global_address" "public_address" {
  name         = "${local.safe_hostname}-public-address"
  project      = var.project
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_https_rule" {
  ip_address = google_compute_global_address.public_address.address
  name       = "${local.safe_hostname}-global-forwarding-https-rule"
  port_range = "443"
  project    = var.project
  target     = google_compute_target_https_proxy.https_proxy.self_link
}

resource "google_compute_global_forwarding_rule" "global_forwarding_http_rule" {
  ip_address = google_compute_global_address.public_address.address
  name       = "${local.safe_hostname}-global-forwarding-http-rule"
  port_range = "80"
  project    = var.project
  target     = google_compute_target_http_proxy.http_proxy.self_link
}
