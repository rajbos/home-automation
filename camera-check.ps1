#Requires -RunAsAdministrator
<#
    Tested on Windows 11
    This works for the following programs so far:
    - Teams
    - Zoom
    - obs64

    What doesn't seem to work, unless you run this script as admin:
    - Slack preview window (svchost)
    - Teams from webapp in Edge (svchost)
    - Camera app (svchost)
    - Camtasia Capture (svchost)
#>

. $PSScriptRoot/utils.ps1
$handleDirectory = "C:\Users\RobBos\Downloads\Handle"

function Check-Device {
    param(
        [object] $device,
        [int] $deviceCount
    )

    # load Physical Device Object Name
    $property = Get-PnpDeviceProperty -InstanceId $device.InstanceId -KeyName "DEVPKEY_Device_PDOName"

    if ($property.Data.Length -eq 0) {
        Write-Message "$deviceCount.  No PDON found for [$($device.FriendlyName)] so skipping it"
        return
    }

    Write-Message "$deviceCount.  Checking handles in use for [$($device.FriendlyName)] and PDON [$($property.Data)]"
    $handles = $(& $handleDirectory\handle64.exe -NoBanner -a "$($property.Data)")
    if ($handles -gt 0) {
        if ($handles[0].ToLower().StartsWith("no matching handles found")){
            Write-Message "  - No handles found for [$($device.FriendlyName)]"
        }
        else {

            Write-Message "  - Found [$($handles.Length)] handles on $($device.FriendlyName)"
            $processes = @()
            foreach ($handle in $handles) {
                # remove all spaces
                $nospaceshandle = $handle.Replace(" ", "")
                if ($nospaceshandle.Length -gt 0) {
                    # Write-Host $handle
                    $splitted = $handle.Split(" ")
                    $process = $splitted[0]
                        if (!($processes.Contains($process))) {
                            $processes += $process
                        }
                    }
            }
            if ($processes.Length -eq 0) {
                Write-Message " -  No handles found for [$($device.FriendlyName)]"
            }
            else {
                foreach ($process in $processes) {
                    Write-Message "  - Found process [$($process)] that has a handle on [$($device.FriendlyName)]"
                    
                    Write-Host "$(Get-Date -Format "HH:mm:ss")    " $process -ForegroundColor Green
                    return $true
                }
            }
        }
    }
    return $false
}

# todo: download the latest version of handle64.exe from https://download.sysinternals.com/files/Handle.zip
# unzip it in the same directory as this script
Write-Message "Using [$handleDirectory] as the directory of handle.exe"

# check if the file exists
if (!(Test-Path "$handleDirectory\handle64.exe"))
{
    Write-Message "handle.exe not found in [$handleDirectory]"
    Write-Message "Download handle from https://docs.microsoft.com/en-us/sysinternals/downloads/handle"
    return 1
}

function Test-Loop {
    while ($true) {
        Write-Message "Searching for camera devices"
        $devices = Get-PnpDevice -Class Camera,Image
        Write-Message "Found [$($devices.Count)] camera devices"
        $deviceCount = 0
        foreach ($device in $devices) {
            $deviceCount++
            $result = Check-Device $device $deviceCount
        }
        Write-Message ""
    }
    Write-Message "Done"
}

function Get-CameraActive {
    
    Write-Message "Searching for camera devices"
    $devices = Get-PnpDevice -Class Camera,Image
    Write-Message "Found [$($devices.Count)] camera devices"
    $deviceCount = 0
    foreach ($device in $devices) {
        $deviceCount++
        $result = Check-Device $device $deviceCount
        if ($result) {
            Write-Message "Found active camera device"
            return $true
        }
    }
    return $false
}

function CheckCameraOnceWithAction {    
    $active = Get-CameraActive
    Run-Action $active    
}

function LoopWithAction {
    while ($true) {
        $start = Get-Date
        $active = Get-CameraActive
        Run-Action $active

        # don't run again unless a minute has passed
        $end = Get-Date
        $duration = $end - $start
        if ($duration.TotalSeconds -lt 60) {
            Write-Message "Sleeping for $((60-$duration.TotalSeconds).ToString('#')) seconds"
            Start-Sleep (60-($duration.TotalSeconds))
        }
    }
}

# lamp living room to test:
# $entityId = "switch.shelly_plug_s_9a57b1_relay_0"

# actual office camera lights:
$entityId = "script.camera_lights"
$checkEntityIdState = "light.key_light_left"

function Run-Action {
    param(
        [bool] $active = $false
    )
    Write-Message "Running action to make the state [$active]"

    . $PSScriptRoot/trigger-homeassistant.ps1
    
    $state = getEntityState -entityId $checkEntityIdState    
    Write-Message "Current entity state is [$($state.state)]"

    if ($active) {
        if ($state.state -eq "on") {
            Write-Message "Already active, no need to do anything"
        } 
        else {            
            Write-Message "Turning on"
            runScript -entityId $entityId
        }
    }
    else {
        if ($state.state -eq "off") {
            Write-Message "Already off, no need to do anything"
        } 
        else {            
            Write-Message "Turning off"
            runScript -entityId $entityId 
        }
    }
}

#Test-Loop
LoopWithAction