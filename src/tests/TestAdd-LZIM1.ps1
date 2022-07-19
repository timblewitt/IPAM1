#
# This script calls the LZIM Azure Function App (Add-LzId function) using the REST API to add a range of
# Azure Landing Zone identifiers for a given environment (e.g. production/test/dev/staging/QA).
# These ids can then be requested individually using the Get-LzId function for new Azure Landing Zones.
#
function Add-Lzim-Records {
    param (
        $Environment,
        $Number
    )
    $faName = 'fa-mp0004-uks-lzim'
    $faRg = 'rg-mp0004-uks-lzim'     
    $faId = (Get-AzWebApp -Name $faName -ResourceGroupName $faRg).Id 
    $faFunction = 'Add-Lzid'
    $faFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/$faFunction" -Action listkeys -Force).default
    $uri = 'https://' + $faName + '.azurewebsites.net/api/' + $faFunction + '?code=' + $faFunctionKey
    $body = @{
        'InputObject' = @{
            'Environment' = $Environment
            'Number' = $Number
        }
    } | ConvertTo-Json 
    $params = @{
        'Uri'         = $uri
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $body
    }
    Invoke-RestMethod @params      
}

Add-Lzim-Records -Environment 'Dev' -Number 100
Add-Lzim-Records -Environment 'Prod' -Number 100
Add-Lzim-Records -Environment 'QA' -Number 100
Add-Lzim-Records -Environment 'Staging' -Number 100
Add-Lzim-Records -Environment 'Test' -Number 100