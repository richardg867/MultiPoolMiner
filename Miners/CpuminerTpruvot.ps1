using module ..\Include.psm1

$Path = ".\Bin\CPU-TPruvot\"
$Binaries = @()
$CpuInfo = [string](.\CHKCPU32 /X)
If ($CpuInfo -like "*<avx2>1</avx2>*") {
    $Binaries += "cpuminer-gw64-avx2.exe"
}
If ($CpuInfo -like "*<sse42>1</sse42>*") {
    $Binaries += "cpuminer-gw64-corei7.exe"
}
If ($CpuInfo -like "*<ssse3>1</ssse3>*") {
    $Binaries += "cpuminer-gw64-core2.exe"
}
$L3Cache = 0
If ($CpuInfo -match "<l3>(\d+) KB</l3>") {
    $L3Cache = [int]$Matches[1]
    If ($CpuInfo -match "<physical_cpus>(\d+)</physical_cpus>") {
        $L3Cache *= [int]$Matches[1]
    }
}

$Uri = "https://github.com/tpruvot/cpuminer-multi/releases/download/v1.3.1-multi/cpuminer-multi-rel1.3.1-x64.zip"

$Commands = [PSCustomObject]@{
    "scrypt" = "" # (Litecoin, Dogecoin, Feathercoin, ...)
    "scrypt-jane:16" = "" # 
    "sha256d" = "" # (Bitcoin, Freicoin, Peercoin/PPCoin, Terracoin, ...)
    "axiom" = "" # (Axiom Shabal-256 based MemoHash)
    "bastion" = "" # (Joincoin [J])
    "blake" = "" # (Saffron [SFR] Blake-256)
    "blake2s" = "" # (NevaCoin Blake2-S 256)
    "bmw" = "" # (Midnight [MDT] BMW-256)
    "cryptonight" = " -t $([Math]::Max([int]($L3Cache / 2048), 1))" # (Bytecoin [BCN], Monero [XMR])
    "cryptonight-light" = " -t $([Math]::Max([int]($L3Cache / 1024), 1))" # (Aeon)
    "decred" = "" # (Blake256-14 [DCR])
    "dmd-gr" = "" # (Diamond-Groestl)
    "fresh" = "" # (FreshCoin)
    "groestl" = "" # (Groestlcoin)
    "lbry" = "" # (LBRY Credits [LBC])
    "lyra2re" = "" # (Cryptocoin)
    "lyra2REv2" = "" # (VertCoin [VTC])
    "myr-gr" = "" # Myriad-Groestl (MyriadCoin [MYR])
    "neoscrypt" = "" # (Feathercoin)
    "nist5" = "" # (MistCoin [MIC], TalkCoin [TAC], ...)
    "pentablake" = "" # (Joincoin)
    "pluck" = "" # (Supcoin [SUP])
    "quark" = "" # (Quarkcoin)
    "qubit" = "" # (GeoCoin)
    "skein" = "" # (Skeincoin, Myriadcoin, Xedoscoin, ...)
    "skein2" = "" # (Woodcoin)
    "s3" = "" # (OneCoin)
    "sia" = "" # (Reversed Blake2B for SIA [SC])
    "sib" = "" # X11 + gost streebog (SibCoin)
    "timetravel" = "" # Permuted serie of 8 algos (MachineCoin [MAC])
    "vanilla" = "" # (Blake-256 8-rounds - double sha256 [VNL])
    "veltor" = "" # (Veltor [VLT])
    "xevan" = "" # x17 x 2 on bigger header (BitSend [BSD])
    "x11evo" = "" # (Revolver [XRE])
    "x11" = "" # (Darkcoin [DRK], Hirocoin, Limecoin, ...)
    "x13" = "" # (Sherlockcoin, [ACE], [B2B], [GRC], [XHC], ...)
    "x14" = "" # (X14, Webcoin [WEB])
    "x15" = "" # (RadianceCoin [RCE])
    "x17" = "" # (Verge [XVG])
    "yescrypt" = "" # (GlobalBoostY [BSTY], Unitus [UIS], MyriadCoin [MYR])
    "zr5" = "" # (Ziftrcoin [ZRC])
}
# Algorithms which crash in specific optimization modes
$DisableAVX2 = @("neoscrypt")
$DisableCorei7 = @("neoscrypt")

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

If ($Binaries.Length -gt 0) {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Binary = 0
        If ($_ -in $DisableAVX2) {
            While ($Binaries[$Binary] -like "*-avx2.exe") {
                $Binary += 1
            }
        }
        If ($_ -in $DisableCorei7) {
            While ($Binaries[$Binary] -like "*-corei7.exe") {
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
