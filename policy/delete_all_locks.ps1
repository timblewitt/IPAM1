# Delete all resource locks that are protecting the network resource group
# This script executes across subscribptions

# The inscope resource groups are obtained by reading the rg_main_lab_params.json parameter file
# This is the same parameter that sets the resource locks, using bicep

# The locks are deleted prior to running the bicep policy deployment

# Written by the Platform enablement team 06/01/2022
# Version 1.0.0

# Retrieve parameter file
param(
    [string]$paramFile = '.\policy\rg_main_lab_params.json'
)
$JsonParams = Get-Content $paramFile | ConvertFrom-Json

#  Unpack the properties values in the JSon file
$JsonParams.PSObject.Properties | ForEach-Object { 
    New-Variable -Name $_.Name -Value $_.Value -Force
}

# Lock Name
$lockName = "rgReadOnlyLock" 

# Loop to remove inscope locks
$parameters.networksInscopeResourceGroups.value | ForEach-Object { 
    $Error.Clear()
    $resourceid = "/subscriptions/" + $_.subid + "/resourceGroups/" + $_.resourcegroup + "/providers/Microsoft.Authorization/locks/" + $lockName
    Get-AzResourceLock -Lockid $resourceid -ErrorAction SilentlyContinue
    if ($Error[0] -like "*could not be found*") { 
        Write-Output "Lock is not set "
    }
    else {
        Remove-AzResourceLock -LockId $resourceid -Force 
    }
}
# End Of Script