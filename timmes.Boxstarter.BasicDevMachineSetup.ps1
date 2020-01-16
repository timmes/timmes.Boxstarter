# Description: Boxstarter Script for Developer Machines
# Author: https://github.com/timmes
#
# To run this script, you first have to install boxstarter using the following command (NOTE the "." below is required):
# 	. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
# Learn more: http://boxstarter.org/Learn/WebLauncher
#
# Run this BoxstarterDevFull.ps1 script by calling the following from **elevated** powershell:
#   example: Install-BoxstarterPackage -PackageName https://gist.githubusercontent.com/timmes/e061f3eefab4cde48dd088fb23dc2687/raw/7b0dfd3debff73c46505d61a63269adf59eadfe2/BoxstarterDevFull.ps1 -DisableReboots


Update-ExecutionPolicy -Policy RemoteSigned

# Workaround for nested chocolatey folders resulting in path too long error
$ChocoCachePath = "C:\Temp"
New-Item -Path $ChocoCachePath -ItemType directory -Force

# Trust PSGallery
Get-PackageProvider -Name Nuget -ForceBootstrap
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Temporary
Disable-UAC

# General boxstarter settings #
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#############################
# Privacy / Security Settings
#############################
Disable-BingSearch
Disable-GameBarTips

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

# Start Menu: Disable Cortana 
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0

# Disable SMBv1
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol

# Disable Internet Explorer Enhanced Security
Disable-InternetExplorerESC

############################
# Personal Preferences on UI
############################
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-TaskbarOptions -Size Small

# Move "Documents" folder to OneDrive
#Move-LibraryDirectory "Personal" "$env:UserProfile\OneDrive\documents"

# Disable defrag (no need when having an SSD)
Get-ScheduledTask -TaskName *defrag* | Disable-ScheduledTask

# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

# Better File Explorer
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1		
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1		
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

# These make "Quick Access" behave much closer to the old "Favorites"
# Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
# Disable Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1

# Lock screen (not sleep) on lid close
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name AwayModeEnabled -Type DWord -Value 1

# Disable Xbox Gamebar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Type DWord -Value 0

# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0

###############################
# Windows 10 Metro App Removals
###############################

# 3D Builder
Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage

# Alarms
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage

# Autodesk
Get-AppxPackage *Autodesk* | Remove-AppxPackage

# Bing Weather, News, Sports, and Finance (Money):
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage

# BubbleWitch
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage

# Candy Crush
Get-AppxPackage king.com.CandyCrush* | Remove-AppxPackage

# Comms Phone
Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage

# Dell
Get-AppxPackage *Dell* | Remove-AppxPackage

# Disney Magic Kingdom
Get-AppxPackage *DisneyMagicKingdom* | Remove-AppxPackage

# Dropbox
Get-AppxPackage *Dropbox* | Remove-AppxPackage

# Facebook
Get-AppxPackage *Facebook* | Remove-AppxPackage

# Feedback Hub
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage

# Get Started
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage

# Hidden City: Hidden Object Adventure
Get-AppxPackage *HiddenCityMysteryofShadows* | Remove-AppxPackage

# Keeper
Get-AppxPackage *Keeper* | Remove-AppxPackage

# Mail & Calendar
Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage

# Maps
Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage

# March of Empires
Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage

# McAfee Security
Get-AppxPackage *McAfee* | Remove-AppxPackage

# Uninstall McAfee Security App
$mcafee = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "McAfee Security" } | select UninstallString
if ($mcafee) {
	$mcafee = $mcafee.UninstallString -Replace "C:\Program Files\McAfee\MSC\mcuihost.exe",""
	Write "Uninstalling McAfee..."
	start-process "C:\Program Files\McAfee\MSC\mcuihost.exe" -arg "$mcafee" -Wait
}

# Messaging
Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage

# Minecraft
Get-AppxPackage *Minecraft* | Remove-AppxPackage

# Netflix
Get-AppxPackage *Netflix* | Remove-AppxPackage

# Office Hub
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage

# One Connect
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage

# OneNote
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage

# People
Get-AppxPackage Microsoft.People | Remove-AppxPackage

# Phone
Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage

# Photos
Get-AppxPackage Microsoft.Windows.Photos | Remove-AppxPackage

# Plex
Get-AppxPackage *Plex* | Remove-AppxPackage

# Skype (Metro version)
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage

# Sound Recorder
Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage

# Solitaire
Get-AppxPackage *Solitaire* | Remove-AppxPackage

# Sticky Notes
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage

# Sway
Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage

# Twitter
Get-AppxPackage *Twitter* | Remove-AppxPackage

# Xbox
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage

# Zune Music, Movies & TV
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage

###############################
# Power Settings
###############################

# Turn off hibernation
powercfg /H OFF

# Change Power saving options (ac=plugged in dc=battery)
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 15
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 30
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0

###################################
# Windows Subsystems/Roles/Features
###################################

cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst Microsoft-Windows-Subsystem-Linux -source windowsFeatures
cinst TelnetClient -source windowsFeatures

