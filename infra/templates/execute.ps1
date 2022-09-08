

$templateFile = "main.json"
$parameterFile = "prod.parameters.json"
$groupName = "az204temp"

# AZ Client Version
az group create `
    --name $groupName  --location "East US"

# without Parameter File
az deployment group create `
    --name demo1 `
    --resource-group $groupName `
    --template-file $templateFile `
    --parameters storagePrefix=store storageSKU=Standard_LRS webAppName=demoapp

# with parameter file
az deployment group create `
    --name devenvironment `
    --resource-group $groupName `
    --template-file $templateFile `
    --parameters $parameterFile



# Powershell version 
New-AzResourceGroup `
    -Name $groupName `
    -Location "East US"


#version 1
New-AzResourceGroupDeployment `
    -Name addtags `
    -ResourceGroupName $groupName `
    -TemplateFile $templateFile `
    -storagePrefix "store" `
    -storageSKU Standard_LRS `
    -webAppName demoapp
  
#version 3
New-AzResourceGroupDeployment `
    -Name prodenvironment `
    -ResourceGroupName $groupName `
    -TemplateFile $templateFile `
    -TemplateParameterFile $parameterFile
