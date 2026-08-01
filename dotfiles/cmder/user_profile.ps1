# Cmder PowerShell task startup (optional).
# Applied to C:\Programs\cmder\config\user_profile.ps1

if (Test-Path 'C:\Projects') {
    Set-Location 'C:\Projects'
}

function proj { Set-Location C:\Projects }
function programs { Set-Location C:\Programs }
function hub { Set-Location C:\Projects\dev-hub }
