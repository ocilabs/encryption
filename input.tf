# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "account" {
  description = "retrieved tenancy data"
  type = object({
    tenancy_id     = string,
    class          = string
  })
}
variable "options" {
  description = "optional flags, retrieved from the schema file"
  type = object({
    type   = string,
    create = bool
  })
}

variable "configuration" {
  description = "Input parameter for the service configuration"
  type = object({
    resident   = any,
    encryption = any
  })
}

variable "assets" {
  description = "Retrieve asset identifier"
  type = object({
    resident = any
  })
}