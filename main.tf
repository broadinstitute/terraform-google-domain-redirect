locals {
  safe_hostname = replace(var.hostname[0], ".", "-")
}

resource "google_compute_url_map" "https_url_map" {
  name = "${local.safe_hostname}-https-url-map"

  default_url_redirect {
    host_redirect          = var.host_redirect
    path_redirect          = var.path_redirect
    redirect_response_code = var.redirect_response_code
    strip_query            = var.strip_query
  }
}

resource "google_compute_managed_ssl_certificate" "certificate" {
  provider = google-beta
  name     = "${local.safe_hostname}-managed-certificate"

  managed {
    domains = var.hostname
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${local.safe_hostname}-https-proxy"
  url_map          = google_compute_url_map.https_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.certificate.self_link]
}

resource "google_compute_url_map" "http_url_map" {
  name = "${local.safe_hostname}-to-http-url-map"

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
  url_map = google_compute_url_map.http_url_map.self_link
}

resource "google_compute_global_address" "public_address" {
  name         = "${local.safe_hostname}-public-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_https_rule" {
  name       = "${local.safe_hostname}-global-forwarding-https-rule"
  target     = google_compute_target_https_proxy.https_proxy.self_link
  ip_address = google_compute_global_address.public_address.address
  port_range = "443"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_http_rule" {
  name       = "${local.safe_hostname}-global-forwarding-http-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  ip_address = google_compute_global_address.public_address.address
  port_range = "80"
}
