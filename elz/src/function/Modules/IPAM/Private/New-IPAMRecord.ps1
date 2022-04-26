Function New-IPAMRecord {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $NetworkAddress,
        [Parameter(Mandatory = $true)]
        [string]
        $NwEnvironment,
        [Parameter(Mandatory = $true)]
        [string]
        $NwRegion
    )

    process {
        [PSCustomObject]@{
            'PartitionKey'         = 'ipam'
            'RowKey'               = $(New-Guid).Guid
            'Allocated'            = 'False'
            'VirtualNetworkName'   = $null
            'NetworkAddress'       = $NetworkAddress
            'Environment'          = $NwEnvironment
            'Region'               = $NwRegion
            'Notes'                = 'Added by Deploy-IPAM'
            'Subscription'         = $null
            'ResourceGroup'        = $null
            'CreatedDateTime'      = $(Get-Date -f o)
            'LastModifiedDateTime' = $(Get-Date -f o)
        }
    }
}