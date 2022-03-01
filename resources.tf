# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_kms_vault" "wallet" {
  compartment_id = data.oci_identity_compartments.security.compartments[0].id
  display_name   = var.wallet.display_name
  vault_type     = var.input.type
  defined_tags   = var.assets.resident.defined_tags
  freeform_tags  = var.assets.resident.freeform_tags
}

resource "oci_kms_key" "wallet" {
  depends_on = [oci_kms_vault.wallet]
  compartment_id = data.oci_identity_compartments.security.compartments[0].id
  display_name   = "${var.wallet.display_name}_key"
  key_shape {
    algorithm = var.wallet.algorithm
    length    = var.wallet.length
  }
  management_endpoint = oci_kms_vault.wallet.management_endpoint
  defined_tags   = var.assets.resident.defined_tags
  freeform_tags  = var.assets.resident.freeform_tags
  protection_mode = var.input.type == "DEFAULT" ? "SOFTWARE" : "HSM"
}

resource "oci_kms_sign" "wallet" {
  depends_on = [oci_kms_vault.wallet, oci_kms_key]
  crypto_endpoint   = oci_kms_vault.wallet.crypto_endpoint
  key_id            = oci_kms_key.wallet.id
  message           = var.input.message
  signing_algorithm = var.wallet.algorithm == "RSA" ? "SHA_256_RSA_PKCS_PSS" : "ECDSA_SHA_256"
  message_type      = "RAW"
}

resource "oci_kms_verify" "wallet" {
  depends_on        = [oci_kms_vault.wallet, oci_kms_key, oci_kms_sign.wallet]
  crypto_endpoint   = oci_kms_vault.wallet.crypto_endpoint
  key_id            = oci_kms_key.wallet.id
  message           = var.input.message
  signing_algorithm = var.wallet.algorithm == "RSA" ? "SHA_256_RSA_PKCS_PSS" : "ECDSA_SHA_256"
  signature         = oci_kms_sign.wallet.signature
  message_type      = "RAW"
}