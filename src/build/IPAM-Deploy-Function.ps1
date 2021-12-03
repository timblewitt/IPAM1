
$lzName = 'p014abc'
$regionName = 'uksouth'
$regionId = 'uks'
$functionZipPath = "./src/ipam.zip"
#$functionArchivePath = "C:\Temp\ipam.zip"

###  Update secrets  ###
$clientId = "xxx"
$clientSecret = "xxx"
$subId = "xxx"
$tenantId ="xxx"

$faName = "fa-$lzName-$regionId-ipam"
$rgIpamName = "rg-$lzName-$regionId-ipam"

Write-Output "Generating function zip file"
Compress-Archive -LiteralPath ./src/function -DestinationPath $functionZipPath -Force

Write-Output "Deploying Azure resources"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/ipam.bicep -lzName $lzName -regionName $regionName -regionId $regionId -rgIpamName $rgIpamName 

Write-Output "Publishing function to function app"
$faObj = Get-AzWebApp -Name $faName -ResourceGroupName $rgIpamName
Publish-AzWebApp -WebApp $faObj -ArchivePath $functionArchivePath -Force

Write-Output "Configuring app settings"
$saName = (Get-AzStorageAccount -ResourceGroupName $rgIpamName | Where-Object {$_.StorageAccountName -like '*ipam'}).StorageAccountName 
$appSettingsOld = ($faObj.SiteConfig.AppSettings | ForEach-Object { $h = @{} } { $h[$_.Name] = $_.Value } { $h })
$appSettingsNew = @{    AIPASClientId = $clientId
                        AIPASClientSecret = $clientSecret
                        AIPASResourceGroupName = $rgIpamName
                        AIPASStorageAccountName = $saName
                        AIPASSubscriptionId = $subId
                        AIPASTenantId = $tenantId
                    }
Set-AzWebApp -ResourceGroupName $rgIpamName -Name $faName -AppSettings ($appSettingsOld + $appSettingsNew)
