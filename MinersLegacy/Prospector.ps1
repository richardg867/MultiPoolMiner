using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Path = ".\Bin\Prospector\prospector.exe"
$HashSHA256 = "0EFDB477DC52A7964536E29140A4A8B87F0A158C4BEDF0A57B2FE078BA7C0D4F"
$Uri = "https://github.com/semtexzv/Prospector/releases/download/0.1.0/prospector-0.1.0-win64.zip"
$Port = "42{0:d3}"

# Custom algorithm table required, as Prospector's CryptoNight is V7 unless otherwise stated
$Commands = [PSCustomObject]@{
    "Ethash"        = "ethash"
    "Ethash2gb"     = "ethash"
    "CryptoNight"   = "cryptonight-v1"
    "CryptoNightV7" = "cryptonight"
    "Sia"           = "blake2b"
    "Skunk"         = "skunkhash"
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName
$Devices = $Devices | Where-Object Type -EQ "GPU"

$Devices | Select-Object Vendor, Model -Unique | ForEach-Object {
    $Miner_Device = $Devices | Where-Object Vendor -EQ $_.Vendor | Where-Object Model -EQ $_.Model
    $Miner_Port = $Port -f ($Miner_Device | Select-Object -First 1 -ExpandProperty Index)

    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Host} | ForEach-Object {
        $Algorithm_Norm = Get-Algorithm $_

        $DeviceNames = @($Miner_Device.Name | Sort-Object) -join '_'

        if (Test-Path (Split-Path $Path)) {
            $ConfigFile = "[general]
gpu-algo = ""$($Commands.$_)""
api-port = $Miner_Port
[pools.$($Commands.$_)]
url = ""$($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port)/""
username = ""$($Pools.$Algorithm_Norm.User)""
password = ""$($Pools.$Algorithm_Norm.Pass)""
[cpu]
enabled = false
"
            
            $Miner_Device | ForEach-Object {
                $ConfigFile += "[gpus.$($_.PlatformId_Index)-$($_.Type_Vendor_Index)]
enabled = true
"
            }

            try {
                $ConfigFile | Set-Content "$(Split-Path $Path)\$($Pools.$Algorithm_Norm.Name)_$($Algorithm_Norm)_$($Pools.$Algorithm_Norm.User)_$($DeviceNames).toml" -Force -ErrorAction Stop
            } catch {} # file is locked
        }

        $WorkingDirectory = "$(Split-Path $Path)\$Miner_Name"
        if (-not (Test-Path $WorkingDirectory)) {
            New-Item $WorkingDirectory -Type Directory
        }

        $Miner_Name = (@($Name) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'
        
        [PSCustomObject]@{
            Name       = $Miner_Name
            DeviceName = $Miner_Device.Name
            Path       = $Path
            HashSHA256 = $HashSHA256
            Arguments  = "--config ""$(Resolve-Path $(Split-Path $Path))\$($Pools.$Algorithm_Norm.Name)_$($Algorithm_Norm)_$($Pools.$Algorithm_Norm.User)_$($DeviceNames).toml"""
            HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Miner_Name)_$($Algorithm_Norm)_HashRate".Week}
            API        = "Prospector"
            Port       = $Miner_Port
            URI        = $Uri
        }
    }
}
