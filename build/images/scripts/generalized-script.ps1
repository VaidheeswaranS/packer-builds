
echo "Running the genralized script"

$blobUrl =  "https://buildserverartifacts.blob.core.windows.net/artifacts"

#Install AzCopy
echo "Installing Azcopy"
choco install azcopy10 -y
#Install Azure-CLI
echo "Installing azure-cli"
choco install azure-cli -y

#Azcopy copy command to copy the installers
azcopy copy $blobUrl "C:\Windows\Temp" --recursive=true
echo "copying contents from blob storage is successful"