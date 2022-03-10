
Describe "Landing Zone Tests" {
    Write-Host "Beginning user action tests" -ForegroundColor Blue
    Context "User Action Tests" {
        It "Each subnet should have at least 20% free IP addresses" {
            $errMsg = ""
            try {
                Write-Host "Test: Each subnet should have at least 20% free IP addresses" -ForegroundColor Cyan
                $maxSubnetUsage = 0
                $alertSubnetUsage = 80
                $subs = Get-AzSubscription 
                foreach ($Sub in $Subs) {
                    Write-Host "***************************"
                    Write-Host " "
                    $Sub.Name                 
                    Select-AzSubscription -SubscriptionName $Sub.Name
                
                    $VNETs = Get-AzVirtualNetwork 
                    foreach ($VNET in $VNETs) {
                        Write-Host "--------------------------"
                        Write-Host " "
                        Write-Host "   vNet: " $VNET.Name 
                        Write-Host "   AddressPrefixes: " ($VNET).AddressSpace.AddressPrefixes
                
                        $vNetExpanded = Get-AzVirtualNetwork -Name $VNET.Name -ResourceGroupName $VNET.ResourceGroupName -ExpandResource 'subnets/ipConfigurations' 
                
                        foreach($subnet in $vNetExpanded.Subnets)
                        {
                            Write-Host "       Subnet: " $subnet.Name
                            Write-Host "          Address Prefix " $subnet.AddressPrefix
                            $networkSize = [int]($subnet.AddressPrefix.Split("/")[1])
                            $usableAddresses = [math]::Pow(2, (32 - $networkSize)) - 5 - $subnet.IpConfigurations.Count
                            $connectedAddresses = $subnet.IpConfigurations.Count
                            $availableAddresses = $usableAddresses - $connectedAddresses
                            $subnetUsage = ([math]::Round($connectedAddresses/$availableAddresses*100,2))
                            Write-Host "          Useable IP addresses " $usableAddresses
                            Write-Host "          Connected devices " $connectedAddresses
                            Write-Host "          Available IP addresses " $availableAddresses
                            Write-Host "          Subnet IP usage (%)" $subnetUsage
                            if ($subnetUsage -gt $alertSubnetUsage) {
                                Write-Host "          WARNING: IP address shortage in subnet" $subnet.Name "of VNet" $VNET.Name -ForegroundColor Red
                            }
                            If ($subnetUsage -gt $maxSubnetUsage) {
                                $maxSubnetUsage = $subnetUsage
                            }
                            foreach($ipConfig in $subnet.IpConfigurations)
                            {
                                Write-Host "            " $ipConfig.PrivateIpAddress
                            }
                        }
                
                        Write-Host " " 
                    } 
                }
            }
            catch {
                Write-Host "Error listing resources"
                $errMsg = $_
                Write-Host $errMsg
            }
            $maxSubnetUsage | Should -BeLessThan $alertSubnetUsage    
        }
    }
}   
