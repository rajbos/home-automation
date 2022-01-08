$logFile = "C:\Users\Public\Credentials\WindowsLogon.log" # todo: move to better location within the user space
function Write-Message(
    [string] $message
)
{
    Write-Host $message
    $message | Out-File -FilePath $logFile -Append
}