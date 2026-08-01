# Optional PowerShell 7+ profile (outside Cmder).
# Applied by link.ps1 Dev target to Documents\PowerShell\

function proj { Set-Location C:\Projects }
function programs { Set-Location C:\Programs }
function hub { Set-Location C:\Projects\dev-hub }

Set-Alias -Name e. -Value explorer -ErrorAction SilentlyContinue
