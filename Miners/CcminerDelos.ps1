using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-Delos\ccminer.exe"
$HashSHA256 = "C56675263E302DB97B9C5BBC88545ACFCE7BD9CA0C05E64074613D1CC43AA635"
$Uri = "https://github.com/MultiPoolMiner/miner-binaries/releases/download/DelosMiner/DelosMiner1.3.0-x86-cu91.zip"
$UriManual = "https://bitcointalk.org/index.php?topic=4344544"
$MinerFeeInPercent = 1

$Commands = [PSCustomObject]@{
    "bastion"     = "" # Hefty bastion, untested
    "bitcore"     = "" # Timetravel-10
    "blake"       = "" #blake
    "blake2s"     = "" #Blake2s
    "blakecoin"   = "" #Blakecoin
    "bmw"         = "" # BMW 256, untested
    "c11"         = "" # X11 variant, untested
    "cryptolight" = "" # AEON cryptonight (MEM/2)
    "deep"        = "" # Deepcoin, untested
    "dmd-gr"      = "" # Diamond-Groestl, untested
    "equihash"    = "" # Zcash Equihash
    "fresh"       = "" # Freshcoin (shavite 80), untested
    "fugue256"    = "" # Fuguecoin, untested
    "groestl"     = "" # Groestlcoin
    "hmq1725"     = "" # Doubloons / Espers
    "hsr"         = "" # HSR
    "jackpot"     = "" # JHA v8, untested
    "keccak"      = "" # Deprecated Keccak-256
    "keccakc"     = "" # Keccak-256 (CreativeCoin)
    "lbry"        = "" # LBRY Credits (Sha/Ripemd)
    "luffa"       = "" # Joincoin, untested
    "lyra2"       = "" # CryptoCoin
    "lyra2v2"     = "" # VertCoin
    "lyra2z"      = "" # ZeroCoin (3rd impl)
    "myr-gr"      = "" #MyriadGroestl
    "neoscrypt"   = "" # FeatherCoin, Phoenix, UFO...
    "nist5"       = "" #Nist5
    "penta"       = "" # Pentablake hash (5x Blake 512), untested
    "phi"         = "" # BHCoin
    "polytimos"   = "" # Politimos, untested
    "quark"       = "" #Quark
    "qubit"       = "" #Qubit
    "s3"          = "" # S3 (1Coin), untested
    "scrypt"      = "" #Scrypt
    "scrypt-jane" = "" # Scrypt-jane Chacha, untested
    "sha256d"     = "" #sha256d
    "sha256t"     = "" # SHA256 x3
    "sia"         = "" #SiaCoin
    "sib"         = "" # Sibcoin (X11+Streebog)
    "skein"       = "" # Skein SHA2 (Skeincoin)
    "skein2"      = "" # Double Skein (Woodcoin), untested
    "skunk"       = "" # Skein Cube Fugue Streebog
    "timetravel"  = "" # Machinecoin permuted x8
    "tribus"      = "" # Denarius, untested
    "vanilla"     = "" # Blake256-8 (VNL), untested
    "vanilla"     = "" #BlakeVanilla
    "veltor"      = "" # Thorsriddle streebog, untested
    "whirlcoin"   = "" # Old Whirlcoin (Whirlpool algo), untested
    "whirlpool"   = "" # Whirlpool algo, untested
    "wildkeccak"  = "" # Boolberry, untested
    "x11"         = "" #X11
    "x11evo"      = "" # Permuted x11 (Revolver)
    "x13"         = "" #x13
    "x14"         = "" #x14
    "x15"         = "" #x15
    "x16r"        = "" # X16R (Raven)
    "x16s"        = "" # X16S
    "x17"         = "" # X17
    "zr5"         = "" # ZR5 (ZiftrCoin), untested
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName
                
if ($Config.IgnoreMinerFee -or $Config.Miners.$Name.IgnoreMinerFee) {
    $Fees = @($null)
}
else {
    $Fees = @($MinerFeeInPercent)
}

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    $HashRate = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week
    if ($Fees) {$HashRate = $HashRate * (1 - $MinerFeeInPercent / 100)}

    [PSCustomObject]@{
        Type       = "NVIDIA"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-a $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_)"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $HashRate}
        API        = "Ccminer"
        Port       = 4068
        URI        = $Uri
        Fees       = $Fees
    }
} 
