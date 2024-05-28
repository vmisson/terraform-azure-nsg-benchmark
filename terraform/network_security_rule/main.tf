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
    key                  = "network_security_rule_benchmark.tfstate"
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

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-terraform-network-security-rule"
}

variable "location" {
  description = "The location for the resources"
  type        = string
  default     = "westeurope"
}

locals {
  rules_csv = csvdecode(file(var.rules_file))
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "this" {
  for_each                    = { for rule in local.rules_csv : rule.name => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}