
$logFileName="WindowsLogon.log"

function Write-Message(
    [string] $message,
    [boolean] $nologfile = $false
)
{
    $datestr = $(Get-Date -Format "yyyyMMdd")
    $logFile = "C:\Users\Public\Credentials\$($datestr)_$logFileName" # todo: move to better location within the user space
    

    Write-Host $(Get-Date -Format "HH:mm:ss") $message
    if ($nologfile -eq $false)
    {
        "$(Get-Date -Format "HH:mm:ss") $message" | Out-File -FilePath $logFile -Append
    }
}