
$elzRegionName = 'uksouth'
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $elzRegionName -Verbose -TemplateFile ./elz/src/build/infra/modules/mg.bicep 
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzManagementGroupDeployment -Name $deploymentName -Location $elzRegionName -ManagementGroupId 'Prod' -Verbose -TemplateFile ./elz/src/build/infra/modules/policy.bicep 
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzManagementGroupDeployment -Name $deploymentName -Location $elzRegionName -ManagementGroupId 'Prod' -Verbose -TemplateFile ./elz/src/build/infra/modules/policyrg.bicep 
  