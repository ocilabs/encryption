# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "compartment_id" {
  description = "OCID for the security compartment"
  value = data.oci_identity_compartments.security.compartments[0].id
}

output "vault_id" {
  description = "Identifier for the key management service (KMS) vault"
  value       = length(oci_kms_vault.wallet) > 0 ? oci_kms_vault.wallet.id : null
}

output "key_id" {
  description = "Identifier for the master key, created for the vault"
  value       = length(oci_kms_key.wallet) > 0 ? oci_kms_key.wallet.id : null
}

output "wallet_signature" {
  value = length(oci_kms_sign.wallet) > 0 ? oci_kms_sign.wallet.signature : null
}

output "secret_id" {
  value = length(oci_vault_secret.wallet) > 0 ? oci_vault_secret.wallet.id : null
}