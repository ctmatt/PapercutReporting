Start-Sleep -Seconds 3

#Download updated script
$dl = (New-Object System.Net.WebClient).Downloadstring('https://raw.githubusercontent.com/ctmatt/PapercutReporting/master/PapercutNotifications.ps1')

if ($dl -eq $null)
{
    #Download failed exiting updater
    exit
}

$psversion = Get-Host | Select-Object Version
$psversion = $psversion.Version.major
if($psversion -gt 4)
{
	if (Get-Command Send-TeamsMessage -errorAction SilentlyContinue)
	{
	    #$cmdName exists
	}else
	{
	    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
	    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -force
	    Install-Module -Name PSTeams -Confirm:$False
	}
}
else
{
 Write-Host = "Update powershell please"
}

try 
{
    if(Test-Path -Path "$($PWD.Path)\PapercutNotifications.ps1")
    {
        Remove-Item "$($PWD.Path)\PapercutNotifications.ps1"
    }
    $dl | Out-File "$($PWD.Path)\PapercutNotifications.ps1"
    Invoke-Expression "$($PWD.Path)\PapercutNotifications.ps1 -notify"
}
catch [System.Exception] {
    #Failed to update exiting
    exit
}
