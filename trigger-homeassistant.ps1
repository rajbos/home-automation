. $PSScriptRoot/utils.ps1

function Get-Token {
    # load token from a encrypted location, secured with the user session so only the user who created it can read the data

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
        $token = ConvertFrom-SecureString -SecureString $credential.Password -AsPlainText
        Write-Message "Found a token with length [$($token.Length)]"
        return $token
    }        
}

$localHomeAssistant = "http://192.168.1.39:8123"
<#
    $command options: toggle, turn_on, turn_off
#>
function switchToggle{
    param (
        [string]$entityId,
        [string]$token,
        [string]$homeAssistant = $env:homeAssistant,
        [string]$command = "toggle"
    )

    if ($token -eq "") {
        Write-Message "Loading token from disk"
        try {
        $token = Get-Token
        } catch {
            Write-Message "Could not load token from disk. Please set the token as environment variable or in the script."
            Write-Message $_
            throw
        }
    }

    if ($homeAssistant -eq "") {
        #Write-Error "Parameter 'homeAssistant' is missing. You can set this as environment value with the url to your home assistant instance."
        # overwrite with hardcode value for now
        $homeAssistant = $localHomeAssistant
    }
    $url = "$homeAssistant/api/services/switch/$command"
    Write-Message "We are using this url for the command: [$url]"

    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    }
    Write-Message "Calling the url"
    Invoke-RestMethod -Uri $url -Body "{""entity_id"": ""$entityId""}" -Headers $headers -Method POST
    Write-Message "Call made successfully"
}

<#
    $command options: toggle, turn_on, turn_off
#>
function switchScene{
    param (
        [string]$entityId,
        [string]$token,
        [string]$homeAssistant = $env:homeAssistant,
        [string]$command = "toggle"
    )

    if ($token -eq "") {
        Write-Message "Loading token from disk"
        try {
        $token = Get-Token
        } catch {
            Write-Message "Could not load token from disk. Please set the token as environment variable or in the script."
            Write-Message $_
            throw
        }
    }

    if ($homeAssistant -eq "") {
        #Write-Error "Parameter 'homeAssistant' is missing. You can set this as environment value with the url to your home assistant instance."
        # overwrite with hardcode value for now
        $homeAssistant = $localHomeAssistant
    }
    $url = "$homeAssistant/api/services/scene/$command"
    Write-Message "We are using this url for the command: [$url]"

    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    }
    Write-Message "Calling the url"
    Invoke-RestMethod -Uri $url -Body "{""entity_id"": ""$entityId""}" -Headers $headers -Method POST
    Write-Message "Call made successfully"
}

