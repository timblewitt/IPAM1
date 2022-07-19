#
# This script calls the LZIM function app using the REST API to retrieve a free
# Azure Landing Zone identifier for a given environment.
#
function Get-Lzim-Record {
    param (
        $Environment,
        $Notes
    )                
    $faName = 'fa-mp0004-uks-lzim'
    $faRg = 'rg-mp0004-uks-lzim'     
    $faId = (Get-AzWebApp -Name $faName -ResourceGroupName $faRg).Id 
    $faFunction = 'Get-Lzid'
    $faFunctionKey = (Invoke-AzResourceAction -ResourceId "$faId/functions/$faFunction" -Action listkeys -Force).default
    $uri = 'https://' + $faName + '.azurewebsites.net/api/' + $faFunction + '?code=' + $faFunctionKey
    $body = @{
        'InputObject' = @{
            'Environment' = $Environment
            'Notes' = $Notes
        }
    } | ConvertTo-Json 
    $params = @{
        'Uri'         = $uri
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $body
    }
    $elzId = Invoke-RestMethod @params 
    return $elzId 
}

Get-Lzim-Record -Environment 'QA' -Notes 'Test addition'
