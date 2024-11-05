variable "azure_subscription_id" {
    description = "The Subscription ID for the Azure account"
    type        = string
}

variable "azure_client_id" {
    description = "The Client ID (App ID) for the Azure Service Principal"
    type        = string 
}

variable "azure_tenant_id" {
    description = "The Tenant ID for the Azure account"
    type        = string
}

variable "rg_name" {
    description = "Name of the Resource Group"
    default     = "Site2Site_rg"
}

variable "location" {
    description = "Region of Deployment"
    default     = "West US"
}

variable "environment" {
    description = "The environment (e.g., development, production) to append to the VNet name"
    type        = string
}

variable "VMsize" {
    description = "Size of the VM"
    type        = string
    default     = "Standard_B1s"
}

variable "admin_username" {
    description = "Identity used to login to the machine"
    default     = "adminuser"
}

variable "admin_password" {
    description = "method to authenticate user to the machine"
    sensitive   = true
}

variable "rt" {
    description = "Name of the route table to be associated with the vm subnet"
    type        = string
    default     = "VMtoGate"
}

variable "nsg" {
    description = "Name of the NSG to be attached to the VM"
    type        = string
    default     = "s2sVMnsg"
}

variable "aws_vpc_cidr" {
    description = "CIDR range of AWS VPC"
    type        = string
    default     = "192.168.0.0/16"
}