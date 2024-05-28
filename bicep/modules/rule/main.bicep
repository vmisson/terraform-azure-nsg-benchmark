param nsgName string
param name string
param properties object

resource rule 'Microsoft.Network/networkSecurityGroups/securityRules@2023-11-01' = {
  name: '${nsgName}/${name}'
  properties: properties
}

