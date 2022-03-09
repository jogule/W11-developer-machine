# W11-developer-machine

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjogule%2FW11-developer-machine%2Fmain%2Fmain.json)

https://raw.githubusercontent.com/jogule/W11-developer-machine/main/main.json

## For manual deployment using az cli

1. Build the bicep file to an ARM (.json) template
`bicep build .\main.bicep`
2. Create a target resource group in Azure
```az cli
az group create -n testRG -l eastus
```
3. Deploy the built ARM template
```az cli
az deployment group create -g testRG -f main.bicep
```
