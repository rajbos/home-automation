param(
    [string] $localDir
)

. $PSScriptRoot/utils.ps1
Write-Message (Get-Date -Format 'yyyyMMdd HH:mm')
Write-Message "Starting Windows Logon Script"

# check if there are more then 1 monitor available (the laptop itself already is the first one :-) )
$displays = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams
if ($displays.Count -gt 1) {    
    Write-Message "Found more than one display"

    # pull in different scripts
    . $PSScriptRoot/trigger-homeassistant.ps1

    # call script to switch on scene
    $entityId = "scene.officelights"
    switchScene -entityId $entityId -command "turn_on"
    Write-Message "Switched on scene $entityId"
}
else {
    Write-Message "Found only one display, stopping execution"
}