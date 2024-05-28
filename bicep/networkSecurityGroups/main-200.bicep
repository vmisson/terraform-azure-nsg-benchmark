targetScope='subscription'

param resourceGroupName string = 'rg-bicep-networkSecurityGroups'
param location string = 'westeurope'
param nsgName string = 'nsg'
var nsgconfig = loadJsonContent('../rules-200.json')


resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module nsg '../modules/nsg/main.bicep' = {
  name: nsgName
  scope: rg
  params: {
    name: nsgName
    location: location
    securityRules: nsgconfig
  }
}
