using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-TPruvot\ccminer-x64.exe"
$Uri = "https://github.com/MSFTserver/ccminer/releases/download/2.2.5-rvn/ccminer-x64-2.2.5-rvn-cuda9.7z"

$Commands = [PSCustomObject]@{
    "bastion" = "" #Hefty bastion
    "bitcore" = "" #Bitcore
    "blake" = "" #Blake 256 (SFR)
    "blake2s" = "" #Blake2s
    "blakecoin" = "" #Blakecoin
    "bmw" = "" #BMW 256
    "c11" = "" #C11
    "cryptolight" = "" #AEON cryptonight (MEM/2)
    "cryptonight" = "" #XMR cryptonight
    "decred" = "" #Decred
    "deep" = "" #Deepcoin
    "dmd-gr" = "" #Diamond-Groestl
    "equihash" = "" #Equihash
    "fresh" = "" #Freshcoin (shavite 80)
    "fugue256" = "" #Fuguecoin
    "groestl" = "" #Groestl
    "hmq1725" = "" #HMQ1725
    "jackpot" = "" #JHA v8
    "keccak" = "" #Keccak
    "keccakc" = "" #Keccak-256 (CreativeCoin)
    "lbry" = "" #Lbry
    "luffa" = "" #Joincoin
    "lyra2" = "" #CryptoCoin
    "lyra2v2" = "" #Lyra2RE2
    "lyra2z" = "" #Lyra2z
    "myr-gr" = "" #MyriadGroestl
    "neoscrypt" = "" #NeoScrypt
    "nist5" = "" #Nist5
    "penta" = "" #Pentablake hash (5x Blake 512)
    "phi" = "" #PHI
    "polytimos" = "" #Polytimos
    "quark" = "" #Quark
    "qubit" = "" #Qubit
    "sha256d" = "" #SHA256d (bitcoin)
    "sha256t" = "" #SHA256 x3
    "sia" = "" #Sia
    "sib" = "" #Sib
    "scrypt" = "" #Scrypt
    "skein" = "" #Skein
    "skein2" = "" #Double Skein (Woodcoin)
    "skunk" = "" #Skunk
    "s3" = "" #S3 (1Coin)
    "timetravel" = "" #Timetravel
    "tribus" = "" #Tribus
    "vanilla" = "" #BlakeVanilla
    "veltor" = "" #Veltor
    "whirlcoin" = "" #Old Whirlcoin (Whirlpool algo)
    "whirlpool" = "" #Whirlpool algo
    "x11evo" = "" #X11evo
    "x11" = "" #X11 (DarkCoin)
    "x13" = "" #X13 (MaruCoin)
    "x14" = "" #X14
    "x15" = "" #X15
    "x16r" = "" #Raven
    "x17" = "" #X17
    "wildkeccak" = "" #Boolberry
    "zr5" = "" #ZR5 (ZiftrCoin)
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass) --submit-stale$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "Ccminer"
        Port = 4068
        URI = $Uri
    }
}
