
$lzName = 'p031abc'
$regionId = 'uks'
$networkAddresses = @(  "10.189.0.0/22",
                        "10.189.64.0/22",
                        "10.189.128.0/22",
                        "10.189.192.0/22")

$faName = "fa-$lzName-$regionId-ipam"

Write-Output "Adding address spaces"
$faId = $faObj.Id
$addFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/AddAddressSpace" -Action listkeys -Force).default
Write-Output "Adding new address spaces to IPAM"
$uriAdd = 'https://' + $faName + '.azurewebsites.net/api/AddAddressSpace?code=' + $addFunctionKey
#$uriAdd = 'https://' + $faName + '.ase-p026abc-uks-ipam.p.azurewebsites.net/api/AddAddressSpace?code=' + $addFunctionKey
foreach ($nw in $networkAddresses) {
    Write-Output "Adding network $nw"
    $body = @{
        "NetworkAddress"=$nw
    } | ConvertTo-Json
    $params = @{
        'Uri'         = $uriAdd
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $body 
    }
    $Result = Invoke-RestMethod @params -ErrorAction SilentlyContinue
    Write-Output "Result of Invoke-RestMethod for network $nw :" $result
}
