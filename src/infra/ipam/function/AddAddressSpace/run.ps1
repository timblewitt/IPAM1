using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function AddAddressSpace processed a request."

# Get TriggerMetadata
Write-Verbose ($TriggerMetadata | Convertto-Json) -Verbose

Write-Verbose ('Request Object: {0}' -f ($Request | convertto-json)) -Verbose

# Interact with query parameters or the body of the request.
$NetworkAddress = $Request.Query.NetworkAddress
if (-not $NetworkAddress) {
    $NetworkAddress = $Request.Body.NetworkAddress
}
$NwEnvironment = $Request.Query.NwEnvironment
if (-not $NwEnvironment) {
    $NwEnvironment = $Request.Body.NwEnvironment
}
$NwRegion = $Request.Query.NwRegion
if (-not $NwRegion) {
    $NwRegion = $Request.Body.NwRegion
}

if ($NetworkAddress) {
    try {
        $params = @{
            'StorageAccountName' = $env:AIPASStorageAccountName
            'StorageTableName'   = 'ipam'
            'TenantId'           = $env:AIPASTenantId
            'SubscriptionId'     = $env:AIPASSubscriptionId
            'ResourceGroupName'  = $env:AIPASResourceGroupName
            'PartitionKey'       = 'IPAM'
            'ClientId'           = $env:AIPASClientId
            'ClientSecret'       = $env:AIPASClientSecret
            'NetworkAddress'     = $NetworkAddress
            'NwEnvironment'      = $NwEnvironment
            'NwRegion'           = $NwRegion
        }
        $Body = Add-AddressSpace @params -ErrorAction Stop
        $StatusCode = [HttpStatusCode]::OK
    }
    catch {
        $StatusCode = [HttpStatusCode]::BadRequest
        $Body = $_.Exception.Message
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $StatusCode
        Body       = $Body
    })