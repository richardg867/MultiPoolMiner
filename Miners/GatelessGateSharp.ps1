using module ..\Include.psm1

$InstallDirectory = "$env:ProgramFiles\Zawawa Software LLC\Gateless Gate Sharp"
$Path = "$InstallDirectory\GatelessGateSharp.exe"
$HashSHA256 = "D54D6CADF9FD8EEE238BD1C9FCB8F6E821ACAA41F49C0F9EFB96DBB33D68FECC"
$Uri = "https://github.com/zawawawa/GatelessGateSharp/releases/download/v1.3.8-alpha/GatelessGateSharpInstaller.exe"
$MinerFeeInPercent = 1

# Ethash/Pascal dual mining is not implemented due to API limitations.
$Commands = [PSCustomObject]@{
    "CryptoNight"       = "" #CryptoNight
    "CryptoNight-Heavy" = "" #CryptoNight-Heavy
    "CryptoNight-Light" = "" #CryptoNight-Light
    "CryptoNightV7"     = "" #CryptoNightV7
    "Ethash"            = "" #Ethash
    "Lyra2REv2"         = "" #Lyra2RE2
    "Lbry"              = "" #Lbry
    "NeoScrypt"         = "" #NeoScrypt
    "Pascal"            = "" #Pascal
    "X16R"              = "" #X16R
    "X16S"              = "" #X16S
}

# Monitor attempts to restart the miner after MPM closes it. Move the binary away to disable that.
$MonitorPath = "$InstallDirectory\GatelessGateSharpMonitor.exe"
$MonitorNewPath = "$InstallDirectory\GatelessGateSharpMonitor_MPMDisabled.exe"
if (Test-Path "$MonitorPath") {
    If (Test-Path "$MonitorNewPath") {
        Remove-Item "$MonitorNewPath" -Force
    }
    Move-Item "$MonitorPath" -Destination "$MonitorNewPath" -Force
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

if ($Config.IgnoreMinerFee -or $Config.Miners.$Name.IgnoreMinerFee) {
    $Fees = @($null)
}
else {
    $Fees = @($MinerFeeInPercent)
}

if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        $Algorithm = $_
        $Algorithm_Norm = Get-Algorithm $_

        If (($Algorithm -eq "Ethash" -or $Algorithm -eq "CryptoNight") -and $Pools.$Algorithm_Norm.Name -eq "NiceHash") {
            $Algorithm = "$Algorithm (NiceHash)"
        }
        
        $HashRate = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week
        if ($Fees) {$HashRate = $HashRate * (1 - $MinerFeeInPercent / 100)}

        [PSCustomObject]@{
            Type       = "AMD", "NVIDIA"
            Path       = $Path
            HashSHA256 = $HashSHA256
            Arguments  = "--auto_start=true --launch_at_startup=false --disable_auto_start_prompt=true --api_enabled=true --api_port=4028 --default_algorithm=`"$Algorithm`" --use_custom_pools=true --custom_pool0_enabled=true --custom_pool0_algorithm=`"$Algorithm`" --custom_pool0_host=$($Pools.$Algorithm_Norm.Host) --custom_pool0_port=$($Pools.$Algorithm_Norm.Port) --custom_pool0_login=$($Pools.$Algorithm_Norm.User) --custom_pool0_password=$($Pools.$Algorithm_Norm.Pass) --custom_pool0_secondary_algorithm=`"`" --custom_pool0_secondary_host=`"`" --custom_pool1_enabled=false --custom_pool2_enabled=false --custom_pool3_enabled=false --optimization_undervolting_memory=false --optimization_undervolting_core=false --optimization_memory_timings=false --optimization_overclocking_memory=false --optimization_memory_timings_extended=false --optimization_overclocking_core=false$($Commands.$_)"
            HashRates  = [PSCustomObject]@{$Algorithm_Norm = $HashRate}
            API        = "Xgminer"
            Port       = 4028
            URI        = $Uri
            Fees       = $Fees
        }
    }
}
