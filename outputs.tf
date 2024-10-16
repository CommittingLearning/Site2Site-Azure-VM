output "vnet_name" {
    value = data.terraform_remote_state.vnet.outputs.vnet_name
}

output "subnetVM_name" {
    value = data.terraform_remote_state.vnet.outputs.subnetVM_name
}

output "VM_Name" {
    value = azurerm_windows_virtual_machine.vm.name
}

output "nicVM_name" {
    value = azurerm_network_interface.vm_nic.name
}