using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
#$name = $Request.Query.Name
#if (-not $name) {
#    $name = $Request.Body.Name
#}
$lzEnv = $Request.Query.Environment

#Set-AzContext -SubscriptionName 'Azure Landing Zone'
$lzStorageAccount = $env:lzStorageAccount
$lzTableName = 'lzim'
$ctx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzStorageAccount}).Context
$cloudTable = (Get-AzStorageTable –Name $lzTableName –Context $ctx).CloudTable

$freeLzId = Get-AzTableRow -table $cloudTable | where {($_.Environment -eq $lzEnv) -and ($_.Allocated -eq $false)} | select -First 1 
$freeLzId.Allocated = $true
$freeLzId | Update-AzTableRow -Table $cloudTable 

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $freeLzId.RowKey
})
