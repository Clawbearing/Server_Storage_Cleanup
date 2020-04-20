#verify connectivty to servers selected
#Write out Servers selected
#check space on the C Drive and write out
$GetCDiskSpace = Get-WmiObject -Class Win32_logicaldisk | Where-Object {$_.DeviceID -eq "C:"} | Select-Object Name, @{name='Available GB on Drive';expression={[math]::Truncate($_.FreeSpace / 1GB)}}


#delete the recycle bin
Clear-RecycleBin


#delete SCCM cache files - find location
Remove-Item C:\Windows\ccmcache -Recurse -ErrorAction SilentlyContinue

#cleanup image files
Dism.exe /online /Cleanup-Image /spsuperseded

#check free'd space on disk, if less than 10, provision 10 GB with VMware

$Friendly_C_Space = Get-WmiObject -Class Win32_logicaldisk | Where-Object {$_.DeviceID -eq "C:"} | Select-Object FreeSpace, @{Name='CDrive';expression={[math]::round(($_.FreeSpace/1GB),2)}} | Select-Object CDrive

[int]$C_Space = $Friendly_C_Space.CDrive


$C_Space -is [int]

If ($C_Space -gt 10)
  {
    Write-Host "You have enough space!"
  }








