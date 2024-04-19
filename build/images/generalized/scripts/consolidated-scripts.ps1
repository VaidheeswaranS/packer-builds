# TODO: Move to Application Team Sub Blob
$blobUrl =  "https://buildserverartifacts.blob.core.windows.net/artifacts"

# Installing choclatey
echo "Downloading and Installing the chocolatey packager manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo "Installing GIT CLI tool"
choco install git -params '"/GitAndUnixToolsOnPath"' -y

#Install AzCopy
echo "Installing Azcopy"
choco install azcopy10 -y
#Install Azure-CLI
echo "Installing azure-cli"
choco install azure-cli -y

#Azcopy copy command to copy the installers
azcopy copy $blobUrl "C:\Windows\Temp" --recursive=true