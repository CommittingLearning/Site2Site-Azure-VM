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

    tags = {
        environment = var.environment
    }
}

# Provisioning a windows 10 pro VM
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

# Creating an NSG for the VM
resource "azurerm_network_security_group" "vm_nsg" {
    name                = format("%s_%s", var.nsg, var.environment)
    location            = var.location
    resource_group_name = format("%s_%s", var.rg_name, var.environment)

    # Security Rule to allow inbound ICMP traffic from the AWS VPC
    security_rule {
        name                       = "AllowICMPInbound"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Icmp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = var.aws_vpc_cidr
        destination_address_prefix = "*"
    }

    # Security Rule to allow outbound ICMP traffic to the AWS VPC
    security_rule {
        name                       = "AllowICMPOutbound"
        priority                   = 1000
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Icmp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = var.aws_vpc_cidr
    }
}

# Associating the NSG to the VM's network interface
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg_assoc" {
    network_interface_id      = azurerm_network_interface.vm_nic.id
    network_security_group_id = azurerm_network_security_group.vm_nsg.id
}