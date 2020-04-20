#install module to use VMware commands in PowerShell
Install-Module -Name VMware.PowerCLI -AllowClobber

#Use this to provision 10 more GB of storage to a VM

#User selection for proper vCenter Server connect

Write-Host "Choose vCenter Server"
Write-Host "1:  navcs02.sidley.com"
Write-Host "2:  n2vcs02.sidley.com"
[validateRange(1,2)]$Selection = Read-Host "Enter 1 or 2"

If ($Selection -eq 1){
  Write-Host "You have select navcs02"
  Connect-viserver navcs02.sidley.com
}
else {
  Write-Host "You have select n2vcs02"
  Connect-viserver n2vcs02.sidley.com
} 

#Select VM
$vmselect = Read-Host "What VM do you want to work on?"
$vm = Get-VM $vmselect

#Add scsi controller

$vm | New-HardDisk -CapacityGB 5 | New-ScsiController -BusSharingMode NoSharing -Type ParaVirtual

#Put disk online, initilaize, GPT partition, new simple volume, max space format as NTFS

Invoke-Command -ComputerName $vmselect -ScriptBlock 
  {

$newdisk = Get-Disk | Where {$_.OperationalStatus -eq "Online"}

$newdisk | Initialize-Disk -PartitionStyle GPT | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -Full -Force

  }
