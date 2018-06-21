using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Path = ".\Bin\Ethash-Claymore\EthDcrMiner64.exe"
$HashSHA256 = "11743A7B0F8627CEB088745F950557E303C7350F8E4241814C39904278204580"
$URI = "https://github.com/MultiPoolMiner/miner-binaries/releases/download/ethdcrminer64/ClaymoreDual_v11.7.zip"
$Port = "50{0:d2}"

$Commands = [PSCustomObject[]]@(
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = ""; Params = ""} #Ethash
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 40"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 60"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 80"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "decred"; Params = " -dcri 40"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "decred"; Params = " -dcri 70"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "decred"; Params = " -dcri 100"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "keccak"; Params = " -dcri 20"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "keccak"; Params = " -dcri 30"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "keccak"; Params = " -dcri 40"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "lbry"; Params = " -dcri 60"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "lbry"; Params = " -dcri 75"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "lbry"; Params = " -dcri 90"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "pascal"; Params = " -dcri 40"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "pascal"; Params = " -dcri 60"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "pascal"; Params = " -dcri 80"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "sia"; Params = " -dcri 40"} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "sia"; Params = " -dcri 60"} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; SecondaryAlgorithm = "sia"; Params = " -dcri 80"} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = ""; Params = ""} #Ethash
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 40"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 60"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "blake2s"; Params = " -dcri 80"} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "decred"; Params = " -dcri 40"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "decred"; Params = " -dcri 70"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "decred"; Params = " -dcri 100"} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "keccak"; Params = " -dcri 20"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "keccak"; Params = " -dcri 30"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "keccak"; Params = " -dcri 40"} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "lbry"; Params = " -dcri 60"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "lbry"; Params = " -dcri 75"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "lbry"; Params = " -dcri 90"} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "pascal"; Params = " -dcri 40"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "pascal"; Params = " -dcri 60"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "pascal"; Params = " -dcri 80"} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "sia"; Params = " -dcri 40"} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "sia"; Params = " -dcri 60"} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; SecondaryAlgorithm = "sia"; Params = " -dcri 80"} #Ethash/Siacoin
)

$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Devices = @($Devices | Where-Object Type -EQ "GPU")

$Devices | Select-Object Vendor, Model -Unique | ForEach-Object {
    $Device = @($Devices | Where-Object Vendor -EQ $_.Vendor | Where-Object Model -EQ $_.Model)
    $Miner_Port = $Port -f ($Device | Select-Object -First 1 -ExpandProperty Index)

    switch ($_.Vendor) {
        "Advanced Micro Devices, Inc." {$Arguments_Platform = " -platform 1 -y 1"}
        "NVIDIA Corporation" {$Arguments_Platform = " -platform 2"}
        Default {$Arguments_Platform = ""}
    }

    $Commands | ForEach-Object {
        $MainAlgorithm = $_.MainAlgorithm
        $MainAlgorithm_Norm = Get-Algorithm $MainAlgorithm

        Switch ($MainAlgorithm_Norm) {
            # default is all devices, ethash has a 4GB minimum memory limit
            "Ethash" {$Miner_Device = @($Device | Where-Object {$_.OpenCL.GlobalMemsize -ge 4000000000})}
            "Ethash3gb" {$Miner_Device = @($Device | Where-Object {$_.OpenCL.GlobalMemsize -ge 3000000000})}
            default {$Miner_Device = @($Device)}
        }

        if ($Arguments_Platform -and $Miner_Device) {
            if ($_.SecondaryAlgorithm) {
                $SecondaryAlgorithm = $_.SecondaryAlgorithm
                $SecondaryAlgorithm_Norm = Get-Algorithm $SecondaryAlgorithm

                $Miner_Name = (@($Name) + @("$($MainAlgorithm_Norm -replace '^ethash', '')$SecondaryAlgorithm_Norm") + @(if ($_.SecondaryIntensity -ge 0) {$_.SecondaryIntensity}) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'
                $Miner_HashRates = [PSCustomObject]@{"$MainAlgorithm_Norm" = $Stats."$($Miner_Name)_$($MainAlgorithm_Norm)_HashRate".Week; "$SecondaryAlgorithm_Norm" = $Stats."$($Miner_Name)_$($SecondaryAlgorithm_Norm)_HashRate".Week}
                $Arguments_Secondary = " -dcoin $SecondaryAlgorithm -dpool $($Pools.$SecondaryAlgorithm_Norm.Host):$($Pools.$SecondaryAlgorithm_Norm.Port) -dwal $($Pools.$SecondaryAlgorithm_Norm.User) -dpsw $($Pools.$SecondaryAlgorithm_Norm.Pass)$(if($_.SecondaryIntensity -ge 0){" -dcri $($_.SecondaryIntensity)"})"

                if ($Miner_Device | Where-Object {$_.OpenCL.GlobalMemsize -gt 2000000000}) {
                    $Miner_Fees = [PSCustomObject]@{"$MainAlgorithm_Norm" = 1.5 / 100; "$SecondaryAlgorithm_Norm" = 0 / 100}
                }
                else {
                    $Miner_Fees = [PSCustomObject]@{"$MainAlgorithm_Norm" = 0 / 100; "$SecondaryAlgorithm_Norm" = 0 / 100}
                }
            }
            else {
                $Miner_Name = ((@($Name) + @("$($MainAlgorithm_Norm -replace '^ethash', '')") + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-') -replace "[-]{2,}", "-"
                $Miner_HashRates = [PSCustomObject]@{"$MainAlgorithm_Norm" = $Stats."$($Miner_Name)_$($MainAlgorithm_Norm)_HashRate".Week}
                $Arguments_Secondary = ""

                if ($Miner_Device | Where-Object {$_.OpenCL.GlobalMemsize -gt 2000000000}) {
                    $Miner_Fees = [PSCustomObject]@{"$MainAlgorithm_Norm" = 1 / 100}
                }
                else {
                    $Miner_Fees = [PSCustomObject]@{"$MainAlgorithm_Norm" = 0 / 100}
                }
            }

            [PSCustomObject]@{
                Name       = $Miner_Name
                DeviceName = $Miner_Device.Name
                Path       = $Path
                HashSHA256 = $HashSHA256
                Arguments  = ("-mport -$Miner_Port -epool $($Pools.$MainAlgorithm_Norm.Host):$($Pools.$MainAlgorithm_Norm.Port) -ewal $($Pools.$MainAlgorithm_Norm.User) -epsw $($Pools.$MainAlgorithm_Norm.Pass) -allpools 1 -allcoins exp -esm 3$Arguments_Secondary$($_.Params)$Arguments_Platform -di $(($Miner_Device | ForEach-Object {'{0:x}' -f $_.Type_Vendor_Index}) -join '')" -replace "\s+", " ").trim()
                HashRates  = $Miner_HashRates
                API        = "Claymore"
                Port       = $Miner_Port
                URI        = $Uri
                Fees       = $Miner_Fees
            }
        }
    }
}
