data "terraform_remote_state" "vnet" {
    backend = "azurerm"
    config = {
        storage_account_name = "tsblobstore11${var.environment}"
        container_name       = "terraform-state"
        key                  = "Site2Site_VPC_${var.environment}"
        resource_group_name  = "Site2Site_rg_${var.environment}"
        use_oidc               = true
        client_id              = var.azure_client_id
        tenant_id              = var.azure_tenant_id
        subscription_id        = var.azure_subscription_id
    }
}

output "vnet_name" {
    value = data.terraform_remote_state.vnet.outputs.vnet_name
}

output "subnetVM_name" {
    value = data.terraform_remote_state.vnet.outputs.subnetVM_name
}