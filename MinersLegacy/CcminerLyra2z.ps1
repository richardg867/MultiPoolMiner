using module ..\Include.psm1

$Path = ".\Bin\Lyra2z-NVIDIA\ccminer.exe"
$HashSHA256 = "F9A69BA3C00E80BBBE7054E8705FE07DC23B7C408FA5405B778441A24D1AD223"
$Uri = "https://github.com/djm34/ccminer-msvc2015/releases/download/v0.3.0/ccminer.rar"

$Commands = [PSCustomObject]@{
    "blake2s"   = "" #Blake2s
    "blakecoin" = "" #Blakecoin
    "c11"       = "" #C11
    "decred"    = "" #Decred
    "groestl"   = "" #Groestl
    "keccak"    = "" #Keccak
    "lbry"      = "" #Lbry
    "lyra2h"    = "" #Lyra2h
    "lyra2v2"   = "" #Lyra2RE2 - Beaten by ccminerXevan by 80%
    "lyra2z"    = "" #Lyra2z
    "m7m"       = "" #M7M
    "myr-gr"    = "" #MyriadGroestl
    "neoscrypt" = "" #NeoScrypt
    "nist5"     = "" #Nist5
    "quark"     = "" #Quark
    "qubit"     = "" #Qubit
    "sib"       = "" #Sib
    "skein"     = "" #Skein
    "x11"       = "" #X11
    "x11evo"    = "" #X11evo
    "x12"       = "" #X12
    "x13"       = "" #X13
    "x14"       = "" #X14
    "x17"       = "" #X17
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
