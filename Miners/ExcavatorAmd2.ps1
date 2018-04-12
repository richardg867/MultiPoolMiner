using module ..\Include.psm1

$Threads = 2

$Path = ".\Bin\Excavator-AMD\excavator.exe"
$Uri = "https://github.com/nicehash/excavator/releases/download/v1.2.11a/excavator_v1.2.11a_Win64.zip"

$Commands = [PSCustomObject]@{
    "daggerhashimoto" = @() #Ethash
    "decred" = @() #Decred
    "equihash" = @() #Equihash
    "pascal" = @() #Pascal
    "sia" = @() #Sia
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName
$Port = 3456 + (0 * 10000)

$DeviceID = 0; 
$DeviceIDs = @([OpenCl.Platform]::GetPlatformIDs() | ForEach-Object {[OpenCl.Device]::GetDeviceIDs($_, [OpenCl.DeviceType]::All)} | Where-Object {$_.Type -eq 'GPU' -and $_.Vendor -eq 'Advanced Micro Devices, Inc.'} | ForEach-Object {$DeviceID; $DeviceID++} | Select-Object)

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    try {
        if ((Get-Algorithm $_) -ne "Decred" -and (Get-Algorithm $_) -ne "Sia") {
            if ($Pools.$(Get-Algorithm $_).Host) {
                [PSCustomObject]@{
                    Type = "AMD"
                    Path = $Path
                    Arguments = @([PSCustomObject]@{id = 1; method = "algorithm.add"; params = @("$_", "$([Net.DNS]::Resolve($Pools.$(Get-Algorithm $_).Host).AddressList.IPAddressToString | Select-Object -First 1):$($Pools.$(Get-Algorithm $_).Port)", "$($Pools.$(Get-Algorithm $_).User):$($Pools.$(Get-Algorithm $_).Pass)")}) + @([PSCustomObject]@{id = 1; method = "workers.add"; params = @(@($DeviceIDs | ForEach-Object {@("alg-0", "$_")} | Select-Object) * $Threads) + $Commands.$_})
                    HashRates = [PSCustomObject]@{$(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
                    API = "Excavator"
                    Port = $Port
                    URI = $Uri
                    PrerequisitePath = "$env:SystemRoot\System32\msvcr120.dll"
                    PrerequisiteURI = "http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"
                }
            }
        }
        else {
            if ($Pools."$(Get-Algorithm $_)NiceHash".Host) {
                [PSCustomObject]@{
                    Type = "AMD"
                    Path = $Path
                    Arguments = @([PSCustomObject]@{id = 1; method = "algorithm.add"; params = @("$_", "$([Net.DNS]::Resolve($Pools."$(Get-Algorithm $_)NiceHash".Host).AddressList.IPAddressToString | Select-Object -First 1):$($Pools."$(Get-Algorithm $_)NiceHash".Port)", "$($Pools."$(Get-Algorithm $_)NiceHash".User):$($Pools."$(Get-Algorithm $_)NiceHash".Pass)")}) + @([PSCustomObject]@{id = 1; method = "workers.add"; params = @(@($DeviceIDs | ForEach-Object {@("alg-0", "$_")} | Select-Object) * $Threads) + $Commands.$_})
                    HashRates = [PSCustomObject]@{"$(Get-Algorithm $_)NiceHash" = $Stats."$($Name)_$(Get-Algorithm $_)NiceHash_HashRate".Week}
                    API = "Excavator"
                    Port = $Port
                    URI = $Uri
                    PrerequisitePath = "$env:SystemRoot\System32\msvcr120.dll"
                    PrerequisiteURI = "http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"
                }
            }
        }
    }
    catch {
    }
}