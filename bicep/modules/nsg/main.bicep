param name string
param securityRules array
param location string 

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: name
  location: location

  properties: {
    securityRules: securityRules 
  }
}
