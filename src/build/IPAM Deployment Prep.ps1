# IPAM Deployment Preparation
#   Create resource group
#   Create storage account
#   Create service principal

$subscriptionName = 'Azure Landing Zone'
$rgName = 'rg-ipam-uksouth-01'
$rgRegion = 'uksouth'
$roleDefinitionName = "Storage Account Contributor"
$ADApplicationName = "IPAM1"
$plainPassword = "xxx"

Connect-AzAccount
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName
$subscriptionId = $subscription.Id
$tenantId = $subscription.tenantId
Write-Host "Setting context to subscription $subscriptionId in tenant $tenantId"
Set-AzContext -SubscriptionId $subscriptionId -TenantId $tenantID

Write-Host "Creating resource group $rgName in region $rgRegion"
New-AzResourceGroup -Name $rgName -Location $rgRegion

Write-Host "Creating storage account"
$params = @{
    'ResourceGroupName' = $rgName
    'Mode' = 'Incremental'
    'Name' = 'IPAM_Deployment'
    'TemplateFile' = '.\src\templates\azuredeploy.json'
    'TemplateParameterFile' = '.\src\templates\azuredeploy.parameters.json'
}
New-AzResourceGroupDeployment @params

Write-Host "Storage account created"

Write-Host "Creating app registration $ADApplicationName"
$password = ConvertTo-SecureString $plainPassword  -AsPlainText -Force
New-AzADApplication -DisplayName $ADApplicationName -HomePage "https://www.ipam.test" -IdentifierUris "https://www.ipam.test" -Password $password -OutVariable app

Write-Host "Creating service principal"
$scope = Get-AzResourceGroup -Name $rgName
New-AzADServicePrincipal -ApplicationId $($app.ApplicationId) -Role $roleDefinitionName -Scope $($scope.ResourceId)

Write-Host "Assigning read permissions for retrieving VNet info from Resource Graph"
New-AzRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $($app.ApplicationId.Guid) -Scope ('/subscriptions/{0}' -f $SubscriptionId)
Get-AzADApplication -DisplayNameStartWith $ADApplicationName -OutVariable app
Get-AzADServicePrincipal -ServicePrincipalName $($app.ApplicationId.Guid) -OutVariable SPN

Write-Host "Store in GitHub Settings - AZURE_CREDENTIALS"
[ordered]@{
    "clientId"       = "$($app.ApplicationId)"
    "clientSecret"   = "$PlainPassword"
    "subscriptionId" = "$($subscriptionId)"
    "tenantId"       = "$($tenantID)"
} | Convertto-json

Write-Host "Creating local environment variables"
$storageAccountName = Get-AzStorageAccount -ResourceGroupName $rgName
[Environment]::SetEnvironmentVariable("AIPASClientId", "$($app.ApplicationId)", "User")
[Environment]::SetEnvironmentVariable("AIPASClientSecret", "$plainPassword", "User")
[Environment]::SetEnvironmentVariable("AIPASSubscriptionId", "$($subscriptionId)", "User")
[Environment]::SetEnvironmentVariable("AIPAStenantId", "$($tenantID)", "User")
[Environment]::SetEnvironmentVariable("AIPASResourceGroupName", $ResourceGroupName, "User")
[Environment]::SetEnvironmentVariable("AIPASStorageAccountName", $storageAccountName, "User")

Write-Host "Deployment preparation complete"
# Restart VSCode to have access to the environment variables
