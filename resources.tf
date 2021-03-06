# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_kms_vault" "wallet" {
  compartment_id = data.oci_identity_compartments.security.compartments[0].id
  count          = local.wallet_count
  display_name   = var.configuration.encryption.vault
  vault_type     = var.options.type
  defined_tags   = var.assets.service.defined_tags
  freeform_tags  = local.module_freeform_tags
}

resource "oci_kms_key" "wallet" {
  depends_on = [
    oci_kms_vault.wallet,
    data.oci_kms_vaults.wallet
  ]
  compartment_id = data.oci_identity_compartments.security.compartments[0].id
  count          = local.wallet_count
  display_name   = var.configuration.encryption.key.name
  key_shape {
    algorithm = var.configuration.encryption.key.algorithm
    length    = var.configuration.encryption.key.length
  }
  management_endpoint = oci_kms_vault.wallet[0].management_endpoint
  defined_tags        = var.assets.service.defined_tags
  freeform_tags       = local.module_freeform_tags
  protection_mode     = var.options.type == "DEFAULT" ? "SOFTWARE" : "HSM"
}

resource "oci_vault_secret" "wallet" {
  depends_on     = [
    oci_kms_vault.wallet, 
    oci_kms_key.wallet,
    data.oci_vault_secrets.wallet
  ]
  for_each       = var.options.create == true ? var.configuration.encryption.secrets  : {}
  compartment_id = data.oci_identity_compartments.security.compartments[0].id
  secret_name    = "${each.value.name}"
  vault_id       = oci_kms_vault.wallet[0].id
  defined_tags   = var.assets.service.defined_tags
  freeform_tags  = local.module_freeform_tags
  description    = "Secret in the ${oci_kms_vault.wallet[0].display_name} wallet"
  key_id         = oci_kms_key.wallet[0].id
  secret_content {
    content_type = "BASE64"
    content      = base64encode(each.value.phrase)
    name         = each.value.name
    stage        = "CURRENT"
  }
}

resource "random_password" "wallet" {
  count       = length(var.configuration.encryption.passwords)
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  min_special = 1
}