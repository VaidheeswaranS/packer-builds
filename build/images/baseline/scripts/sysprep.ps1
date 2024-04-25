Write-Host '>>> Waiting for GA Service (RdAgent) to start ...'
while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }
Write-Host '>>> Waiting for GA Service (WindowsAzureGuestAgent) to start ...'
while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }
Write-Host '>>> Sysprepping VM ...'
# Start-Sleep -s 180
Start-Sleep -s 60
if(Test-Path $Env:SystemRoot\system32\Sysprep\unattend.xml) {
  Remove-Item $Env:SystemRoot\system32\Sysprep\unattend.xml -Force
}
& $Env:SystemRoot\System32\Sysprep\Sysprep.exe /oobe /generalize /quiet /quit
while($true) {
  $imageState = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State).ImageState
  Write-Host $imageState
  if ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }
  Start-Sleep -s 5
}
# Write-Host 'Waiting for 5 mins'
# Start-Sleep -s 300
Write-Host 'Waiting for 1 min'
Start-Sleep -s 60
Write-Host 'Waiting Completed'
Write-Host '>>> Sysprep complete ...'
