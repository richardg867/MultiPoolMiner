using module ..\Include.psm1

$Path = ".\Bin\CPU-JayDDee\"
$Binaries = @()
$CpuInfo = [string](.\CHKCPU32 /X)
If ($CpuInfo -like "*<avx2>1</avx2>*") {
    If ($CpuInfo -like "*<sha>1</sha>*") {
        $Binaries += "cpuminer-avx2-sha.exe"
    }
    $Binaries += "cpuminer-avx2.exe"
}
If ($CpuInfo -like "*<aes>1</aes>*") {
    If ($CpuInfo -like "*<avx>1</avx>*") {
        $Binaries += "cpuminer-aes-avx.exe"
    }
    If ($CpuInfo -like "*<sse42>1</sse42>*") {
        $Binaties += "cpuminer-aes-sse42.exe"
    }
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

$Uri = "https://github.com/JayDDee/cpuminer-opt/files/1838763/cpuminer-opt-3.8.4.1-windows.zip"

$Commands = [PSCustomObject]@{
    "allium" = "" #Garlicoin
    "anime" = "" #Animecoin
    "argon2" = "" #
    "axiom" = "" #Shabal-256 MemoHash
    "bastion" = "" #
    "blake" = "" #Blake-256 (SFR)
    "blakecoin" = "" #blake256r8
    "blake2s" = "" #Blake-2 S
    "c11" = "" #Chaincoin
    "cryptolight" = " -t $([Math]::Max([int]($L3Cache / 1024), 1))" #Cryptonight-light
    "cryptonight" = " -t $([Math]::Max([int]($L3Cache / 2048), 1))" #cryptonote, Monero (XMR)
    "decred" = "" #
    "deep" = "" #Deepcoin (DCN)
    "dmd-gr" = "" #Diamond-Groestl
    "drop" = "" #Dropcoin
    "fresh" = "" #Fresh
    "groestl" = "" #Groestl coin
    "hmq1725" = "" #Espers
    "hodl" = "" #Hodlcoin
    "jha" = "" #Jackpotcoin
    "keccak" = "" #Maxcoin
    "keccakc" = "" #Creative coin
    "lbry" = "" #LBC, LBRY Credits
    "luffa" = "" #Luffa
    "lyra2h" = "" #Hppcoin
    "lyra2re" = "" #lyra2
    "lyra2rev2" = "" #lyra2v2, Vertcoin
    "lyra2z" = "" #Zcoin (XZC)
    "lyra2z330" = "" #Lyra2 330 rows, Zoin (ZOI)
    "m7m" = "" #Magi (XMG)
    "myr-gr" = "" #Myriad-Groestl
    "neoscrypt" = "" #NeoScrypt(128, 2, 1)
    "nist5" = "" #Nist5
    "pentablake" = "" #Pentablake
    "phi1612" = "" #phi, LUX coin
    "pluck" = "" #Pluck:128 (Supcoin)
    "polytimos" = "" #Ninja
    "quark" = "" #Quark
    "qubit" = "" #Qubit
    "scrypt" = "" #scrypt(1024, 1, 1) (default)
    "scryptjane:16" = "" #
    "sha256d" = "" #Double SHA-256
    "sha256t" = "" #Triple SHA-256, Onecoin (OC)
    "skein" = "" #Skein+Sha (Skeincoin)
    "skein2" = "" #Double Skein (Woodcoin)
    "skunk" = "" #Signatum (SIGT)
    "timetravel" = "" #Machinecoin (MAC)
    "timetravel10" = "" #Bitcore
    "tribus" = "" #Denarius (DNR)
    "vanilla" = "" #blake256r8vnl (VCash)
    "veltor" = "" #(VLT)
    "whirlpool" = "" #
    "whirlpoolx" = "" #
    "x11" = "" #Dash
    "x11evo" = "" #Revolvercoin
    "x11gost" = "" #sib (SibCoin)
    "x12" = "" #Galaxy Cash
    "x13" = "" #X13
    "x13sm3" = "" #hsr (Hshare)
    "x14" = "" #X14
    "x15" = "" #X15
    "x16r" = "" #Ravencoin
    "x17" = "" #
    "xevan" = "" #Bitsend
    "yescrypt" = "" #Globalboost-Y (BSTY)
    "yescryptr8" = "" #BitZeny (ZNY)
    "yescryptr16" = "" #Yenten (YTN)
    "yescryptr32" = "" #WAVI
    "zr5" = "" #Ziftr
}
# Algorithms which crash in specific optimization modes
$DisableAVX2 = @("neoscrypt")
$DisableAVX = @("neoscrypt")

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

If ($Binaries.Length -gt 0) {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Binary = 0
        If ($_ -in $DisableAVX2) {
            While ($Binaries[$Binary] -like "*avx2*.exe") {
                $Binary += 1
            }
        }
        If ($_ -in $DisableAVX) {
            While ($Binaries[$Binary] -like "*-avx.exe") {
                $Binary += 1
            }
        }

        [PSCustomObject]@{
            Type = "CPU"
            Path = $Path + $Binaries[$Binary]
            Arguments = "-a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
            HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
            API = "Ccminer"
            Port = 4048
            URI = $Uri
        }
    }
}
