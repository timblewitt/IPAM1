using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
# Get the environment (e.g. production/test/dev/staging/QA) for the requested id and any associated notes that should be recorded.
$lzEnv = $Request.Query.Environment
if (-not $lzEnv) {
    $lzEnv = $Request.Body.InputObject.Environment
}$lzNotes = $Request.Query.Notes
if (-not $lzNotes) {
    $lzNotes = $Request.Body.InputObject.Notes
}

# Get next free (Allocated = false) LZ ID in Azure Storage tale for given environment.
# The storage account name is an application setting configured during function deployment.
$lzimStorageAccount = $env:lzimStorageAccount
$lzimTableName = 'lzim'
$lzimSaCtx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzimStorageAccount}).Context
$lzimTable = (Get-AzStorageTable –Name $lzimTableName –Context $lzimSaCtx).CloudTable
$freeLzId = Get-AzTableRow -table $lzimTable | where {($_.Environment -eq $lzEnv) -and ($_.Allocated -eq $false)} | select -First 1 
$freeLzId.Allocated = $true
$freeLzId.Notes = $lzNotes
$freeLzId | Update-AzTableRow -Table $lzimTable 
$results = $freeLzId.RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $results
})
