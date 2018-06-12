using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-SP\ccminer.exe"
$HashSHA256 = "82477387C860517C5FACE8758BCB7AAC890505280BF713ACA9F86D7B306AC711"
$Uri = "https://github.com/sp-hash/ccminer/releases/download/1.5.81/release81.7z"

$Commands = [PSCustomObject]@{
    "bastion"       = "" #bastion
    "blake"         = "" #blake
    "blake2s"       = "" #Blake2s
    "blakecoin"     = "" #Blakecoin
    "c11"           = "" #C11
    "credit"        = "" #Credit
    "decred"        = "" #Decred
    "deep"          = "" #deep
    "dmd-gr"        = "" #dmd-gr
    "fresh"         = "" #fresh
    "fugue256"      = "" #Fugue256
    "groestl"       = "" #Groestl
    "heavy"         = "" #heavy
    "jackpot"       = "" #JackPot
    "keccak"        = "" #Keccak
    "lbry"          = "" #Lbry
    "luffa"         = "" #Luffa
    "lyra2"         = "" #lyra2h
    "mjollnir"      = "" #Mjollnir
    "myr-gr"        = "" #MyriadGroestl
    "nist5"         = "" #Nist5
    "pentablake"    = "" #pentablake
    "quark"         = "" #Quark
    "qubit"         = "" #Qubit
    "s3"            = "" #S3
    "scrypt"        = "" #Scrypt
    "scrypt:N"      = "" #scrypt:N
    "scryptjane:nf" = "" #scryptjane:nf
    "sha256d"       = "" #sha256d Bitcoin
    "sia"           = "" #SiaCoin
    "spread"        = "" #Spread
    "vanilla"       = "" #BlakeVanilla
    "x11"           = "" #X11
    "x13"           = "" #x13
    "x14"           = "" #x14
    "x15"           = "" #x15
    "x17"           = "" #x17
    #"lyra2v2"      = "" #Lyra2RE2
    #"neoscrypt"    = "" #NeoScrypt
    #"skein"        = "" #Skein
    #"whirlpool"    = "" #Whirlpool
    #"whirlpoolx"   = "" #whirlpoolx
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type       = "NVIDIA"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass) -b 4068$($Commands.$_)"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "Ccminer"
        Port       = 4068
        URI        = $Uri
    }
}
