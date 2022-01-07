
function Get-Token {
    # load token from a encrypted location, secured with the user session so only the user can read the data

    Begin {
        # todo: improve locattion to the user space
        $CredDirectory = "C:\Users\Public\Credentials"
        $CredFile = [System.IO.Path]::Combine($CredDirectory, "Home_Assistant_cred.xml")
        if (-Not(Test-Path $CredDirectory)) {
            New-Item -Path $CredDirectory -ItemType Directory
        }
    }

    Process {
        if (-Not(Test-Path $CredFile)) {
            # Get the token and store it securely
            $CredentialParams = @{
                Message  = "Enter Home Assistant Token:"
                Username = "token"
                Title    = "Home assistant token"
            }
            $Credential = Get-Credential @CredentialParams

            $Credential | Export-Clixml -Path $CredFile
        }

        $credential = [PSCredential] (Import-Clixml -Path $CredFile)
        ConvertFrom-SecureString -SecureString $credential.Password -AsPlainText
    }        
}

<#
    $command options: toggle, turn_on, turn_off
#>
function switchToggle{
    param (
        [string]$entityId,
        [string]$token,
        [string]$homeAssistant,
        [string]$command = "toggle"
    )

    if ($token -eq "") {
        $token = Get-Token
    }
    $url = "$homeAssistant/api/services/switch/$command"

    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    }
    Invoke-RestMethod -Uri $url -Body "{""entity_id"": ""$entityId""}" -Headers $headers -Method POST
}


<#
    $command options: toggle, turn_on, turn_off
#>
function switchScene{
    param (
        [string]$entityId = $entityId,
        [string]$token,
        [string]$homeAssistant = $homeAssistant,
        [string]$command = "toggle"
    )

    if ($token -eq "") {
        $token = Get-Token
    }
    $url = "$homeAssistant/api/services/scene/$command"

    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    }
    Invoke-RestMethod -Uri $url -Body "{""entity_id"": ""$entityId""}" -Headers $headers -Method POST
}

