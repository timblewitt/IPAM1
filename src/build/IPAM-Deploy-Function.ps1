
$functionArchivePath = "C:\Temp\ipam.zip"
$lzName = 'p008abc'
$regionName = 'uksouth'
$regionId = 'uks'
$clientId = "xxx"
$clientSecret = "xxx"
$subId = "xxx"
$tenantId ="xxx"

$faName = "fa-$lzName-$regionId-ipam"
$rgName = "rg-$lzName-$regionId-ipam"

Write-Output "Deploying Azure resources"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/ipam.bicep -lzName $lzName -regionName $regionName -regionId $regionId 

Write-Output "Publishing function to function app"
$faObj = Get-AzWebApp -Name $faName -ResourceGroupName $rgName
Publish-AzWebApp -WebApp $faObj -ArchivePath $functionArchivePath -Force

Write-Output "Configuring app settings"
$saName = (Get-AzStorageAccount -ResourceGroupName $rgName | Where-Object {$_.StorageAccountName -like '*ipam'}).StorageAccountName 
$appSettingsOld = ($faObj.SiteConfig.AppSettings | ForEach-Object { $h = @{} } { $h[$_.Name] = $_.Value } { $h })
$appSettingsNew = @{    AIPASClientId = $clientId
                        AIPASClientSecret = $clientSecret
                        AIPASResourceGroupName = $rgName
                        AIPASStorageAccountName = $saName
                        AIPASSubscriptionId = $subId
                        AIPASTenantId = $tenantId
                    }
Set-AzWebApp -ResourceGroupName $rgName -Name $faName -AppSettings ($appSettingsOld + $appSettingsNew)
