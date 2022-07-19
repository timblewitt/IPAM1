using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
# Get the environment (e.g. production/test/dev/staging/QA) and the number of ids to add to the table for that environment
$lzEnv = $Request.Query.Environment
if (-not $lzEnv) {
    $lzEnv = $Request.Body.InputObject.Environment
}
$lzNumber = $Request.Query.Number
if (-not $lzNumber) {
    $lzNumber = $Request.Body.InputObject.Number
}

# Add LZ IDs to Azure storage table (storage account name is an application setting configured during function deployment)
$lzimStorageAccount = $env:lzimStorageAccount
$lzimTableName = 'lzim'
$lzimSaCtx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzimStorageAccount}).Context
$lzimTable = (Get-AzStorageTable –Name $lzimTableName –Context $lzimSaCtx).CloudTable
$lzimPartKey = "LZ"
$lzPrefix = 'z' + $lzEnv.ToLower()[0]

for ($row = 1 ; $row -le $lzNumber ; $row++){    
    $rowKey = $lzPrefix + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $lzimTable `
    -partitionKey $lzimPartKey `
    -rowKey ($rowKey) -property @{"Environment"="$lzEnv";"Allocated"=$false;"Notes"=""}
}

$results = Get-AzTableRow -table $lzimTable | select RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $results
})
