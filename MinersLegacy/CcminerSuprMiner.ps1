using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-SuprMiner\ccminer.exe"
$HashSHA256 = "6DE5DC4F109951AE1591D083F5C2A6494C9B59470C15EF6FBE5D38C50625304B"
$Uri = "https://github.com/ocminer/suprminer/releases/download/1.5/suprminer-1.5.7z"

$Commands = [PSCustomObject]@{
    "bitcore"    = "" #Bitcore
    "blake2s"    = "" #Blake2s
    "blakecoin"  = "" #Blakecoin
    "c11"        = "" #C11
    "decred"     = "" #Decred
    "groestl"    = "" #Groestl
    "hmq1725"    = "" #HMQ1725
    "hsr"        = "" #HSR
    "keccak"     = "" #Keccak
    "keccakc"    = "" #Keccakc
    "lbry"       = "" #Lbry
    "lyra2v2"    = "" #Lyra2RE2
    "lyra2z"     = "" #Lyra2z
    "myr-gr"     = "" #MyriadGroestl
    "neoscrypt"  = "" #NeoScrypt
    "nist5"      = "" #Nist5
    "phi"        = "" #PHI
    "quark"      = "" #Quark
    "qubit"      = "" #Qubit
    "sib"        = "" #Sib
    "skein"      = "" #Skein
    "skunk"      = "" #Skunk
    "timetravel" = "" #Timetravel
    "tribus"     = "" #Tribus
    "x11"        = "" #X11
    "x11evo"     = "" #X11evo
    "x12"        = "" #X12
    "x13"        = "" #X13
    "x14"        = "" #X14
    "x16r"       = "" #Raven
    "x16s"       = "" #Pigeon
    "x17"        = "" #X17
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    Switch ($Algorithm_Norm) {
        "PHI"   {$ExtendInterval = 3}
        "X16R"  {$ExtendInterval = 10}
        "X16S"  {$ExtendInterval = 10}
        default {$ExtendInterval = 0}
    }

    [PSCustomObject]@{
        Type           = "NVIDIA"
        Path           = $Path
        HashSHA256     = $HashSHA256
        Arguments      = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_)"
        HashRates      = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API            = "Ccminer"
        Port           = 4068
        URI            = $Uri
        ExtendInterval = $ExtendInterval
    }
}
