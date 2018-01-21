using module ..\Include.psm1

$Path = ".\Bin\CPU-TPruvot\cpuminer-gw64-core2.exe"
$Uri = "https://github.com/tpruvot/cpuminer-multi/releases/download/v1.3.1-multi/cpuminer-multi-rel1.3.1-x64.zip"

$Commands = [PSCustomObject]@{
    "scrypt" = "" # (Litecoin, Dogecoin, Feathercoin, ...)
    "scrypt-jane:16" = "" # 
    "sha256d" = "" # (Bitcoin, Freicoin, Peercoin/PPCoin, Terracoin, ...)
    "axiom" = "" # (Axiom Shabal-256 based MemoHash)
    "bastion" = "" # (Joincoin [J])
    "bitcore" = "" # Permuted serie of 10 algos (BitCore)
    "blake" = "" # (Saffron [SFR] Blake-256)
    "blake2s" = "" # (NevaCoin Blake2-S 256)
    "bmw" = "" # (Midnight [MDT] BMW-256)
    "cryptonight" = "" # (Bytecoin [BCN], Monero [XMR])
    "cryptonight-light" = "" # (Aeon)
    "decred" = "" # (Blake256-14 [DCR])
    "dmd-gr" = "" # (Diamond-Groestl)
    "fresh" = "" # (FreshCoin)
    "groestl" = "" # (Groestlcoin)
    "jha" = "" # (JackpotCoin, SweepStake)
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
    "tribus" = "" # 3 of the top NIST5 algos (Denarius [DNR])
    "vanilla" = "" # (Blake-256 8-rounds - double sha256 [VNL])
    "veltor" = "" # (Veltor [VLT])
    "xevan" = "" # x17 x 2 on bigger header (BitSend [BSD])
    "x11evo" = "" # (Revolver [XRE])
    "x11" = "" # (Darkcoin [DRK], Hirocoin, Limecoin, ...)
    "x13" = "" # (Sherlockcoin, [ACE], [B2B], [GRC], [XHC], ...)
    "x14" = "" # (X14, Webcoin [WEB])
    "x15" = "" # (RadianceCoin [RCE])
    "x16r" = "" # (Ravencoin [RVN])
    "x17" = "" # (Verge [XVG])
    "yescrypt" = "" # (GlobalBoostY [BSTY], Unitus [UIS], MyriadCoin [MYR])
    "zr5" = "" # (Ziftrcoin [ZRC])
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$CpuInfo = & .\CHKCPU32 /X
If ($CpuInfo -like "*<ssse3>1</ssse3>*") {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        [PSCustomObject]@{
            Type = "CPU"
            Path = $Path
            Arguments = "-a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
            HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
            API = "Ccminer"
            Port = 4048
            URI = $Uri
        }
    }
}
