
$lzName = 'p034cgc'
$lzIpamName = 'p001ecs'
$regionName = 'uksouth'
$regionId = 'uks'
$networkSize = 'Small'  # Small/Medium/Large

$vnetName = "vnet-$lzName-$regionId-01"
$rgNetworkName = "rg-$lzName-$regionId-network"
$rgSharedSvcsName = "rg-$lzName-$regionId-sharedsvcs"

$faIpamName = "fa-$lzIpamName-$regionId-ipam"
$rgIpamName = "rg-$lzIpamName-$regionId-ipam"

$subName = 'Azure Landing Zone'
#$subName = $lzName
Set-AzContext -SubscriptionName $subName

If ((Get-AzVirtualNetwork -name $vnetName -ResourceGroupName $rgNetworkName -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "VNet $vnetName does not already exist in subscription $subName"
    $faId = (Get-AzWebApp -Name $faIpamName -ResourceGroupName $rgIpamName).Id
    $registerFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/RegisterAddressSpace" -Action listkeys -Force).default
    $uriRegister = 'https://' + $faIpamName + '.azurewebsites.net/api/RegisterAddressSpace?code=' + $registerFunctionKey
    $body = @{
        'InputObject' = @{
            'ResourceGroup' = $rgIpamName
            'VirtualNetworkName' = $vnetName
        }
    } | ConvertTo-Json
    $params = @{
        'Uri'         = $uriRegister
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $Body
    }
    $Result = Invoke-RestMethod @params
    $networkAddress = $Result.NetworkAddress
}
Else {
    Write-Host "VNet $vnetName already exists in subscription $subName"
    $vnet = Get-AzVirtualNetwork -name $vnetName -ResourceGroupName $rgNetworkName
    $networkAddress = $vnet.AddressSpace.AddressPrefixes[0]
}

    $vnetOctet1 = $networkAddress.Split(".")[0]
    $vnetOctet2 = $networkAddress.Split(".")[1]
    $vnetOctet3 = $networkAddress.Split(".")[2]

    if ($networkSize -eq 'Small') {
        $snetWeb = $vnetOctet1 + "." + $vnetOctet2 + "." + $vnetOctet3 + ".0/25"
        $snetApp = $vnetOctet1 + "." + $vnetOctet2 + "." + $vnetOctet3 + ".128/25"
        $snetDb = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 1).ToString() + ".0/25"
        $snetCgTool = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 1).ToString() + ".128/26"
        $snetEcsTool = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 1).ToString() + ".192/26"
    }
    else {
        $snetWeb = $vnetOctet1 + "." + $vnetOctet2 + "." + $vnetOctet3 + ".0/24"
        $snetApp = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 1).ToString() + ".0/24"
        $snetDb = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 2).ToString() + ".0/24"
        $snetCgTool = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 3).ToString() + ".0/25"
        $snetEcsTool = $vnetOctet1 + "." + $vnetOctet2 + "." + ([int]$vnetOctet3 + 3).ToString() + ".128/25"
    }

Write-Host "Deploying landing zone"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/bicep/elz.bicep `
    -vnetName $vnetName `
    -rgNetworkName $rgNetworkName `
    -rgSharedSvcsName $rgSharedSvcsName `
    -regionName $regionName `
    -vnetAddress $networkAddress `
    -snetWeb $snetWeb `
    -snetApp $snetApp `
    -snetDb $snetDb `
    -snetCgTool $snetCgTool `
    -snetEcsTool $snetEcsTool
Start-Sleep 30

Write-Host "Updating storage table"
$updateFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/UpdateAddressSpace" -Action listkeys -Force).default
$uriUpdate = 'https://' + $faIpamName + '.azurewebsites.net/api/UpdateAddressSpace?code=' + $updateFunctionKey
$params = @{
    'Uri'         = $uriUpdate
    'Method'      = 'GET'
}
$Result = Invoke-RestMethod @params
