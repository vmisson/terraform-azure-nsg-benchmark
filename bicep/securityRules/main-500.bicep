targetScope='subscription'

param resourceGroupName string = 'rg-bicep-networkSecurityRules'
param location string = 'westeurope'
param nsgName string = 'nsg'
var nsgconfig = loadJsonContent('../rules.json')


resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module nsg '../modules/nsg/main.bicep' = {
  scope: rg

  name: nsgName
  params: {
    name: nsgName
    location: location
    securityRules: []
  }
}

module nsgRules '../modules/rule/main.bicep' = [for rule in nsgconfig: {
  scope: rg

  name: rule.name
  params: {
    name: rule.name
    nsgName: nsgName
    properties: rule.properties
  }

  dependsOn: [
    nsg
  ]
}
]
