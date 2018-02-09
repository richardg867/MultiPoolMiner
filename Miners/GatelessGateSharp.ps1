using module ..\Include.psm1

$Path = ".\Bin\GatelessGateSharp\GatelessGateSharp.exe"
$Uri = "https://github.com/zawawawa/GatelessGateSharp/releases/download/v1.2.18-stable/Gateless_Gate_Sharp_1.2.18_stable.7z"

$Commands = [PSCustomObject]@{
    "CryptoNight" = "" #CryptoNight
    #"Ethash" = "" #Ethash
    "Lyra2REv2" = "" #Lyra2RE2
    #"Lbry" = "" #Lbry
    "NeoScrypt" = "" #NeoScrypt
    "Pascal" = "" #Pascal
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Algorithm = $_
        if ($Algorithm -eq "Ethash") {$Algorithm = "$Algorithm (NiceHash)"}

        [PSCustomObject]@{
            Type = "AMD", "NVIDIA"
            Path = $Path
            Arguments = "--auto_start=true --launch_at_startup=false --api_enabled=true --api_port=4028 --custom_pool0_enabled=true --custom_pool0_algorithm=`"$Algorithm`" --custom_pool0_host=$($Pools.(Get-Algorithm $_).Host) --custom_pool0_port=$($Pools.(Get-Algorithm $_).Port) --custom_pool0_login=$($Pools.(Get-Algorithm $_).User) --custom_pool0_password=$($Pools.(Get-Algorithm $_).Pass) --custom_pool0_secondary_algorithm=`"`" --custom_pool0_secondary_host=`"`" --custom_pool1_enabled=false --custom_pool2_enabled=false --custom_pool3_enabled=false$($Commands.$_)"
            HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
            API = "Xgminer"
            Port = 4028
            URI = $Uri
        }

        # Pascal dual mining disabled until confirmation that the sgminer-compatible API returns both hashrates
        #If ($_ -eq "Ethash") {
        #    [PSCustomObject]@{
        #        Type = "AMD", "NVIDIA"
        #        Path = $Path
        #        Arguments = "--auto_start=true --launch_at_startup=false --api_enabled=true --api_port=4028 --custom_pool0_enabled=true --custom_pool0_algorithm=`"$Algorithm`" --custom_pool0_host=$($Pools.(Get-Algorithm $_).Host) --custom_pool0_port=$($Pools.(Get-Algorithm $_).Port) --custom_pool0_login=$($Pools.(Get-Algorithm $_).User) --custom_pool0_password=$($Pools.(Get-Algorithm $_).Pass) --custom_pool0_secondary_algorithm=`"Pascal`" --custom_pool0_secondary_host=$($Pools.Pascal.Host) --custom_pool0_secondary_port=$($Pools.Pascal.Port) --custom_pool0_secondary_login=$($Pools.Pascal.User) --custom_pool0_secondary_password=$($Pools.Pascal.Pass) --custom_pool1_enabled=false --custom_pool2_enabled=false --custom_pool3_enabled=false$($Commands.$_)"
        #        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week; "Pascal" = $Stats."$($Name)_$(Get-Algorithm $_)_Pascal_HashRate".Week}
        #        API = "Xgminer"
        #        Port = 4028
        #        URI = $Uri
        #    }
        #}
    }
}
