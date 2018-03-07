using module ..\Include.psm1

$Path = ".\Bin\NVIDIA-SP\ccminer.exe"
$Uri = "https://github.com/sp-hash/ccminer/releases/download/1.5.81/release81.7z"

$Commands = [PSCustomObject]@{
    "bastion" = "" #Bastioncoin
    "c11" = "" #C11
    "credit" = "" #Credit
    "keccak" = "" #Maxcoin
    "mjollnir" = "" #Mjollnircoin
    "neoscrypt" = "" #NeoScrypt
    "skein" = "" #Skeincoin
    "x17" = "" #X17
    "yescrypt" = "" #Yescrypt
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass) -b 4068$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "Ccminer"
        Port = 4068
        URI = $Uri
    }
}
