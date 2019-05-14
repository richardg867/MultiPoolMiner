﻿using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Path = ".\Bin\$($Name)\lolminer.exe"
$HashSHA256 = "232DCC48979879A20A5FA9A58089854A113C598326F27548F3FFF64C5BEF5D6E"
$Uri = "https://github.com/MultiPoolMiner/miner-binaries/releases/download/lolMiner/lolMiner_v05_Win64_Bugfix.zip"
$ManualUri = "https://bitcointalk.org/index.php?topic=4724735.0"
$Port = "40{0:d2}"

$Commands = [PSCustomObject[]]@(
    [PSCustomObject]@{Algorithm = "Equihash965";  MinMemGB = 0.5; Fee = 1; Params = ""}
    [PSCustomObject]@{Algorithm = "Equihash1445"; MinMemGB = 3.0; Fee = 2; Params = ""}
    [PSCustomObject]@{Algorithm = "Equihash1927"; MinMemGB = 4.0; Fee = 2; Params = ""}
    [PSCustomObject]@{Algorithm = "Equihash2109"; MinMemGB = 1.0; Fee = 2; Params = ""}
)
$CommonCommands = " --workbatch HIGH"

$Coins = [PSCustomObject]@{
    "ManagedByPool" = "AUTO" #pers auto switching; https://bitcointalk.org/index.php?topic=2759935.msg43324268#msg43324268
    "Asofe"         = "ASF"
    "BitcoinZ"      = "BTCZ"
    "BitcoinCandy"  = "CDY" #new in 0.43b
    "BitcoinGold"   = "BTG"
    "BitcoinRM"     = "BCRM" #new in 0.43b
    "Genesis"       = "GENX"
    "LitecoinZ"     = "LTZ"
    "Heptacoin"     = "HEPTA"
    "MinexCoin"     = "MNX"
    "SafeCoin"      = "SAFE"
    "Zelcash"       = "ZEL"
    "Zero"          = "ZER"
    "Zerocoin"      = "ZER"
}

$Devices = $Devices | Where-Object Type -EQ "GPU"

$Devices | Select-Object Vendor, Model -Unique | ForEach-Object {
    $Device = @($Devices | Where-Object Vendor -EQ $_.Vendor | Where-Object Model -EQ $_.Model)
    $Miner_Port = $Port -f ($Device | Select-Object -First 1 -ExpandProperty Index)

    $Commands | Where-Object {$Pools.(Get-Algorithm $_.Algorithm).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Algorithm_Norm = Get-Algorithm $_.Algorithm
        $MinMem = $_.MinMemGB * 1GB
        $Params = $_.Params

        if ($Miner_Device = @($Device | Where-Object {$_.OpenCL.GlobalMemsize -ge ($MinMem)})) {

            if ($Config.UseDeviceNameForStatsFileNaming) {
                $Miner_Name = (@($Name) + @(($Miner_Device.Model_Norm | Sort-Object -unique | ForEach-Object {$Model_Norm = $_;"$(@($Miner_Device | Where-Object Model_Norm -eq $Model_Norm).Count)x$Model_Norm"}) -join '_') | Select-Object) -join '-'
            }
            else {
                $Miner_Name = (@($Name) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'
            }

            switch ($Algorithm_Norm) {
                "Equihash965" {
                    $Coin = "MNX"
                }
                "Equihash1445" {
                    if (($Coins | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name) -contains $Pools.$Algorithm_Norm.CoinName) {
                        #Coin parameter, different per coin
                        $Coin = $Coins."$($Pools.$Algorithm_Norm.CoinName)"
                    }
                    else {
                        #Try auto if no coinname is available
                        $Coin = "AUTO144_5"
                    }
                }
                "Equihash1927" {
                    $Coin = "ZER"
                }
                "Equihash2109" {
                    if (($Coins | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name) -contains $Pools.$Algorithm_Norm.CoinName) {
                        #Coin parameter, different per coin
                        $Coin = $Coins."$($Pools.$Algorithm_Norm.CoinName)"
                    }
                    else {
                        $Coin = "AUT210_9"
                    }
                }
            }

            if ($Coin) {
                #Disable_memcheck
                if ($Miner_Device.Vendor -eq "NVIDIA Corporation" -and $Algorithm_Norm -ne "Equihash965") {$Params += " -disable_memcheck=1"}

                $ConfigFileName = "$Miner_Name-$($Pools.$Algorithm_Norm.Name)-$($Pools.$Algorithm_Norm.Algorithm)-$Coin.txt"
                $Arguments = [PSCustomObject]@{
                    ConfigFile = [PSCustomObject]@{
                        FileName = $ConfigFilename
                        Content  = [PSCustomObject]@{
                            DEFAULT = [PSCustomObject]@{
                                APIPORT    = $Miner_Port
                                COIN       = $Coin
                                DEVICES    = @($Miner_Device | ForEach-Object {'{0:x}' -f $_.Type_Index})
                                POOLS      = @([PSCustomObject]@{
                                    POOL = $Pools.$Algorithm_Norm.Host
                                    PORT = $Pools.$Algorithm_Norm.Port
                                    USER = $Pools.$Algorithm_Norm.User
                                    PASS = $Pools.$Algorithm_Norm.Pass
                                })
                                SHORTSTATS = 10 #for more stable hash rate stats
                            }
                        }
                    }
                    Commands = ("--usercfg $ConfigFileName --profile DEFAULT$Params$CommonCommands" -replace "\s+", " ").trim()
                }

                [PSCustomObject]@{
                    Name             = $Miner_Name
                    DeviceName       = $Miner_Device.Name
                    Path             = $Path
                    HashSHA256       = $HashSHA256
                    Arguments        = $Arguments
                    HashRates        = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Miner_Name)_$($Algorithm_Norm)_HashRate".Week}
                    API              = "lolMiner"
                    Port             = $Miner_Port
                    URI              = $Uri
                    Fees             = [PSCustomObject]@{$Algorithm_Norm = $_.Fee / 100}
                }
            }
        }
    }
}
