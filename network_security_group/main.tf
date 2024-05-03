terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "cloud63tfstate"
    container_name       = "tfstate"
    key                  = "network_security_group_benchmark.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "rules_file" {
  description = "The path to the CSV file containing the rules"
  type        = string
  default     = "../rules.csv"
}

locals {
  rules_csv = csvdecode(file(var.rules_file))
}

resource "azurerm_resource_group" "this" {
  name     = "rg-network-security-group"
  location = "westeurope"
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = { for rule in local.rules_csv : rule.name => rule }
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

