using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-KlausT\ccminer.exe"
$HashSHA256 = "EBF91E27F54DE29F158A4F5EBECEDB7E7E03EB9010331B2E949335BF1144A886"
$Uri = "https://github.com/KlausT/ccminer/releases/download/8.21/ccminer-821-cuda91-x64.zip"

$Commands = [PSCustomObject]@{
    #"bitcore"     = "" #Bitcore
    #"blake2s"     = "" #Blake2s
    #"blakecoin"   = "" #Blakecoin
    #"vanilla"     = "" #BlakeVanilla
    #"c11"         = "" #C11
    #"cryptonight" = "" #CryptoNight
    #"decred"      = "" #Decred
    #"equihash"    = "" #Equihash
    #"ethash"      = "" #Ethash
    "groestl"      = "" #Groestl
    #"hmq1725"     = "" #HMQ1725
    #"jha"         = "" #JHA
    #"keccak"      = "" #Keccak
    #"lbry"        = "" #Lbry
    #"lyra2v2"     = "" #Lyra2RE2
    #"lyra2z"      = "" #Lyra2z
    "myr-gr"       = "" #MyriadGroestl
    "neoscrypt"    = "" #NeoScrypt
    #"nist5"       = "" #Nist5
    #"pascal"      = "" #Pascal
    #"phi"         = "" #PHI
    #"sia"         = "" #Sia
    #"sib"         = "" #Sib
    #"skein"       = "" #Skein
    #"skunk"       = "" #Skunk
    #"timetravel"  = "" #Timetravel
    #"tribus"      = "" #Tribus
    #"veltor"      = "" #Veltor
    #"x11evo"      = "" #X11evo
    #"x17"         = "" #X17
    #"yescrypt"    = "" #Yescrypt
    #"xevan"       = "" #Xevan
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type       = "NVIDIA"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-a $_ -b 4068 -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_)"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "Ccminer"
        Port       = 4068
        URI        = $Uri
    }
}
