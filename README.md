# timmes.Boxstarter #

### Summary ###
Automating tasks is cool. It saves time and minimizes errors, at least manual errors. To save us (.NET developers) some time, I created this small script - inspired by @robertbird - for [Boxstarter](http://boxstarter.org/), so we can focus on more important things than manually downloading and installing our needed tools.

### Prerequisites ###
- Windows 10
- [Chocolatey](https://chocolatey.org)
- [Boxstarter](http://boxstarter.org/)

In order to get started with the script, you need to install Chocolatey first. Open a PowerShell console in administrator mode and run the following two lines:
```powershell
Set-ExecutionPolicy Unrestricted
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
```
After that it's time to install Boxstarter. Simply run the following script from your PowerShell:

```
choco install boxstarter -y
```

### Running the script ###
This is as easy as installing the prerequisites. Follow these simple steps.

1. Open the Boxstarter Shell or Powershell with elevated privileges
2. Run the following command
3. Grab a tea and relax! ;-)
```powershell
Install-BoxstarterPackage https://raw.githubusercontent.com/timmes/timmes.Boxstarter/master/BoxstarterDevFull.ps1
```

If you do not want to run the script *as is* but make your own changes, you should clone the repository or create a [Gist](https://gist.github.com/). Afterwards replace the `url?` with the new URL where your script is hosted.

----------

## Disclaimer ##
**THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND.**

## Contributing ##
If you want to contribute to this project, simply clone the repository and send a pull request with your changes.

## License ##
See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
