
# Run Pester tests for a landing zone

$elzSubName = 'p156cga'  # Landing zone subscription name

$upnAadAdmin = 'timb@risual.com'  # Account with permissions to update AAD group membership
$upnElzAdmin = 'tu-elzadmin@johnpbutlerhotmailco.onmicrosoft.com'  # Account for managing resources and policies in the LZ
$upnElzReadOnly = 'tu-elzreadonly@johnpbutlerhotmailco.onmicrosoft.com'  # Account for browsing LZ resources
$upnJaneBloggs = 'tu-janebloggs@johnpbutlerhotmailco.onmicrosoft.com'  # Account in AAD but with no assigned roles in LZ

# Add test user accounts to LZ AAD groups for testing correct permissions
$credsAadAdmin = Get-Credential -UserName $upnAadAdmin
Connect-AzAccount -Credential $credsAadAdmin -TenantId 'f815abd7-61ed-4b6a-8d1e-bf7cdca6d70c'
Add-AzADGroupMember -MemberUserPrincipalName $upnElzAdmin -TargetGroupDisplayName "rbac-$elzSubName-elzadmin"
Add-AzADGroupMember -MemberUserPrincipalName $upnElzReadOnly -TargetGroupDisplayName "rbac-$elzSubName-elzreadonly"

# Test LZ Administrator
$credsELZAdmin = Get-Credential -UserName $upnElzAdmin
Connect-AzAccount -Credential $credsELZAdmin
Invoke-Pester -TagFilter "ELZAdmin" -Output Detailed -Path .\elz\src\tests\ELZ.tests1.ps1

# Test LZ browser
$credsELZRO = Get-Credential -UserName $upnElzReadOnly
Connect-AzAccount -Credential $credsELZRO
Invoke-Pester -TagFilter "ELZReadOnly" -Output Detailed -Path .\elz\src\tests\ELZ.tests1.ps1

# Test generic user with no assigned privilege in LZ
$credsJaneBloggs = Get-Credential -UserName $upnJaneBloggs
Connect-AzAccount -Credential $credsJaneBloggs
Invoke-Pester -TagFilter "JaneBloggs" -Output Detailed -Path .\elz\src\tests\ELZ.tests1.ps1

# Tidy up test user accounts from LZ AAD groups
$credsAadAdmin = Get-Credential -UserName $upnAadAdmin
Connect-AzAccount -Credential $credsAadAdmin -TenantId 'f815abd7-61ed-4b6a-8d1e-bf7cdca6d70c'
Remove-AzADGroupMember -MemberUserPrincipalName $upnElzAdmin -GroupDisplayName "rbac-$elzSubName-elzadmin"
Remove-AzADGroupMember -MemberUserPrincipalName $upnElzReadOnly -GroupDisplayName "rbac-$elzSubName-elzreadonly"

# Test for IP address shortage
Invoke-Pester -Output Detailed -Path .\elz\src\tests\ELZ.tests2.ps1
