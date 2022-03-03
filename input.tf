# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "input" {
    type = object({
      type   = string,
      secret = string,
      phrase = string
    })
    description = "Schema input for the wallet creation"
}

variable "tenancy" {
  type = object({
    id      = string,
    class   = number,
    buckets = string,
    region  = map(string)
  })
  description = "Tenancy Configuration"
}

variable "assets" {
  type = object({
    resident = any
    network  = any
  })
  description = "Retrieve asset identifier"
}

variable "resident" {
  type = object({
    owner          = string,
    name           = string,
    label          = string,
    stage          = number,
    region         = map(string)
    compartments   = map(number),
    repository     = string,
    groups         = map(string),
    policies       = map(any),
    notifications  = map(any),
    tag_namespaces = map(number),
    tags           = any
  })
  description = "Service configuration"
}

variable "network" {
  type = object({
    name         = string,
    region       = string,
    display_name = string,
    dns_label    = string,
    compartment  = string,
    stage        = number,
    cidr         = string,
    gateways     = any,
    route_tables = map(any),
    subnets      = map(any),
    security_lists = any
  })
  description = "Creating a network topology for a service resident"
}

variable "wallet" {
  type = object({
    compartment = string,
    vault       = string,
    stage       = number,
    key         = map(string),
    signature   = map(string),
  })
  description = "Enabling enryption for a service resident"
}