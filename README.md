# W11-developer-machine

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjogule%2FW11-developer-machine%2Fmain%2Fmain.json)

https://raw.githubusercontent.com/jogule/W11-developer-machine/main/main.json

## Summary

This ARM template is a preconfigured Windows 11 developer VM with the following packages pre-instaled:

1. chocolately
2. vscode
3. dotnet
4. git
5. wsl2
6. Windows Terminal
7. GitHub CLI
8. AZ CLI
9. Docker Desktop
10. nodejs
11. VS2022
12. Terraform
13. Powershell Core 7.0

## For manual deployment using az cli

1. Build the bicep file to an ARM (.json) template
```az cli
bicep build .\main.bicep
```
2. Create a target resource group in Azure
```az cli
az group create -n testRG -l eastus
```
3. Deploy the built ARM template
```az cli
az deployment group create -g testRG -f main.bicep
```
