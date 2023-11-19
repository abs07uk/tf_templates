connect-AzAccount
new-azresourceGroup -Name "uks-amr-01-rg" -Location "uksouth"
New-AzResourceGroupDeployment -name addstorage -ResourceGroupName "uks-amr-01-rg" -TemplateFile .\strcontainer.bicep

AZ CLI
 az login `
 az group create --name uks-amr-01-rg --location uksouth `
 az deployment group create `
--name strdeploy `
--resource-group uks-amr-01-rg `
--template-file .\strcontainer.bicep