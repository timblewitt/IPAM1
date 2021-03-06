
$networkAddresses = @(  "10.188.0.0/22",
                        "10.188.64.0/22",
                        "10.188.128.0/22",
                        "10.188.192.0/22",
                        "10.189.0.0/22",
                        "10.189.64.0/22",
                        "10.189.128.0/22",
                        "10.189.192.0/22",
                        "10.190.0.0/21",
                        "10.190.32.0/21",
                        "10.190.64.0/21",
                        "10.190.96.0/21")             
$mgmtSubName = "p001mgt"
$connSubName = "p001con"
$regionName = "uksouth"
$regionId = "uks"
$functionZipPath = "./src/ipam.zip"
$aseDeploy = $false

$aseVnetName = "vnet-$connSubName-$regionId-01"
$aseVnetAddress = "10.50.0.0/16"
$aseSnetName = 'snet-ipam'
$aseSnetAddress = "10.50.10.0/24"

###  Update secrets  ###
$clientId = "3a1a7536-2fc8-4ee3-8214-86a2a676f0d5"
$clientSecret = "2CM7Q~aVam~OmQ12eFhPrY5GOcYLUxeZq56x0"
$subId = "ef620d24-2d5d-4e63-aaf9-e42cafb44dfb"

$tenantId = (Get-AzSubscription -SubscriptionId $subId).tenantId

$faName = "fa-$connSubName-$regionId-ipam"
$rgNetworkName = "rg-$connSubName-$regionId-ipam"
$rgManagementName = "rg-$mgmtSubName-$regionId-management"

Write-Output "Generating function zip file"
Compress-Archive -Path ./src/function/* -DestinationPath $functionZipPath -Force

Write-Output "Deploying Azure resources"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/ipam/ipam.bicep `
    -connSubName $connSubName -regionName $regionName -regionId $regionId -mgmtSubName $mgmtSubName `
    -rgNetworkName $rgNetworkName -rgManagementName $rgManagementName -aseDeploy $aseDeploy `
    -aseVnetName $aseVnetName -aseVnetAddress $aseVnetAddress -aseSnetName $aseSnetName -aseSnetAddress $aseSnetAddress
Start-Sleep 60

Write-Output "Publishing function to function app"
$faObj = Get-AzWebApp -Name $faName -ResourceGroupName $rgNetworkName
Publish-AzWebApp -WebApp $faObj -ArchivePath $functionZipPath -Force
Start-Sleep 30

Write-Output "Configuring app settings"
$saName = (Get-AzStorageAccount -ResourceGroupName $rgNetworkName | Where-Object {$_.StorageAccountName -like '*ipam'}).StorageAccountName
$appSettingsOld = ($faObj.SiteConfig.AppSettings | ForEach-Object { $h = @{} } { $h[$_.Name] = $_.Value } { $h })
$appSettingsNew = @{AIPASClientId = $clientId
                    AIPASClientSecret = $clientSecret
                    AIPASResourceGroupName = $rgNetworkName
                    AIPASStorageAccountName = $saName
                    AIPASSubscriptionId = $subId
                    AIPASTenantId = $tenantId
                    }
Set-AzWebApp -ResourceGroupName $rgNetworkName -Name $faName -AppSettings ($appSettingsOld + $appSettingsNew)
Start-Sleep 10

Restart-AzWebApp -ResourceGroupName $rgNetworkName -Name $faName
Start-Sleep 60

Write-Output "Adding address spaces"
$faId = $faObj.Id
$addFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/AddAddressSpace" -Action listkeys -Force).default
Write-Output "Adding new address spaces to IPAM"
if ($aseDeploy) {
    $uriAdd = 'https://' + $faName + '.ase-' + $connSubName + '-' + $regionId + '-ipam.p.azurewebsites.net/api/AddAddressSpace?code=' + $addFunctionKey
}
else {
    $uriAdd = 'https://' + $faName + '.azurewebsites.net/api/AddAddressSpace?code=' + $addFunctionKey
}
foreach ($nw in $networkAddresses) {
    Write-Output "Adding network $nw"
    $body = @{
        "NetworkAddress"=$nw
    } | ConvertTo-Json
    $params = @{
        'Uri'         = $uriAdd
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $body 
    }
    $Result = Invoke-RestMethod @params -ErrorAction SilentlyContinue
    Write-Output "Result of Invoke-RestMethod for network $nw :" $result
}
