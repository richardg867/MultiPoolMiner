using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-Alexis78hsr\ccminer.exe"
$HashSHA256 = "B0222106230616A31A93811640E8488BDCDA0FBF9EE2C5AD7EB1B3F4E4421884"
$Uri = "https://github.com/nemosminer/ccminerAlexis78/releases/download/Alexis78-v1.2/ccminerAlexis78v1.2x32.7z"

$Commands = [PSCustomObject]@{
    #Intensities and parameters tested by nemosminer on 10603gb to 1080ti
    "blake"       = "" #blake
    "blake2s"     = "" #Blake2s
    "blakecoin"   = "" #Blakecoin
    "c11"         = " -i 21" #X11evo; fix for default intensity
    "cryptolight" = "" #cryptolight
    "cryptonight" = "" #CryptoNight
    "decred"      = "" #Decred
    "hsr"         = "" #HSR, HShare
    "keccak"      = " -m 2 -i 29" #Keccak; fix for default intensity, difficulty x M
    "keccakc"     = " -i 29" #Keccakc; fix for default intensity
    "lbry"        = "" #Lbry
    "lyra2"       = "" #Lyra2
    "lyra2v2"     = "" #lyra2v2
    "myr-gr"      = "" #MyriadGroestl
    "neoscrypt"   = " -i 15.5" #NeoScrypt; fix for default intensity, about 50% slower then Excavator of JustAMinerNeoScrypt 
    "nist5"       = "" #Nist5
    "poly"        = "" #Poly
    "quark"       = "" #Quark
    "qubit"       = "" #Qubit
    "scrypt"      = "" #Scrypt
    "sha256d"     = "" #sha256d
    "sia"         = "" #SiaCoin
    "sib"         = "" #Sib
    "skein"       = "" #Skein
    "skein2"      = "" #skein2
    "veltor"      = " -i 23" #Veltor; fix for default intensity
    "whirlcoin"   = "" #WhirlCoin
    "whirlpool"   = "" #Whirlpool
    "x11"         = "" #X11
    "x11evo"      = " -N 1 -i 21" #X11evo; fix for default intensity, N samples for hashrate
    "x13"         = "" #x13
    "x14"         = "" #x14
    "x15"         = "" #x15
    "x17"         = " -i 20" #x17; fix for default intensity
    #"scrypt:N"   = "" #scrypt:N
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
