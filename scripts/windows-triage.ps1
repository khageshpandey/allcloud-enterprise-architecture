Write-Output "=== IIS Service & App Pool Status ==="
Get-Service -Name W3SVC | Select-Object Name, Status
Import-Module WebAdministration -ErrorAction SilentlyContinue
Get-WebAppPool | Select-Object Name, State
Write-Output "=== Critical Event Logs (Last 2 Hours) ==="
Get-EventLog -LogName Application -EntryType Error -After (Get-Date).AddHours(-2) | Select-Object -First 10 Message