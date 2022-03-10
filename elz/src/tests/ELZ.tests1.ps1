
Describe "Landing Zone Tests" {
    BeforeAll {
        $elzSubName = 'p156cga'
        $elzRegionName = 'uksouth'
        switch ($elzRegionName) {
          "uksouth" {$elzRegionId = 'uks'}
          "ukwest" {$elzRegionId = 'ukw'}
        }
        $elzVnetRg = "rg-$elzSubName-$elzRegionId-network"
        $elzVnetName = "vnet-$elzSubName-$elzRegionId-xx"
        $userId = (Get-AzContext).Account.Id
        $subId = (Get-AzContext).Subscription.Id
        $testSuffix = Get-Date -Format yyyyMMddHHmmss
        $rgTest = "rg-test-$testSuffix" 
        $vnetTest = "vnet-test-$testSuffix"
        $stTest = "st$testSuffix"
        $pipTest = "pip-test-$testSuffix"
    }

    Write-Host "Beginning user action tests" -ForegroundColor Blue

    Context "User Action Tests" {
        It "$($userId) should be able to list resources in the landing zone" -Tag "ELZAdmin", "ELZReadOnly" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should be able to list resources" -ForegroundColor Cyan
                Write-Host "Attempting to list all resources in the landing zone"
                Get-AzResource -ErrorAction Stop
            }
            catch {
                Write-Host "Error listing resources"
                $errMsg = $_
                Write-Host $errMsg
            }
            $errMsg | Should -Be ""        
        }

        It "$($userId) should NOT be able to list resources in the landing zone" -Tag "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to list resources" -ForegroundColor Cyan
                Write-Host "Attempting to list all resources in the landing zone"
                Get-AzResource -ErrorAction Stop
            }
            catch {
                Write-Host "Error listing resources"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should be able to create a resource group" -Tag "ELZAdmin" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should be able to create a resource group" -ForegroundColor Cyan
                Write-Host "Attempting to create a resource group"
                New-AzResourceGroup -Name $rgTest -Location $elzRegionName -Force -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating resource group"
                $errMsg = $_
                Write-Host $errMsg
            }
            $errMsg | Should -Be ""        
        }

        It "$($userId) should NOT be able to create a resource group" -Tag "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to create a resource group" -ForegroundColor Cyan
                Write-Host "Attempting to create a resource group"
                New-AzResourceGroup -Name $rgTest -Location $elzRegionName -Force -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating resource group"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should be able to create an ALLOWED resource e.g. storage account" -Tag "ELZAdmin" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should be able to create an ALLOWED resource" -ForegroundColor Cyan
                Write-Host "Attempting to create a storage account"
                New-AzStorageAccount -Name $stTest -ResourceGroupName $rgTest -Location $elzRegionName -SkuName Standard_LRS -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating storage account"
                $errMsg = $_
                Write-Host $errMsg
            }
            $errMsg | Should -Be ""        
        }

        It "$($userId) should NOT be able to create an ALLOWED resource e.g. storage account" -Tag "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to create an ALLOWED resource" -ForegroundColor Cyan
                Write-Host "Attempting to create a storage account"
                New-AzStorageAccount -Name $stTest -ResourceGroupName $rgTest -Location $elzRegionName -SkuName Standard_LRS -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating storage account"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should NOT be able to create a DISALLOWED resource e.g. public IP address" -Tag "ELZAdmin", "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to create a DISALLOWED resource" -ForegroundColor Cyan
                Write-Host "Attempting to create a public IP address"
                New-AzPublicIpAddress -Name $pipTest -ResourceGroupName $rgTest -Location $elzRegionName -Sku Standard -AllocationMethod Static -Zone {} -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating public IP address"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should NOT be able to create a network resource" -Tag "ELZAdmin", "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to create a network resource" -ForegroundColor Cyan
                Write-Host "Attempting to create a virtual network (VNet)"
                New-AzVirtualNetwork -Name $vnetTest -ResourceGroupName $rgTest -Location $elzRegionName -AddressPrefix "10.10.10.0/24" -Force -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating VNet"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should NOT be able to create a resource in the network resource group" -Tag "ELZAdmin", "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to create a resource in the network resource group" -ForegroundColor Cyan
                Write-Host "Attempting to create a virtual network (VNet)"
                New-AzVirtualNetwork -Name $vnetTest -ResourceGroupName $rgTest -Location $elzRegionName -AddressPrefix "10.10.10.0/24" -Force -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating VNet"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }

        It "$($userId) should be able to create any resource in the network resource group" -Tag "NetworkAdmin" {
            $errMsg = ""
            try {
                Write-Host "Attempting to create a virtual network (VNet)"
                New-AzVirtualNetwork -Name $elzVnetName -ResourceGroupName $elzVnetRg -Location $elzRegionName -AddressPrefix "10.10.10.0/24" -Force -ErrorAction Stop
            }
            catch {
                Write-Host "Error creating VNet"
                $errMsg = $_
                Write-Host $errMsg
            }
            $errMsg | Should -Be ""        
        }
        
        It "$($userId) should be able to assign a policy" -Tag "ELZAdmin" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should be able to assign a policy" -ForegroundColor Cyan
                Write-Host "Attempting to assign a policy"
                $rgId = (Get-AzResourceGroup -Name $rgTest -Location $elzRegionName).ResourceId
                $polDef = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Audit VMs that do not use managed disks' }                
                New-AzPolicyAssignment -Name 'audit-vm-manageddisks' -DisplayName 'Audit VMs without managed disks Assignment' -Scope $rgId -PolicyDefinition $polDef -ErrorAction Stop
            }
            catch {
                Write-Host "Error assigning a policy"
                $errMsg = $_
                Write-Host $errMsg
            }
            $errMsg | Should -Be ""        
        }

        It "$($userId) should NOT be able to assign a policy" -Tag "ELZReadOnly", "JaneBloggs" {
            $errMsg = ""
            try {
                Write-Host "Test: $userId should NOT be able to assign a policy" -ForegroundColor Cyan
                Write-Host "Attempting to assign a policy"
                $polDef = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Audit VMs that do not use managed disks' } -ErrorAction Stop             
                New-AzPolicyAssignment -Name 'audit-vm-manageddisks' -DisplayName 'Audit VMs without managed disks Assignment' -Scope "/subscriptions/$subId" -PolicyDefinition $polDef -ErrorAction Stop
            }
            catch {
                Write-Host "Error assigning a policy"
                $errMsg = $_
#                Write-Host $errMsg
            }
            $errMsg | Should -Not -Be ""        
        }
    }

#    Context "Resource Tests" {
#        It "ItName" {
#            
#        }
#    }

    AfterAll {
        Write-Host "Cleaning up resources" -ForegroundColor Blue
        try {
            Write-Host "Deleting resource group"
            Remove-AzResourceGroup -Name $rgTest -Force -ErrorAction Stop
        }
        catch {
            Write-Host "Error deleting resource group"
            Write-Host $_
        }
    }
}   
