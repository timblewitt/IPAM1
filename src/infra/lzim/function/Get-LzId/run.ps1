using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Get TriggerMetadata
Write-Host ($TriggerMetadata | Convertto-Json) -Verbose

Write-Host ('Request Object: {0}' -f ($Request | convertto-json)) -Verbose

# Interact with query parameters or the body of the request.
Write-Host "Query Env:" $Request.Query.Env1
Write-Host "Query Body:" $Request.Body.Env1
$lzEnv = $Request.Query.Env1
Write-Host "Env Query:" $lzEnv
if (-not $lzEnv) {
    $lzEnv = $Request.Body.Env1
    Write-Host "Env Body:" $lzEnv
}

$lzStorageAccount = $env:lzStorageAccount
Write-Host $lzStorageAccount
$lzTableName = 'lzim'
$ctx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzStorageAccount}).Context
$cloudTable = (Get-AzStorageTable –Name $lzTableName –Context $ctx).CloudTable

$freeLzId = Get-AzTableRow -table $cloudTable | where {($_.Environment -eq $lzEnv) -and ($_.Allocated -eq $false)} | select -First 1 
Write-Host "Free LzId:" $freeLzId
$freeLzId.Allocated = $true
$freeLzId | Update-AzTableRow -Table $cloudTable 
Write-Host "RowKey:" $freeLzId.RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $freeLzId.RowKey
})
