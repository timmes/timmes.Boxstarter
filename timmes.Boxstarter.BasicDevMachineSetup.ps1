### GENERAL BOXSTARTER SETTINGS ###
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot


### WINDOWS SETTINGS ###
# .NET 3.5
choco install dotnet3.5
if (Test-PendingReboot) { Invoke-Reboot }

# .NET 4.5
choco install dotnet4.5
if (Test-PendingReboot) { Invoke-Reboot }

# Basic setup
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-TaskbarOptions -Size Small
Enable-RemoteDesktop
Disable-InternetExplorerESC
Disable-UAC
Move-LibraryDirectory "Personal" "$env:UserProfile\OneDrive\documents" #move "Documents" folder to OneDrive

# Disable defrag (no need when having an SSD)
Get-ScheduledTask -TaskName *defrag* | Disable-ScheduledTask


### POWER SETTINGS ###
# Turn off hibernation
powercfg /H OFF

# Change Power saving options (ac=plugged in dc=battery)
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 15
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 30
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 30
powercfg -change -hibernate-timeout-ac 0


### SOFTWARE ###
# Browser #
choco install googlechrome

# Essentials & Productivity
#choco install office365business -y
choco install skype -y
choco install skypeforbusiness -y
choco install dropbox -y
choco install 1password -y #password manager
choco install balsamiqmockups3 -y
choco install greenshot -y #best screenshot tool in the world
choco install adobereader -y
choco install windirstat -y #disk cleanup
choco install 7zip -y
cinst TelnetClient -source windowsFeatures

# Development
choco install visualstudio2015community -InstallArguments "/Features:'WebTools SQL'" -y
choco install visualstudiocode -y
choco install notepadplusplus -y
choco install fiddler4 -y
choco install git -y
choco install sourcetree -y #great gui for git

# Databases
#choco install mssqlserver2014express -y

# SharePoint
#choco install sharepointmanager2013
#choco install ulsviewer

# Taskbar
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS
if (Test-PendingReboot) { Invoke-Reboot }