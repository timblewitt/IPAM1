
$elzSubName = 'p043cgd'  # Name of new landing zone subscription
$elzRegionName = 'uksouth'  # Azure region to deploy landing zone resources
$elzRegionId = 'uks'  # Region identifier to use in landing zone resource naming
$elzVnetSize = 'Small'  # Small/Medium/Large
$connSubName = 'p001ecs'  # Name of connectivity (network) subscription
$connRegionId = 'uks'  # Region identifier used in naming central network resources

$elzVnetName = "vnet-$elzSubName-$elzRegionId-01"
$elzVnetRg = "rg-$elzSubName-$elzRegionId-network"
$elzManagementRg = "rg-$elzSubName-$elzRegionId-management"

$faIpamName = "fa-$connSubName-$connRegionId-ipam"
$faIpamRg = "rg-$connSubName-$connRegionId-network"

$subName = 'Azure Landing Zone'  # Temporary for testing 
#$subName = $elzSubName
Set-AzContext -SubscriptionName $subName

If ((Get-AzVirtualNetwork -name $elzVnetName -ResourceGroupName $elzVnetRg -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "VNet $elzVnetName does not already exist in subscription $subName"
    $faId = (Get-AzWebApp -Name $faIpamName -ResourceGroupName $faIpamRg).Id
    $registerFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/RegisterAddressSpace" -Action listkeys -Force).default
    $uriRegister = 'https://' + $faIpamName + '.azurewebsites.net/api/RegisterAddressSpace?code=' + $registerFunctionKey
    $body = @{
        'InputObject' = @{
            'ResourceGroup' = $elzVnetRg
            'VirtualNetworkName' = $elzVnetName
        }
    } | ConvertTo-Json
    $params = @{
        'Uri'         = $uriRegister
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $Body
    }
    $Result = Invoke-RestMethod @params
    $elzVnetAddress = $Result.NetworkAddress
}
Else {
    Write-Host "VNet $elzVnetName already exists in subscription $subName"
    $vnet = Get-AzVirtualNetwork -name $elzVnetName -ResourceGroupName $elzVnetRg
    $elzVnetAddress = $vnet.AddressSpace.AddressPrefixes[0]
}

    $vnetOctet1 = $elzVnetAddress.Split(".")[0]
    $vnetOctet2 = $elzVnetAddress.Split(".")[1]
    $vnetOctet3 = $elzVnetAddress.Split(".")[2]

    if ($elzVnetSize -eq 'Small') {
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
New-AzDeployment -Name $deploymentName -Location $elzRegionName -Verbose -TemplateFile ./src/build/elz/elz.bicep `
    -elzSubName $elzSubName `
    -elzRegionId $elzRegionId `
    -elzVnetName $elzVnetName `
    -elzVnetRg $elzVnetRg `
    -elzVnetAddress $elzVnetAddress `
    -elzManagementRg $elzManagementRg `
    -elzRegionName $elzRegionName `
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
