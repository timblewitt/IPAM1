function Add-Lzim-Records {
    param (
        $lzEnvironment,
        $lzNumber
    )

    $lzimSubName = 'mp0004'   # Name/id of management subscription
    $lzimRegionId = 'uks'     # Region identifier used in naming central network resources
    $faLzimName = "fa-$lzimSubName-$lzimRegionId-lzim"
                
    $uri = 'https://' + $faLzimName + '.azurewebsites.net/api/Add-Lzid?'
    
    #Write-Host "URI: " $uri
    #Write-Host "Environment: " $elzEnvName
    $body = @{
        'InputObject' = @{
            'Environment' = $lzEnvironment
            'Number' = $lzNumber
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
    Invoke-RestMethod @params      
    #Write-Host "Landing Zone identifier returned from LZIM: " $elzIds        
}

Add-Lzim-Records -lzEnvironment 'Dev' -lzNumber 10
Add-Lzim-Records -lzEnvironment 'QA' -lzNumber 10
Add-Lzim-Records -lzEnvironment 'Prod' -lzNumber 10
Add-Lzim-Records -lzEnvironment 'Staging' -lzNumber 10
Add-Lzim-Records -lzEnvironment 'Test' -lzNumber 10

