﻿using module ..\Include.psm1

$Path = ".\Bin\AMD-Avermore\sgminer.exe"
$HashSHA256 = "3BB5081AB3D1DDECA6BCB63914F3D1C5C39387FB423D1234F4CB9E05ED79B149"
$Uri = "https://github.com/brian112358/avermore-miner/releases/download/v1.4.1/avermore-v1.4.1-windows.zip"

$Commands = [PSCustomObject]@{
    "blake256r8"  = " --gpu-threads 2 --intensity d" #Blake256r8
    "blake256r14" = " --gpu-threads 2 --intensity d" #Blake256r14
    "maxcoin"     = " --gpu-threads 2 --intensity d" #Keccak
    "whirlpool"   = " --intensity d" #Whirlpool
    "x16r"        = " -w 64 -g 2 -X 256" #X16R (Ravencoin)
    "x16s"        = " -w 64 -g 2 -X 256" #X16S (Pigeoncoin)
    "xevan"       = " --intensity d" #Xevan
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
    [PSCustomObject]@{
        Type = "AMD"
        Path = $Path
        Arguments = "--api-listen -k $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_) --text-only --gpu-platform $([array]::IndexOf(([OpenCl.Platform]::GetPlatformIDs() | Select-Object -ExpandProperty Vendor), 'Advanced Micro Devices, Inc.'))"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "Xgminer"
        Port = 4028
        URI = $Uri
    }
}
