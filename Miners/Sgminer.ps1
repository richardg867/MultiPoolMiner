using module ..\Include.psm1

$Path = ".\Bin\AMD-NiceHash\sgminer.exe"
$HashSHA256 = "7A29E1280898D049BEE35B1CE4A6F05A7B3A3219AC805EA51BEFD8B9AFDE7D85"
$Uri = "https://github.com/nicehash/sgminer/releases/download/5.6.1/sgminer-5.6.1-nicehash-51-windows-amd64.zip"

$Commands = [PSCustomObject]@{
    "bitblock"           = " --gpu-threads 2 --intensity d" #X15
    "bitcore"            = " --intensity d" #Bitcore
    "blake256r8"         = " --gpu-threads 2 --intensity d" #Blake256r8
    "blake256r14"        = " --gpu-threads 2 --intensity d" #Blake256r14
    "darkcoin-mod"       = " --gpu-threads 2 --intensity d" #X11
    "decred"             = " --gpu-threads 1 --intensity d" #Decred
    "groestlcoin"        = " --gpu-threads 2 --worksize 128 --intensity d" #Groestl
    "maxcoin"            = " --gpu-threads 2 --intensity d" #Keccak
    "lbry"               = " --gpu-threads 2 --intensity d" #Lbry
    "lyra2re"            = " --intensity d" #Lyra2RE
    "lyra2rev2"          = " --gpu-threads 2 --worksize 128 --intensity d" #Lyra2RE2
    "myriadcoin-groestl" = " --gpu-threads 2 --worksize 64 --intensity d" #MyriadGroestl
    "neoscrypt"          = " --gpu-threads 1 --worksize 64 --intensity 15" #NeoScrypt
    "pascal"             = " --gpu-threads 2" #Pascal
    "sia"                = " --gpu-threads 1 --intensity d" #Sia
    "sibcoin-mod"        = " --gpu-threads 2 --intensity d" #Sib
    "skeincoin"          = " --gpu-threads 2 --worksize 256 --intensity d" #Skein
    "skunk"              = " --gpu-threads 2 --intensity d" #Skunk
    "vanilla"            = " --intensity d" #BlakeVanilla
    "whirlpool"          = " --intensity d" #Whirlpool
    "whirlpoolx"         = " --intensity d" #WhirlpoolX
    "yescrypt"           = " --worksize 4 --rawintensity 256" #Yescrypt
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type       = "AMD"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "--api-listen -k $_ -o $($Pools.$Algorithm_Norm.Protocol)://$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -u $($Pools.$Algorithm_Norm.User) -p $($Pools.$Algorithm_Norm.Pass)$($Commands.$_) --text-only --gpu-platform $([array]::IndexOf(([OpenCl.Platform]::GetPlatformIDs() | Select-Object -ExpandProperty Vendor), 'Advanced Micro Devices, Inc.'))"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "Xgminer"
        Port       = 4028
        URI        = $Uri
    }
}