using module ..\Include.psm1

$Path = ".\Bin\CPU-TPruvot\cpuminer-gw64-core2.exe"
$Uri = "https://github.com/tpruvot/cpuminer-multi/releases/download/v1.3.1-multi/cpuminer-multi-rel1.3.1-x64.zip"

$Commands = [PSCustomObject]@{
    "scrypt" = "scrypt" # (Litecoin, Dogecoin, Feathercoin, ...)
    "scrypt-n" = "scrypt:N" # 
    "scrypt-jane" = "scrypt-jane:N" # 
    "sha256d" = "sha256d" # (Bitcoin, Freicoin, Peercoin/PPCoin, Terracoin, ...)
    "axiom" = "axiom" # (Axiom Shabal-256 based MemoHash)
    "bastion" = "bastion" # (Joincoin [J])
    "bitcore" = "bitcore" # Permuted serie of 10 algos (BitCore)
    "blake" = "blake" # (Saffron [SFR] Blake-256)
    "blake2s" = "blake2s" # (NevaCoin Blake2-S 256)
    "bmw" = "bmw" # (Midnight [MDT] BMW-256)
    "cryptonight" = "cryptonight" # (Bytecoin [BCN], Monero [XMR])
    "cryptolight" = "cryptonight-light" # (Aeon)
    "decred" = "decred" # (Blake256-14 [DCR])
    "dmd-gr" = "dmd-gr" # (Diamond-Groestl)
    "fresh" = "fresh" # (FreshCoin)
    "groestl" = "groestl" # (Groestlcoin)
    "jha" = "jha" # (JackpotCoin, SweepStake)
    "lbry" = "lbry" # (LBRY Credits [LBC])
    "lyra2re" = "lyra2RE" # (Cryptocoin)
    "lyra2v2" = "lyra2REv2" # (VertCoin [VTC])
    "lyra2re2" = "lyra2REv2" # (VertCoin [VTC])
    "myr-gr" = "myr-gr" # Myriad-Groestl (MyriadCoin [MYR])
    "myriad-groestl" = "myr-gr" # Myriad-Groestl (MyriadCoin [MYR])
    "neoscrypt" = "neoscrypt" # (Feathercoin)
    "nist5" = "nist5" # (MistCoin [MIC], TalkCoin [TAC], ...)
    "pentablake" = "pentablake" # (Joincoin)
    "pluck" = "pluck" # (Supcoin [SUP])
    "quark" = "quark" # (Quarkcoin)
    "qubit" = "qubit" # (GeoCoin)
    "skein" = "skein" # (Skeincoin, Myriadcoin, Xedoscoin, ...)
    "skein2" = "skein2" # (Woodcoin)
    "s3" = "s3" # (OneCoin)
    "sia" = "sia" # (Reversed Blake2B for SIA [SC])
    "sib" = "sib" # X11 + gost streebog (SibCoin)
    "timetravel" = "timetravel" # Permuted serie of 8 algos (MachineCoin [MAC])
    "tribus" = "tribus" # 3 of the top NIST5 algos (Denarius [DNR])
    "vanilla" = "vanilla" # (Blake-256 8-rounds - double sha256 [VNL])
    "veltor" = "veltor" # (Veltor [VLT])
    "xevan" = "xevan" # x17 x 2 on bigger header (BitSend [BSD])
    "x11evo" = "x11evo" # (Revolver [XRE])
    "x11" = "x11" # (Darkcoin [DRK], Hirocoin, Limecoin, ...)
    "x13" = "x13" # (Sherlockcoin, [ACE], [B2B], [GRC], [XHC], ...)
    "x14" = "x14" # (X14, Webcoin [WEB])
    "x15" = "x15" # (RadianceCoin [RCE])
    "x16r" = "x16r" # (Ravencoin [RVN])
    "x17" = "x17" # (Verge [XVG])
    "yescrypt" = "yescrypt" # (GlobalBoostY [BSTY], Unitus [UIS], MyriadCoin [MYR])
    "zr5" = "zr5" # (Ziftrcoin [ZRC])
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
    [PSCustomObject]@{
        Type = "CPU"
        Path = $Path
        Arguments = "-a $($Commands.$_) -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "Ccminer"
        Port = 4048
        URI = $Uri
    }
}
