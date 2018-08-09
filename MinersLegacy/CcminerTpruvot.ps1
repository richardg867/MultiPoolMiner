using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-CcminerTPruvot\ccminer-x64.exe"
$HashSHA256 = "8051774049A412DBA64D9A699337797E7077AE45D564ECC7DEA36C0270E91F6A"
$Uri = "https://github.com/tpruvot/ccminer/releases/download/2.3-tpruvot/ccminer-2.3-cuda9.7z"

$Commands = [PSCustomObject]@{
    "allium"        = "" #Garlic
    "bastion"       = "" #bastion
    "bitcore"       = "" #Bitcore
    "blake"         = "" #blake
    "blake2s"       = "" #Blake2s
    "blakecoin"     = "" #Blakecoin
    "bmw"           = "" #bmw
    "c11"           = "" #C11
    "decred"        = "" #Decred
    "deep"          = "" #deep
    "dmd-gr"        = "" #dmd-gr
    "equihash"      = "" #Equihash
    "fresh"         = "" #fresh
    "fugue256"      = "" #Fugue256
    "groestl"       = "" #Groestl
    "hmq1725"       = "" #HMQ1725
    "jackpot"       = "" #JackPot
    "keccak"        = "" #Keccak
    "keccakc"       = "" #keccakc
    "lbry"          = "" #Lbry
    "luffa"         = "" #Luffa
    "lyra2"         = "" #lyra2re
    "lyra2v2"       = "" #Lyra2RE2
    "lyra2z"        = "" #Lyra2z, ZCoin
    "myr-gr"        = "" #MyriadGroestl
    "neoscrypt"     = "" #NeoScrypt
    "nist5"         = "" #Nist5
    "penta"         = "" #Pentablake
    "phi"           = "" #old PHI
    "phi2"          = "" #LUX
    "polytimos"     = "" #Polytimos
    "quark"         = "" #Quark
    "qubit"         = "" #Qubit
    "s3"            = "" #S3
    "scrypt:N"      = "" #scrypt:N
    "scrypt"        = "" #Scrypt
    "scryptjane:nf" = "" #scryptjane:nf
    "sha256d"       = "" #sha256d
    "sha256t"       = "" #sha256t
    "sia"           = "" #SiaCoin
    "sib"           = "" #Sib
    "skein"         = "" #Skein
    "skein2"        = "" #skein2
    "skunk"         = "" #Skunk
    "timetravel"    = "" #Timetravel
    "tribus"        = "" #Tribus
    "vanilla"       = "" #BlakeVanilla
    "veltor"        = "" #Veltor
    "whirlpool"     = "" #Whirlpool
    "whirlpoolx"    = "" #whirlpoolx
    "wildkeccak"    = "" #wildkeccak
    "x11"           = "" #X11
    "x11evo"        = "" #X11evo
    "x12"           = "" #X12
    "x13"           = "" #x13
    "x14"           = "" #x14
    "x15"           = "" #x15
    "x16r"          = "" #X16r
    "x16s"          = "" #X16s
    "x17"           = "" #x17
    "zr5"           = "" #zr5
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    Switch ($Algorithm_Norm) {
        "PHI"   {$ExtendInterval = 3}
        "X16R"  {$ExtendInterval = 10}
        default {$ExtendInterval = 0}
    }

    [PSCustomObject]@{
        Type           = "NVIDIA"
        Path           = $Path
        HashSHA256     = $HashSHA256
        Arguments      = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_) --submit-stale"
        HashRates      = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API            = "Ccminer"
        Port           = 4068
        URI            = $Uri
        ExtendInterval = $ExtendInterval
    }
}
