# Terraform script to benchmark NSG deployment in Azure

# Overview

This Terraform script deploys a network security group (NSG) in Azure. 

One script is using only azurerm_network_security_group resource and the other script is using azurerm_network_security_group and azurerm_network_security_rule resource to create the same NSG.

This repository will use GitHub Actions to benchmark the deployment time of the two scripts.

# Usage

Any user can clone this repository and run the GitHub Actions workflow to benchmark the deployment time of the two scripts.

The action is triggered by a push to the main branch. The action will deploy the two scripts in parallel.

# Benchmark

Test 1 : NSG creation with 200 rules (Plan / Apply / Destroy)
Test 2 : NSG creation with 500 rules (Plan / Apply / Destroy)
Test 3 : NSG creation with 1000 rules (Plan / Apply / Destroy)
Test 4 : NSG creation with 2 rules (Plan / Apply)
Test 5 : NSG update from 2 rules to 200 rules (Plan / Apply)
Test 6 : NSG update from 200 rules to 500 rules (Plan / Apply)
Test 7 : NSG update from 500 rules to 1000 rules (Plan / Apply)

# Results