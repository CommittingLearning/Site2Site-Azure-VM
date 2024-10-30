# Provisioning network interface for the VM
resource "azurerm_network_interface" "vm_nic" {
    name                = "vmnic-${var.environment}"
    location            = var.location
    resource_group_name = format("%s_%s", var.rg_name, var.environment)

    # IP Address configuraiton for the VM Nic
    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.azurerm_subnet.vm_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
    name                  = "vm-${var.environment}"
    location              = var.location
    resource_group_name   = format("%s_%s", var.rg_name, var.environment)
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

# Create a Route Rable
resource "azurerm_route_table" "Vnetroute" {
    name                = format("%s_%s", var.rt, var.environment)
    location            = var.location
    resource_group_name = format("%s_%s", var.rg_name, var.environment)

    # Enable BGP Route Propogation
    bgp_route_propagation_enabled = true
}

resource "azurerm_subnet_route_table_association" "VMtoGate" {
    subnet_id      = data.azurerm_subnet.vm_subnet.id
    route_table_id = azurerm_route_table.Vnetroute.id
}