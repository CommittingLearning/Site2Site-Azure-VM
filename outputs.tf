output "VM_Name" {
    value = azurerm_windows_virtual_machine.vm.name
}

output "nicVM_name" {
    value = azurerm_network_interface.vm_nic.name
}