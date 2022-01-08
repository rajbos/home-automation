$logFile = "C:\Users\Public\Credentials\WindowsLogon.log" # todo: move to better location within the user space
function Write-Message(
    [string] $message,
    [boolean] $nologfile = $false
)
{
    Write-host $(Get-Date -Format "HH:mm:ss") $message
    if ($nologfile -eq $false)
    {
        $message | Out-File -FilePath $logFile -Append
    }
}