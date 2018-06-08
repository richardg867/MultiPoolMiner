using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Path = ".\Bin\Excavator-AMD\excavator.exe"
$HashSHA256 = "28D9298323080449BD71EFBAD9B7B2BB7BCCF139525A8410361B6953D57CDC65"
$Uri = "https://github.com/nicehash/excavator/releases/download/v1.2.11a/excavator_v1.2.11a_Win64.zip"
$Port = "5200"

$Commands = [PSCustomObject[]]@(
    [PSCustomObject]@{Algorithm = "daggerhashimoto"; Threads = 1; Params = @()} #Ethash
    [PSCustomObject]@{Algorithm = "decred"; Threads = 1; Params = @()} #Decred
    [PSCustomObject]@{Algorithm = "equihash"; Threads = 1; Params = @()} #Equihash
    [PSCustomObject]@{Algorithm = "pascal"; Threads = 1; Params = @()} #Pascal
    [PSCustomObject]@{Algorithm = "sia"; Threads = 1; Params = @()} #Siacoin
    [PSCustomObject]@{Algorithm = "daggerhashimoto"; Threads = 2; Params = @()} #Ethash
    [PSCustomObject]@{Algorithm = "decred"; Threads = 2; Params = @()} #Decred
    [PSCustomObject]@{Algorithm = "equihash"; Threads = 2; Params = @()} #Equihash
    [PSCustomObject]@{Algorithm = "pascal"; Threads = 2; Params = @()} #Pascal
    [PSCustomObject]@{Algorithm = "sia"; Threads = 2; Params = @()} #Siacoin
)

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName
$Devices = $Devices | Where-Object Type -EQ "GPU" | Where-Object Vendor -EQ "Advanced Micro Devices, Inc."

$Devices | Select-Object -ExpandProperty Model | ForEach-Object {
    $Miner_Device = $Devices | Where-Object Model -EQ $_
    $Miner_Port = $Port -f ($Miner_Device | Select-Object -First 1 -ExpandProperty Index)

    $Commands | ForEach-Object {
        $Algorithm = $_.Algorithm
        $Algorithm_Norm = Get-Algorithm $Algorithm
        $Threads = $_.Threads
        $Params = $_.Params
        $Miner_Name = (@($Name) + @($Threads) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'

        if ($Pools.$Algorithm_Norm.Host) {
            [PSCustomObject]@{
                Name             = $Miner_Name
                DeviceName       = $Miner_Device.Name
                Path             = $Path
                HashSHA256       = $HashSHA256
                Arguments        = @([PSCustomObject]@{id = 1; method = "algorithm.add"; params = @("$Algorithm", "$([Net.DNS]::Resolve($Pools.$Algorithm_Norm.Host).AddressList.IPAddressToString | Select-Object -First 1):$($Pools.$Algorithm_Norm.Port)", "$($Pools.$Algorithm_Norm.User):$($Pools.$Algorithm_Norm.Pass)")}) + @([PSCustomObject]@{id = 1; method = "workers.add"; params = @(@($Miner_Device.Type_PlatformId_Index | ForEach-Object {@("alg-0", "$_")} | Select-Object) * $Threads) + $Params})
                HashRates        = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Miner_Name)_$($Algorithm_Norm)_HashRate".Week}
                API              = "Excavator"
                Port             = $Miner_Port
                URI              = $Uri
                PrerequisitePath = "$env:SystemRoot\System32\msvcr120.dll"
                PrerequisiteURI  = "http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"
            }
        }
    }
}
