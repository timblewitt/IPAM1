using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$lzEnv = $Request.Query.Environment
if (-not $lzEnv) {
    $lzEnv = $Request.Body.InputObject.Environment
}
Write-Host "Env:" $lzEnv
$lzNumber = $Request.Query.Number
if (-not $lzNumber) {
    $lzNumber = $Request.Body.InputObject.Number
}
Write-Host "Number:" $lzNumber

$lzPrefix = 'z' + $lzEnv.ToLower()[0]
$lzStorageAccount = $env:lzStorageAccount
$lzTableName = 'lzim'
$ctx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzStorageAccount}).Context
$cloudTable = (Get-AzStorageTable –Name $lzTableName –Context $ctx).CloudTable
$partitionKey1 = "LZ"

# Add landing zone identifiers for: Staging
for ($row = 1 ; $row -le $lzNumber ; $row++){    
    $rowKey = $lzPrefix + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="$lzEnv";"Allocated"=$false;"Notes"=""}
}

$body1 = Get-AzTableRow -table $cloudTable | select RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body1
})
