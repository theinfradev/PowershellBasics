##Note - I would not deploy this script as it does not have any checks in place. It just tries to create a new VM.
The point of this script is to show how we can create a Contract, then a Function, Then Run it.

#########################
## Create Contract ##
#########################

Class NewVMConfig
{
    [string]$Name
    [string]$VMPath
    [string]$NewVHDPath
    [int64]$NewVHDSize
    [int64]$StartupMemory
    [string]$BootDevice
    [string]$NetworkSwitch
    [int32]$Generation
    [string]$ISOPath

    NewVMConfig($name)
    {
        $this.Name          = $name
        $this.VMPath        = 'C:\$name'
        $this.NewVHDPath    = "C:\$name\vhd"
        $this.NewVHDSize    = 107374127400
        $this.StartupMemory = 1073741274
        $this.BootDevice    = 'DVD'
        $this.NetworkSwitch = 'MyCorp'
        $this.Generation    = 2
        $this.ISOPath       = 'C:\ISOPath\WinServer2016.iso'
    }
}

#########################
## Create Function ##
#########################

Function CreateNewVM
{
    [CmdletBinding(SupportsShouldProcess)]Param([NewVMConfig]$VM)
    
    $VMCheck = 'Unable to create VM correctly'
    New-VM -Name $VM.Name -Path $VM.VMPath -NewVHDPath $VM.NewVHDPath -NewVHDSizeBytes $VM.NewVHDSize -MemoryStartupBytes $VM.StartupMemory -BootDevice $VM.BootDevice -SwitchName $VM.NetworkSwitch -Generation $VM.Generation
    Set-VMDvdDrive -VMName $VM.Name -ControllerNumber 0 -ControllerLocation 2 -Path $VM.VMPath
    
    $VMCheck = Get-VM -Name $VM.Name  | Select-Object -Property *
    Return $VMCheck
}

#########################
## MAIN SYSTEM ##
#########################

$NewVM = [NewVMConfig]::New('WinServer2016')
CreateNewVM -VM $NewVM 
