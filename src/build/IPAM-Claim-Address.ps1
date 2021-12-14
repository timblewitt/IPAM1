
$lzName = 'p031abc'
$regionName = 'uksouth'
$regionId = 'uks'
$networkSize = 'Small'  # Small/Medium/Large
$vnetName = "vnet-$lzName-$regionId-01"

$faName = "fa-$lzName-$regionId-ipam"
$rgIpamName = "rg-$lzName-$regionId-ipam"
$rgNetworkName = "rg-$lzName-$regionId-network"

Set-AzContext -Subscription $subId
$subName = (Get-AzContext).Subscription.Name

If ((Get-AzVirtualNetwork -name $vnetName) -eq $null) {
    Write-Host "VNet $vnetName does not already exist in subscription $subName"
    $faId = (Get-AzWebApp -Name $faName -ResourceGroupName $rgIpamName).Id
    $registerFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/RegisterAddressSpace" -Action listkeys -Force).default
    $uriRegister = 'https://' + $faName + '.azurewebsites.net/api/RegisterAddressSpace?code=' + $registerFunctionKey
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

Write-Host "Creating VNet $vnetName in resource group $rgIpamName with network address $networkAddress"
$deploymentName = Get-Date -Format yyyyMMddHHmmss
New-AzDeployment -Name $deploymentName -Location $regionName -TemplateFile ./src/build/elz.bicep `
    -vnetName $vnetName `
    -rgNetworkName $rgNetworkName `
    -regionName $regionName `
    -vnetAddress $networkAddress `
    -snetWeb $snetWeb `
    -snetApp $snetApp `
    -snetDb $snetDb `
    -snetCgTool $snetCgTool `
    -snetEcsTool $snetEcsTool
}
Else {
    Write-Host "VNet $vnetName already exists in subscription $subName"
}
Start-Sleep 30
Write-Host "Updating storage table"
$updateFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/UpdateAddressSpace" -Action listkeys -Force).default
$uriUpdate = 'https://' + $faName + '.azurewebsites.net/api/UpdateAddressSpace?code=' + $updateFunctionKey
$params = @{
    'Uri'         = $uriUpdate
    'Method'      = 'GET'
}
$Result = Invoke-RestMethod @params
