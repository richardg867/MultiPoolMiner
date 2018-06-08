using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-Nanashi\ccminer.exe"
$HashSHA256 = "1974bab01a30826497a76b79e227f3eb1c9eb9ffa6756c801fcd630122bdb5c7"
$URI = "https://github.com/Nanashi-Meiyo-Meijin/ccminer/releases/download/v2.2-mod-r2/2.2-mod-r2-CUDA9.binary.zip"

$Commands = [PSCustomObject]@{
    "bastion"        = "" #bastion
    "bitcore"        = "" #Bitcore
    "blake"          = "" #blake
    "blake2s"        = "" #Blake2s
    "blakecoin"      = "" #Blakecoin
    "bmw"            = "" #bmw
    "c11"            = "" #C11
    "cryptolight"    = "" #cryptolight
    "cryptonight"    = "" #CryptoNight
    "decred"         = "" #Decred
    "deep"           = "" #deep
    "dmd-gr"         = "" #dmd-gr
    "fresh"          = "" #fresh
    "fugue256"       = "" #Fugue256
    "groestl"        = "" #Groestl
    "heavy"          = "" #heavy
    "hmq1725"        = "" #HMQ1725
    "jha"            = "" #JHA
    "keccak"         = "" #Keccak
    "lbry"           = "" #Lbry
    "luffa"          = "" #Luffa
    "lyra2"          = "" #lyra2re
    "lyra2v2"        = "" #Lyra2RE2
    "lyra2z"         = "" #Lyra2z, ZCoin
    "mjollnir"       = "" #Mjollnir
    "myr-gr"         = "" #MyriadGroestl
    "neoscrypt"      = "" #NeoScrypt
    "nist5"          = "" #Nist5
    "penta"          = "" #Pentablake
    "quark"          = "" #Quark
    "qubit"          = "" #Qubit
    "s3"             = "" #S3
    "scrypt"         = "" #Scrypt
    "scrypt:N"       = "" #scrypt:N
    "sha256d"        = "" #sha256d
    "sha256t"        = "" #sha256t
    "sia"            = "" #SiaCoin
    "sib"            = "" #Sib
    "skein"          = "" #Skein
    "skein2"         = "" #skein2
    "skunk"          = "" #Skunk
    "timetravel"     = "" #Timetravel
    "tribus"         = "" #Tribus
    "vanilla"        = "" #BlakeVanilla
    "veltor"         = "" #Veltor
    "whirlpool"      = "" #Whirlpool
    "wildkeccak"     = "" #wildkeccak
    "x11"            = "" #X11
    "x11evo"         = "" #X11evo
    "x13"            = "" #x13
    "x14"            = "" #x14
    "x15"            = "" #x15
    "x17"            = "" #x17
    "zr5"            = "" #zr5
    #"scryptjane:nf" = "" #scryptjane:nf
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type       = "NVIDIA"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_)"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "Ccminer"
        Port       = 4068
        URI        = $Uri
    }
}
