# Provisioning network interface for the VM
resource "azurerm_network_interface" "vm_nic" {
    name                      = "vmnic-${var.environment}"
    location                  = var.location
    resource_group_name       = "${var.rg_name}_${var.environment}"

    # IP Address configuraiton for the VM Nic
    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.terraform_remote_state.vnet.outputs.subnetVM.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
    name                  = "vm-${var.environment}"
    location              = var.location
    resource_group_name   = "${var.rg_name}_${var.environment}"
    network_interface_ids = [azurerm_network_interface.vm_nic.id]
    size                  = var.VMsize
    
    # Username and password for the machine. Will be pushed using Github secrets.
    admin_username = var.admin_username
    admin_password = var.admin_password

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsDesktop"
        offer     = "Windows-10"
        sku       = "win10-21h2-pro"
        version   = "latest"
    }

    tags = {
        environment = var.environment
    }
}