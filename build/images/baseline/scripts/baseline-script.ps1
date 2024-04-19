
$EncodedCredentials = $env:EncodedCredentials
$AquaToken = $env:AquaToken

Write-Host "Encoded Credentials is $EncodedCredentials"
Write-Host "Aqua Token is $AquaToken"

# Installing choclatey
echo "Downloading and Installing the chocolatey packager manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Specify the Node.js version
$nodeVersion = "14.18.3"

# Specify the URL for the Node.js and Visual C++ 2005,2010,2012,2013,2015-2019 Redistributable (x86) installer
$nodeInstallerUrl = "https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-x64.msi"

# Specify the installation directory for Node.js
$installDir_nodejs = "C:\Program Files\nodejs"

# Installing the Node.js
echo "Downloading the Node.js package"
Invoke-WebRequest -Uri $nodeInstallerUrl -OutFile "node-installer.msi"
echo "Installing the Node.js $nodeVersion"
Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/i node-installer.msi /qn INSTALLDIR=`"$installDir_nodejs`""
echo "Adding Node.js to system path"
$env:Path += ";$installDir_nodejs"
[Environment]::SetEnvironmentVariable('Path', "$($env:Path);$installDir_nodejs", [EnvironmentVariableTarget]::Machine)
echo "Verifying the Installation"
node -v
npm -v