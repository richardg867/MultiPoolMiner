using module ..\Include.psm1

$Path = ".\Bin\CPU-JayDDee\cpuminer-aes-avx.exe"
$Uri = "https://github.com/JayDDee/cpuminer-opt/files/1636873/cpuminer-opt-3.7.10-windows.zip"

$Commands = [PSCustomObject]@{
    "argon2" = "argon2" #
    #"axiom" = "axiom" #Shabal-256 MemoHash
    #"bastion" = "bastion" #
    "blake" = "blake" #Blake-256 (SFR)
    #"blakecoin" = "blakecoin" #blake256r8
    #"blake2s" = "blake2s" #Blake-2 S
    #"bmw" = "bmw" #BMW 256
    "c11" = "c11" #Chaincoin
    #"cryptolight" = "cryptolight" #Cryptonight-light
    #"cryptonight" = "cryptonight" #cryptonote, Monero (XMR)
    #"decred" = "decred" #
    "deep" = "deep" #Deepcoin (DCN)
    #"dmd-gr" = "dmd-gr" #Diamond-Groestl
    #"drop" = "drop" #Dropcoin
    #"fresh" = "fresh" #Fresh
    #"groestl" = "groestl" #Groestl coin
    #"heavy" = "heavy" #Heavy
    "hmq1725" = "hmq1725" #Espers
    "hodl" = "hodl" #Hodlcoin
    #"jha" = "jha" #Jackpotcoin
    #"keccak" = "keccak" #Maxcoin
    #"keccakc" = "keccakc" #Creative coin
    "lbry" = "lbry" #LBC, LBRY Credits
    #"luffa" = "luffa" #Luffa
    "lyra2h" = "lyra2h" #Hppcoin
    "lyra2re" = "lyra2re" #lyra2
    "lyra2v2" = "lyra2rev2" #lyra2v2, Vertcoin
    "lyra2re2" = "lyra2rev2" #lyra2v2, Vertcoin
    "lyra2z" = "lyra2z" #Zcoin (XZC)
    "lyra2z330" = "lyra2z330" #Lyra2 330 rows, Zoin (ZOI)
    "m7m" = "m7m" #Magi (XMG)
    "myr-gr" = "myr-gr" #Myriad-Groestl
    "myriad-groestl" = "myr-gr" #Myriad-Groestl
    #"neoscrypt" = "neoscrypt" #NeoScrypt(128, 2, 1)
    #"nist5" = "nist5" #Nist5
    #"pentablake" = "pentablake" #Pentablake
    #"phi1612" = "phi1612" #phi, LUX coin
    #"phi" = "phi1612" #phi, LUX coin
    #"pluck" = "pluck" #Pluck:128 (Supcoin)
    "polytimos" = "polytimos" #Ninja
    #"quark" = "quark" #Quark
    "qubit" = "qubit" #Qubit
    #"scrypt" = "scrypt" #scrypt(1024, 1, 1) (default)
    #"scrypt-n" = "scrypt:N" #scrypt(N, 1, 1)
    #"scrypt-jane" = "scryptjane:nf" #
    #"sha256d" = "sha256d" #Double SHA-256
    "sha256t" = "sha256t" #Triple SHA-256, Onecoin (OC)
    #"shavite3" = "shavite3" #Shavite3
    #"skein" = "skein" #Skein+Sha (Skeincoin)
    #"skein2" = "skein2" #Double Skein (Woodcoin)
    "skunk" = "skunk" #Signatum (SIGT)
    "timetravel" = "timetravel" #Machinecoin (MAC)
    "timetravel10" = "timetravel10" #Bitcore
    #"tribus" = "tribus" #Denarius (DNR)
    #"vanilla" = "vanilla" #blake256r8vnl (VCash)
    "veltor" = "veltor" #(VLT)
    #"whirlpool" = "whirlpool" #
    #"whirlpoolx" = "whirlpoolx" #
    "x11" = "x11" #Dash
    "x11evo" = "x11evo" #Revolvercoin
    "x11gost" = "x11gost" #sib (SibCoin)
    #"x13" = "x13" #X13
    #"x13sm3" = "x13sm3" #hsr (Hshare)
    "x14" = "x14" #X14
    "x15" = "x15" #X15
    "x17" = "x17" #
    "xevan" = "xevan" #Bitsend
    #"yescrypt" = "yescrypt" #Globalboost-Y (BSTY)
    #"yescryptr8" = "yescryptr8" #BitZeny (ZNY)
    #"yescryptr16" = "yescryptr16" #Yenten (YTN)
    #"zr5" = "zr5" #Ziftr
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$CpuInfo = & .\CHKCPU32 /X
If ($CpuInfo -like "*<aes>1</aes>*" -and $CpuInfo -like "*<avx>1</avx>*") {
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
}
