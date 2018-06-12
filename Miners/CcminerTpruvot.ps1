using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-TPruvot\ccminer-x64.exe"
$HashSHA256 = "9156D5FC42DAA9C8739D04C3456DA8FBF3E9DC91D4894D351334F69A7CEE58C5"
$Uri = "https://github.com/tpruvot/ccminer/releases/download/2.2.5-tpruvot/ccminer-x64-2.2.5-cuda9.7z"

$Commands = [PSCustomObject]@{
    "bastion"        = "" #bastion
    "bitcore"        = "" #Bitcore
    "blake"          = "" #blake
    "blake2s"        = "" #Blake2s
    "blakecoin"      = "" #Blakecoin
    "bmw"            = "" #bmw
    "decred"         = "" #Decred
    "deep"           = "" #deep
    "dmd-gr"         = "" #dmd-gr
    "equihash"       = "" #Equihash - Beaten by Bminer by 30%
    "fresh"          = "" #fresh
    "fugue256"       = "" #Fugue256
    "groestl"        = "" #Groestl
    "hmq1725"        = "" #HMQ1725
    "jackpot"        = "" #JackPot
    "keccak"         = "" #Keccak
    "keccakc"        = "" #keccakc
    "lbry"           = "" #Lbry
    "luffa"          = "" #Luffa
    "lyra2"          = "" #lyra2re
    "lyra2v2"        = "" #Lyra2RE2
    "lyra2z"         = "" #Lyra2z, ZCoin
    "myr-gr"         = "" #MyriadGroestl
    "neoscrypt"      = "" #NeoScrypt
    "nist5"          = "" #Nist5
    "penta"          = "" #Pentablake
    "phi"            = "" #PHI
    "polytimos"      = "" #Polytimos
    "quark"          = "" #Quark
    "qubit"          = "" #Qubit
    "s3"             = "" #S3
    "scrypt"         = "" #Scrypt
    #"scrypt:N"      = "" #scrypt:N
    #"scryptjane:nf" = "" #scryptjane:nf
    "sha256d"        = "" #sha256d
    "sha256t"        = "" #sha256t
    "sia"            = "" #SiaCoin
    "sib"            = "" #Sib
    "skein2"         = "" #skein2
    "timetravel"     = "" #Timetravel
    "tribus"         = "" #Tribus
    "vanilla"        = "" #BlakeVanilla
    "veltor"         = "" #Veltor
    "wildkeccak"     = "" #wildkeccak
    "x11"            = "" #X11
    "x11evo"         = "" #X11evo
    "x12"            = "" #X12
    "x13"            = "" #x13
    "x14"            = "" #x14
    "x15"            = "" #x15
    "x16r"           = "" #X16r
    "zr5"            = "" #zr5
    #"c11"           = "" #C11
    #"skein"         = "" #Skein
    #"skunk"         = "" #Skunk
    #"whirlpool"     = "" #Whirlpool
    #"whirlpoolx"    = "" #whirlpoolx
    #"x16s"          = "" #X16s
    #"x17"           = "" #x17
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type       = "NVIDIA"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_) --submit-stale"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "Ccminer"
        Port       = 4068
        URI        = $Uri
    }
}
