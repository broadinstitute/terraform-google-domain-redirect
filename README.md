# Terraform Module: Google Cloud DNS Domain Redirect

A Terraform module for [Google Cloud Platform](https://cloud.google.com) that simplifies the creation & configuration domain redirect for [Cloud DNS](https://cloud.google.com/dns/).

## Table of contents

* [Introduction](#introduction)
* [Requirements](#requirements)
* [Usage](#usage)
* [Inputs](#inputs)
  * [Required](#required-inputs)
* [Outputs](#outputs)
* [Changelog](#changelog)
* [Roadmap](#roadmap)

## Introduction

Google Cloud DNS does not have built-in support for 30x redirects. There has been an open [feature request](https://issuetracker.google.com/issues/70980380?pli=1) since 2017 with no ETA. This module provides this functionality through the use of a Cloud Storage bucket, a managed certificate, a global IP address, and url mappings.

## Requirements

* Terraform 0.14 or higher.
* `google` provider 3.67.0 or higher.

## Usage

```Terraform
module "www_example" {
  source        = "simplycubed/domain-redirect/google"
  hostname      = "www.${var.base_domain}"
  host_redirect = var.base_domain
}
```

## Inputs

### Required inputs

| Name           | Description | Type   |
|--------------- |-------------|--------|
| hostname       | The name of the website and the Cloud Storage bucket to create (e.g. static.foo.com). | string |
| host_redirect  | The name of the target domain to redirect | string |
| https_redirect | Issue TLS certificate and enable HTTPS | bool |
| path_redirect  | The target path to redirect | string |
| strip_query    | Strip URL query parameters | bool |
| redirect_response_code | HTTP status code to use for the redirect | [string](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map#redirect_response_code) |

## Outputs

In addition to the inputs documented above, the following values are available as outputs:

| Name | Description | Type |
|------|-------------|------|
| load_balancer_ip_address | IP address of the HTTP Cloud Load Balancer. | string |

## Changelog

* **1.0.0**
  * Release stable version.

## Roadmap

Issues containing possible future enhancements can be found [here](https://github.com/simplycubed/terraform-google-domain-redirect/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement).
