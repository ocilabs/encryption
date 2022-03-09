# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_kms_sign" "wallet" {
  depends_on        = [oci_kms_vault.wallet, oci_kms_key.wallet]
  for_each          = var.input.create == true ? var.encryption.signatures  : []
  crypto_endpoint   = oci_kms_vault.wallet[0].crypto_endpoint
  key_id            = oci_kms_key.wallet[0].id
  key_version_id    = data.oci_kms_key_versions.wallet.key_versions[0].id
  signing_algorithm = each.value.algorithm
  message           = each.value.message
  message_type      = each.value.type
}

/*
resource "oci_kms_verify" "wallet" {
  depends_on        = [oci_kms_vault.wallet, oci_kms_key.wallet, oci_kms_sign.wallet]
  for_each          = oci_kms_sign.wallet
  crypto_endpoint   = oci_kms_vault.wallet.crypto_endpoint
  key_id            = oci_kms_key.wallet.id
  key_version_id    = data.oci_kms_key_versions.wallet.key_versions[0].id
  signing_algorithm = each.value.signing_algorithm
  signature         = each.value.signature
  message           = each.value.message
  message_type      = each.value.message_type
}
*/