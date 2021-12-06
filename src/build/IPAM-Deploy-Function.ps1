
$lzName = 'p022abc'
$regionName = 'uksouth'
$regionId = 'uks'
$functionZipPath = "./src/ipam.zip"

###  Update secrets  ###
$clientId = "xxx"
$clientSecret = "xxx"
$subId = "xxx"
$tenantId ="xxx"

$faName = "fa-$lzName-$regionId-ipam"
$rgIpamName = "rg-$lzName-$regionId-ipam"

Write-Output "Generating function zip file"
Compress-Archive -Path ./src/function/* -DestinationPath $functionZipPath -Force

Write-Output "Deploying Azure resources"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/ipam.bicep -lzName $lzName -regionName $regionName -regionId $regionId -rgIpamName $rgIpamName 
Start-Sleep 60

Write-Output "Publishing function to function app"
$faObj = Get-AzWebApp -Name $faName -ResourceGroupName $rgIpamName
Publish-AzWebApp -WebApp $faObj -ArchivePath $functionZipPath -Force
Start-Sleep 30

Write-Output "Configuring app settings"
$saName = (Get-AzStorageAccount -ResourceGroupName $rgIpamName | Where-Object {$_.StorageAccountName -like '*ipam'}).StorageAccountName
$saAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $rgIpamName -AccountName $saName | Where-Object {$_.KeyName -eq "key1"}).Value
$saConfig = "DefaultEndpointsProtocol=https;AccountName=$saName;AccountKey=$saAccountKey;EndpointSuffix=core.windows.net"
$appSettingsOld = ($faObj.SiteConfig.AppSettings | ForEach-Object { $h = @{} } { $h[$_.Name] = $_.Value } { $h })
$appSettingsNew = @{    AIPASClientId = $clientId
                        AIPASClientSecret = $clientSecret
                        AIPASResourceGroupName = $rgIpamName
                        AIPASStorageAccountName = $saName
                        AIPASSubscriptionId = $subId
                        AIPASTenantId = $tenantId
                    }
#                    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = $saConfig
                    #                    AzureWebJobsStorage = $saConfig
Set-AzWebApp -ResourceGroupName $rgIpamName -Name $faName -AppSettings ($appSettingsOld + $appSettingsNew)
Start-Sleep 10

Restart-AzWebApp -ResourceGroupName $rgIpamName -Name $faName
