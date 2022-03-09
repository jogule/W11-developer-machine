# W11-developer-machine

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjogule%2FW11-developer-machine%2Fmain%2Fmain.json)

https://raw.githubusercontent.com/jogule/W11-developer-machine/main/main.json

## Summary

This ARM template is a preconfigured Windows 11 developer VM intended for Azure Immersion Workshops with the following packages pre-instaled:

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
14. SQL Server Management Studio wit Azure Data Studio

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

## For upload vhd

1. Get SAS URI from **source** disk
1.a $sas-uri
1.b Surround "&" ocurrences in the $sas-uri string with double quotes ""&""
i.e:
This: 
`"https://md-ltt2kdr5kz0c.z9.blob.storage.azure.net/lb1r4ht0cjsv/abcd?sv=2018-03-28&sr=b&si=afacb80e-9057-44c2-801f-0ed85e5bd09e&sig=d45NcsLPNrj3MYogYaUxBbxBtIN7ov2mgbyL8RCy5z4%3D"`

Into this: `"https://md-ltt2kdr5kz0c.z9.blob.storage.azure.net/lb1r4ht0cjsv/abcd?sv=2018-03-28""&""sr=b""&""si=afacb80e-9057-44c2-801f-0ed85e5bd09e""&""sig=d45NcsLPNrj3MYogYaUxBbxBtIN7ov2mgbyL8RCy5z4%3D"`
2. Get **destination** storage account info:
```az cli
$storageAccountKey="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$storageAccountName="jonguzxyz"
$storageContainerName="vhds"
$destinationVHDFileName="W11VM.vhd"
```
3. Start copy with `az storage blob copy start`
```az cli
az storage blob copy start --account-key $storageAccountKey --account-name $storageAccountName --destination-blob $destinationVHDFileName --destination-container $storageContainerName --source-uri $sas-uri
```
4. Use `az storage blob show` to get progress
```az cli
az storage blob show -n $destinationVHDFileName -c $storageContainerName --account-name $storageAccountName --account-key $storageAccountKey --query properties.copy.progress
```