cinst IIS-ApplicationDevelopment -source windowsfeatures
cinst IIS-ApplicationInit -source windowsfeatures
cinst IIS-ASPNET -source windowsfeatures
cinst IIS-ASPNET45 -source windowsfeatures
cinst IIS-BasicAuthentication -source windowsfeatures
cinst IIS-ClientCertificateMappingAuthentication -source windowsfeatures
cinst IIS-CommonHttpFeatures -source windowsfeatures
cinst IIS-CustomLogging -source windowsfeatures
cinst IIS-DefaultDocument -source windowsfeatures
cinst IIS-DigestAuthentication -source windowsfeatures
cinst IIS-DirectoryBrowsing -source windowsfeatures
cinst IIS-HealthAndDiagnostics -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures
cinst IIS-HttpCompressionStatic -source windowsfeatures
cinst IIS-HttpErrors -source windowsfeatures
cinst IIS-HttpLogging -source windowsfeatures
cinst IIS-HttpRedirect -source windowsfeatures
cinst IIS-HttpTracing -source windowsfeatures
cinst IIS-IISCertificateMappingAuthentication -source windowsfeatures
cinst IIS-IPSecurity -source windowsfeatures
cinst IIS-ISAPIExtensions -source windowsfeatures
cinst IIS-ISAPIFilter -source windowsfeatures
cinst IIS-LoggingLibraries -source windowsfeatures
cinst IIS-ManagementConsole -source windowsfeatures
cinst IIS-ManagementScriptingTools -source windowsfeatures
cinst IIS-ManagementService -source windowsfeatures
cinst IIS-NetFxExtensibility -source windowsfeatures
cinst IIS-NetFxExtensibility45 -source windowsfeatures
cinst IIS-Performance -source windowsfeatures
cinst IIS-RequestFiltering -source windowsfeatures
cinst IIS-RequestMonitor -source windowsfeatures
cinst IIS-Security -source windowsfeatures
cinst IIS-StaticContent -source windowsfeatures
cinst IIS-URLAuthorization -source windowsfeatures
cinst IIS-WebServer -source windowsfeatures
cinst IIS-WebServerManagementTools -source windowsfeatures
cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-WebSockets -source windowsfeatures
cinst IIS-WindowsAuthentication -source windowsfeatures

############################
# .NET Framework
############################

# .NET 3.5
choco install dotnet3.5
if (Test-PendingReboot) { Invoke-Reboot }

# .NET 4.5
choco install dotnet4.5
if (Test-PendingReboot) { Invoke-Reboot }

########
# Azure
########

# Install Azure cli
cup azure-cli --cacheLocation $ChocoCachePath

# Install azcopy
cup azcopy --cacheLocation $ChocoCachePath

# Install Microsoft Azure Storage Explorer
cup microsoftazurestorageexplorer --cacheLocation $ChocoCachePath

# Install Microsoft Azure ServiceBus Explorer
cup servicebusexplorer --cacheLocation $ChocoCachePath

##########
# Browsers
##########

choco install googlechrome

##########
# Docker
##########

# Install Docker & Minikube
cup docker-desktop --cacheLocation $ChocoCachePath
cup docker-compose --cacheLocation $ChocoCachePath
cup minikube --cacheLocation $ChocoCachePath

#####
# Git
#####

# Install git & git credential manager
cup git --cacheLocation $ChocoCachePath
cup git-credential-manager-for-windows --cacheLocation $ChocoCachePath

# Install Gitkraken
cup gitkraken --cacheLocation $ChocoCachePath

# Install posh-git
cup poshgit --cacheLocation $ChocoCachePath

##############
# PowerShell
##############

# Installing Azure PowerShell modules
Install-Module -Name AzureRM -Scope AllUsers
Install-Module -Name Azure -Scope AllUsers -AllowClobber

# Install Pester
cup pester --cacheLocation $ChocoCachePath

#############################
# Runtime Environments & SDKs
#############################

#Install Go
cup golang --cacheLocation $ChocoCachePath

# Install Python 3
cup python3 --cacheLocation $ChocoCachePath

#######
# Tools
#######

# Install Zip Tools
cup 7zip --cacheLocation $ChocoCachePath

# Install Enhanced cli
cup conemu --cacheLocation $ChocoCachePath

# Install File Tools

# Install Data Transfer Tools
cup curl --cacheLocation $ChocoCachePath
cup wget --cacheLocation $ChocoCachePath
cup postman --cacheLocation $ChocoCachePath

# Install Productivity Tools
choco install skype -y
choco install dropbox -y
choco install 1password -y 
choco install greenshot -y 
choco install adobereader -y
choco install windirstat -y

# Install Development Tools
choco install visualstudiocode -y

# Install IIS Tools
cup urlrewrite --cacheLocation $ChocoCachePath

# Install Nuget Tools
cup nugetpackageexplorer --cacheLocation $ChocoCachePath
cup nuget.commandline --cacheLocation $ChocoCachePath

# Install Visual Studio Code Extensions

code --install-extension ms-vscode.csharp
code --install-extension ms-vscode.Go
code --install-extension ms-vscode.PowerShell
code --install-extension ms-vscode.azurecli
code --install-extension ms-azuretools.vscode-azurefunctions
code --install-extension ms-mssql.mssql
code --install-extension ms-python.python
code --install-extension msazurermtools.azurerm-vscode-tools
code --install-extension mindginative.terraform-snippets
code --install-extension hnw.vscode-auto-open-markdown-preview
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension in4margaret.compareit
code --install-extension waderyan.gitblame
code --install-extension PKief.material-icon-theme
code --install-extension zhuangtongfa.Material-theme
code --install-extension mechatroner.rainbow-csv
code --install-extension mauve.terraform
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension VisualStudioOnlineApplicationInsights.application-insights
code --install-extension humao.rest-client
code --install-extension ryu1kn.annotator
code --install-extension donjayamanne.githistory
code --install-extension eamodio.gitlens
code --install-extension shaharkazaz.git-merger
code --install-extension ipedrazas.kubernetes-snippets
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension blackmist.LinkCheckMD
code --install-extension emilast.LogFileHighlighter
code --install-extension mdickin.markdown-shortcuts
code --install-extension stkb.rewrap
code --install-extension formulahendry.code-runner

#####################################
# Update Windows, reboot and clean up
#####################################

# Clean up the cache directory
Remove-Item $ChocoCachePath -Recurse

#--- Restore Temporary Settings ---
choco feature disable -n=allowGlobalConfirmation
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
Enable-UAC
