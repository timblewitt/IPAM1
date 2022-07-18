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
$lzNumber = $Request.Query.Number
if (-not $lzNumber) {
    $lzNumber = $Request.Body.InputObject.Number
}

# Add LZ IDs to Azure storage table
$lzimStorageAccount = $env:lzimStorageAccount
$lzimTableName = 'lzim'
$lzimSaCtx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzimStorageAccount}).Context
$lzimTable = (Get-AzStorageTable –Name $lzimTableName –Context $lzimSaCtx).CloudTable
$partitionKey1 = "LZ"
$lzPrefix = 'z' + $lzEnv.ToLower()[0]

for ($row = 1 ; $row -le $lzNumber ; $row++){    
    $rowKey = $lzPrefix + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $lzimTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="$lzEnv";"Allocated"=$false;"Notes"=""}
}

$results = Get-AzTableRow -table $lzimTable | select RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $results
})
