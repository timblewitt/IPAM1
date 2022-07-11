using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$lzStorageAccount = $env:lzStorageAccount
$lzTableName = 'lzim'
$ctx = (Get-AzStorageAccount | where {$_.StorageAccountName -eq $lzStorageAccount}).Context
$cloudTable = (Get-AzStorageTable –Name $lzTableName –Context $ctx).CloudTable
$partitionKey1 = "LZ"

# Add landing zone identifiers for: Staging
for ($row = 1 ; $row -le 20 ; $row++){    
    $rowKey = 'zs' + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="Staging";"Allocated"=$false;"Notes"=""}
}

# Add landing zone identifiers for: Dev
for ($row = 1 ; $row -le 20 ; $row++){    
    $rowKey = 'zd' + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="Dev";"Allocated"=$false;"Notes"=""}
}

# Add landing zone identifiers for: Test
for ($row = 1 ; $row -le 20 ; $row++){    
    $rowKey = 'zt' + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="Test";"Allocated"=$false;"Notes"=""}
}

# Add landing zone identifiers for: QA
for ($row = 1 ; $row -le 20 ; $row++){    
    $rowKey = 'zq' + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="QA";"Allocated"=$false;"Notes"=""}
}

# Add landing zone identifiers for: Production
for ($row = 1 ; $row -le 20 ; $row++){    
    $rowKey = 'zp' + “{0:d4}” -f $row
    Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ($rowKey) -property @{"Environment"="Production";"Allocated"=$false;"Notes"=""}
}

$body1 = Get-AzTableRow -table $cloudTable | select RowKey

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body1
})
