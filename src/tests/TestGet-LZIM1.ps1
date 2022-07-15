function Get-Lzim-Record {
    param (
        $lzEnvironment
    )
 
    $lzimSubName = 'mp0004'   # Name/id of management subscription
    $lzimRegionId = 'uks'     # Region identifier used in naming central network resources
    $faLzimName = "fa-$lzimSubName-$lzimRegionId-lzim"
                
    $uri = 'https://' + $faLzimName + '.azurewebsites.net/api/Get-Lzid?'

    #Write-Host "URI: " $uri
    #Write-Host "Environment: " $lzEnvironment
    $body = @{
        'InputObject' = @{
            'Env1' = $lzEnvironment
        }
    } | ConvertTo-Json 
    #Write-Host "Body: " $body
    $params = @{
        'Uri'         = $uri
        'Method'      = 'POST'
        'ContentType' = 'application/json'
        'Body'        = $body
    }
    #Write-Host "Calling LZIM function to request allocated Landing Zone identifier"
    $elzId = Invoke-RestMethod @params -Verbose      
    #Write-Host "Landing Zone identifier returned from LZIM: " $elzId  
    return $elzId 
}

Get-Lzim-Record -lzEnvironment 'Test'

