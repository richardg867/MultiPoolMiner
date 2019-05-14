﻿using module ..\Include.psm1

#XmRig AMD / Nvidia requires the explicit use of detailled thread information in the config file
#these values are different for each card model nad algorithm
#API will check for hw change and briefly start miner with an incomplete dummy config
#The miner binary it will add the thread element for all installed cards to the config file on first start
#Once this file is current we can retrieve the threads info

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)
$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Path = ".\Bin\$($Name)\xmrig-nvidia.exe"
$HashSHA256 = "9BFC602CD44085162107E23F83478ABF92362E4BADF3141AADF1BFF889D43E80"
$Uri = "https://github.com/xmrig/xmrig-nvidia/releases/download/v2.8.4/xmrig-nvidia-2.8.4-cuda-9_2-win64.zip"
$ManualUri = "https://github.com/xmrig/xmrig-nvidia"
$Port = "40{0:d2}"

# Miner requires CUDA 9.2
$DriverVersion = ((Get-Device | Where-Object Type -EQ "GPU" | Where-Object Vendor -EQ "NVIDIA Corporation").OpenCL.Platform.Version | Select-Object -Unique) -replace ".*CUDA ",""
$RequiredVersion = "9.2.00"
if ($DriverVersion -and [System.Version]$DriverVersion -lt [System.Version]$RequiredVersion) {
    Write-Log -Level Warn "Miner ($($Name)) requires CUDA version $($RequiredVersion) or above (installed version is $($DriverVersion)). Please update your Nvidia drivers. "
    return
}

$Commands = [PSCustomObject[]]@(
    # Note: For fine tuning directly edit [Pool]_[Algorithm]-[Port]-[User]-[Pass].json in the miner binary directory 
    [PSCustomObject]@{Algorithm = "cryptonight/0";           MinMemGB = 2; Params = ""} # CryptoNight    
    [PSCustomObject]@{Algorithm = "cryptonight/1";           MinMemGB = 2; Params = ""} # CryptoNightV7
    [PSCustomObject]@{Algorithm = "cryptonight/2";           MinMemGB = 2; Params = ""} # CryptoNightV8, new with 2.8.0rc
    [PSCustomObject]@{Algorithm = "cryptonight/msr";         MinMemGB = 2; Params = ""} # CryptoNightMsr
    [PSCustomObject]@{Algorithm = "cryptonight/rto";         MinMemGB = 2; Params = ""} # CryptoNightRto
    [PSCustomObject]@{Algorithm = "cryptonight/xao";         MinMemGB = 2; Params = ""} # CryptoNightXao
    [PSCustomObject]@{Algorithm = "cryptonight/xtl";         MinMemGB = 2; Params = ""} # CryptoNightXtl
    [PSCustomObject]@{Algorithm = "cryptonight-lite/0";      MinMemGB = 1; Params = ""} # CryptoNightLite
    [PSCustomObject]@{Algorithm = "cryptonight-lite/1";      MinMemGB = 1; Params = ""} # CryptoNightLiteV7
    [PSCustomObject]@{Algorithm = "cryptonight-lite/2";      MinMemGB = 1; Params = ""} # CryptoNightLiteV8
    [PSCustomObject]@{Algorithm = "cryptonight-heavy";       MinMemGB = 2; Params = ""} # CryptoNightHeavy
    [PSCustomObject]@{Algorithm = "cryptonight-heavy/tube";  MinMemGB = 2; Params = ""} # CryptoNightHeavyTube
    [PSCustomObject]@{Algorithm = "cryptonight-heavy/xhv";   MinMemGB = 2; Params = ""} # CryptoNightHeavyHaven
)
$CommonCommands = ""

$Devices = @($Devices | Where-Object Type -EQ "GPU" | Where-Object Vendor -EQ "NVIDIA Corporation")

$Devices | Select-Object Model -Unique | ForEach-Object {
    $Device = @($Devices | Where-Object Model -EQ $_.Model)
    $Miner_Port = $Port -f ($Device | Select-Object -First 1 -ExpandProperty Index)    

    $Commands | ForEach-Object {

        $Algorithm = $_.Algorithm
        $Algorithm_Norm = Get-Algorithm $Algorithm
        $MinMem = $_.MinMemGb * 1GB
        $Params = $_.Params
        
        if ($Miner_Device = @($Device | Where-Object {$_.OpenCL.GlobalMemsize -ge ($MinMem)})) {
            if ($Config.UseDeviceNameForStatsFileNaming) {
                $Miner_Name = (@($Name) + @(($Miner_Device.Model_Norm | Sort-Object -unique | ForEach-Object {$Model_Norm = $_;"$(@($Miner_Device | Where-Object Model_Norm -eq $Model_Norm).Count)x$Model_Norm"}) -join '_') | Select-Object) -join '-'
            }
            else {
                $Miner_Name = (@($Name) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'
            }

            #Get commands for active miner devices
            $Params = Get-CommandPerDevice $Params $Miner_Device.Type_Vendor_Index
            $ConfigFileName = "$((@($Pools.$Algorithm_Norm.Name) + @($Algorithm_Norm) + @($Miner_Device.Model_Norm -Join "_") + @($Miner_Port) + @($Pools.$Algorithm_Norm.User) + @($Pools.$Algorithm_Norm.Pass) | Select-Object) -join '-').json"
            $ThreadsConfigFileName = "$((@("ThreadsConfig") + @($Algorithm_Norm) + @($Miner_Device.Model_Norm -Join "_") | Select-Object) -join '-').json"

            $Arguments = [PSCustomObject]@{
                ConfigFile = [PSCustomObject]@{
                    FileName = $ConfigFileName
                    Content  = [PSCustomObject]@{
                        "algo"         = $Algorithm
                        "api" = [PSCustomObject]@{
                            "port"         = $Miner_Port
                            "access-token" = $null
                            "worker-id"    = $null
                        }
                        "background"   = $false
                        "cuda-bfactor" = 11
                        "colors"       = $true
                        "donate-level" = 1
                        "log-file"     = $null
                        "print-time"   = 5
                        "retries"      = 5
                        "retry-pause"  = 5
                        "pools"        = @([PSCustomObject]@{
                            "keepalive" = $true
                            "nicehash"  = ($Pools.$Algorithm_Norm.Name -eq 'Nicehash')
                            "pass"      = "$($Pools.$Algorithm_Norm.Pass)"
                            "url"       = "$($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port)"
                            "user"      = "$($Pools.$Algorithm_Norm.User)"
                            "rig-id"    = "$WorkerName"
                            "tls"       = ($Pools.$Algorithm_Norm.SSL)
                        })
                    }
                }
                Commands = ("--config=$ConfigFileName --cuda-devices=$(($Miner_Device | ForEach-Object {'{0:x}' -f $_.Type_Vendor_Index}) -join ',')$Params$CommonCommands" -replace "\s+", " ").trim()
                ThreadsConfigFileName = $ThreadsConfigFileName
                HwDetectCommands = "--config=$ThreadsConfigFileName$Params$CommonCommands"
                Devices  = @($Miner_Device.Type_Vendor_Index)
            }

            [PSCustomObject]@{
                Name       = $Miner_Name
                DeviceName = $Miner_Device.Name
                Path       = $Path
                HashSHA256 = $HashSHA256
                Arguments  = $Arguments
                HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Miner_Name)_$($Algorithm_Norm)_HashRate".Week}
                API        = "XmRigCfgFile"
                Port       = $Miner_Port
                URI        = $Uri
                Fees       = [PSCustomObject]@{$Algorithm_Norm = 1 / 100}
            }
        }
    }
}
