﻿using module ..\Include.psm1

$Path = ".\Bin\CPU-JayDDee\"
$HashSHA256 = [PSCustomObject]@{
    "cpuminer-aes-sse42.exe" = "01E0C00B21396E982D09DBCF23F766BA69344829A9DD1E5409975971A620AC3D"
    "cpuminer-avx.exe"       = "3D72E0F130E6104C0E1117DE887B5E55CC4A8C77E17A8B646A2580A9873A6381"
    "cpuminer-avx2.exe"      = "8F37B5BAD9D6A3AE1BA488C680B7DE2B244D1D012BCE105E6C2C7AB86DEEF6D0"
    "cpuminer-avx2-sha.exe"  = "188066A1767071CEF10D74DFA8A0F629FCACBDF28C98E1D2DAA89519F923D415"
    "cpuminer-sse2.exe"      = "3DEC184FA2E26CF3A474FDFFED8FF1AD61A51E9E7A85D48547FE99C801FB7380"
}
$Binaries = @()
$CpuInfo = [string](.\CHKCPU32 /X)
If ($CpuInfo -like "*<avx2>1</avx2>*") {
    If ($CpuInfo -like "*<sha>1</sha>*") {
        $Binaries += "cpuminer-avx2-sha.exe"
    }
    $Binaries += "cpuminer-avx2.exe"
}
If ($CpuInfo -like "*<aes>1</aes>*" -and $CpuInfo -like "*<sse42>1</sse42>*") {
    $Binaries += "cpuminer-aes-sse42.exe"
}
If ($CpuInfo -like "*<sse2>1</sse2>*") {
    $Binaries += "cpuminer-sse2.exe"
}
$L3Cache = 0
If ($CpuInfo -match "<l3>(\d+) KB</l3>") {
    $L3Cache = [int]$Matches[1]
    If ($CpuInfo -match "<physical_cpus>(\d+)</physical_cpus>") {
        $L3Cache *= [int]$Matches[1]
    }
}

$Uri = "https://github.com/JayDDee/cpuminer-opt/files/1996977/cpuminer-opt-3.8.8.1-windows.zip"

$Commands = [PSCustomObject]@{
    "allium"        = "" # Garlicoin
    "anime"         = "" # Animecoin
    "argon2"        = "" # 
    "argon2d250"    = "" # Argon2d-CRDS
    "argon2d500"    = "" # Argon2d-DYN
    "argon2d4096"   = "" # Argon2d-UIS
    "axiom"         = "" # Shabal-256 MemoHash
    "bastion"       = "" # 
    "blake"         = "" # Blake-256 (SFR)
    "blakecoin"     = "" # blake256r8
    "blake2s"       = "" # Blake-2 S
    "c11"           = "" # Chaincoin
    "cryptolight"   = " -t $([Math]::Max([Math]::Floor($L3Cache / 1024), 1))" # Cryptonight-light
    "cryptonight"   = " -t $([Math]::Max([Math]::Floor($L3Cache / 2048), 1))" # cryptonote, Monero (XMR)
    "cryptonightv7" = " -t $([Math]::Max([Math]::Floor($L3Cache / 2048), 1))" # Cryptonight V7
    "decred"        = "" # 
    "deep"          = "" # Deepcoin (DCN)
    "dmd-gr"        = "" # Diamond-Groestl
    "drop"          = "" # Dropcoin
    "fresh"         = "" # Fresh
    "groestl"       = "" # Groestl coin
    "hmq1725"       = "" # Espers
    "hodl"          = "" # Hodlcoin
    "jha"           = "" # Jackpotcoin
    "keccak"        = "" # Maxcoin
    "keccakc"       = "" # Creative coin
    "lbry"          = "" # LBC, LBRY Credits
    "luffa"         = "" # Luffa
    "lyra2h"        = "" # Hppcoin
    "lyra2re"       = "" # lyra2
    "lyra2rev2"     = "" # lyra2v2, Vertcoin
    "lyra2z"        = "" # Zcoin (XZC)
    "lyra2z330"     = "" # Lyra2 330 rows, Zoin (ZOI)
    "m7m"           = "" # Magi (XMG)
    "myr-gr"        = "" # Myriad-Groestl
    "neoscrypt"     = "" # NeoScrypt(128, 2, 1)
    "nist5"         = "" # Nist5
    "pentablake"    = "" # Pentablake
    "phi1612"       = "" # phi, LUX coin
    "pluck"         = "" # Pluck:128 (Supcoin)
    "polytimos"     = "" # Ninja
    "quark"         = "" # Quark
    "qubit"         = "" # Qubit
    "scrypt"        = "" # scrypt(1024, 1, 1) (default)
    "scryptjane"    = "" # 
    "sha256d"       = "" # Double SHA-256
    "sha256t"       = "" # Triple SHA-256, Onecoin (OC)
    "skein"         = "" # Skein+Sha (Skeincoin)
    "skein2"        = "" # Double Skein (Woodcoin)
    "skunk"         = "" # Signatum (SIGT)
    "timetravel"    = "" # Machinecoin (MAC)
    "timetravel10"  = "" # Bitcore
    "tribus"        = "" # Denarius (DNR)
    "vanilla"       = "" # blake256r8vnl (VCash)
    "veltor"        = "" # (VLT)
    "whirlpool"     = "" # 
    "whirlpoolx"    = "" # 
    "x11"           = "" # Dash
    "x11evo"        = "" # Revolvercoin
    "x11gost"       = "" # sib (SibCoin)
    "x12"           = "" # Galaxy Cash
    "x13"           = "" # X13
    "x13sm3"        = "" # hsr (Hshare)
    "x14"           = "" # X14
    "x15"           = "" # X15
    "x16r"          = "" # Ravencoin
    "x16s"          = "" # Pigeoncoin
    "x17"           = "" # 
    "xevan"         = "" # Bitsend
    "yescrypt"      = "" # Globalboost-Y (BSTY)
    "yescryptr8"    = "" # BitZeny (ZNY)
    "yescryptr16"   = "" # Yenten (YTN)
    "yescryptr32"   = "" # WAVI
    "zr5"           = "" # Ziftr
}
# Algorithms which crash in AVX modes
$ForceLegacy = @("neoscrypt")

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

If ($Binaries.Length -gt 0) {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Binary = 0
        If ($_ -in $ForceLegacy) {
            While ($Binaries[$Binary] -like "*avx*") {
                $Binary += 1
            }
        }

        [PSCustomObject]@{
            Type = "CPU"
            Path = $Path + $Binaries[$Binary]
            HashSHA256 = $HashSHA256[$Binaries[$Binary]]
            Arguments = "-a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
            HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
            API = "Ccminer"
            Port = 4048
            URI = $Uri
        }
    }
}
