using module ..\Include.psm1

param(
    [alias("WorkerName")]
    [String]$Worker,
    [String]$PayoutCurrency,
    [String]$PayoutAddress,
    [TimeSpan]$StatSpan
)

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$ZergPool_Request = [PSCustomObject]@{}
$ZergPoolCurrencies_Request = [PSCustomObject]@{}

try {
    $ZergPool_Request = Invoke-RestMethod "http://zergpool.com/api/status" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $ZergPoolCurrencies_Request = Invoke-RestMethod "http://zergpool.com/api/currencies" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
}
catch {
    Write-Log -Level Warn "Pool API ($Name) has failed. "
    return
}

if ((($ZergPool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Measure-Object Name).Count -le 1) -and (($ZergPoolCurrencies_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Measure-Object Name).Count -le 1)) {
    Write-Log -Level Warn "Pool API ($Name) returned nothing. "
    return
}

$ZergPool_Regions = [PSCustomObject]@{
    "us"     = "mine.zergpool.com"
    "europe" = "europe.mine.zergpool.com"
}

# On donate run set payout to BTC
if ($DonateRun) {
    $PayoutCurrency = "BTC"
    $PayoutAddress = $Wallet
}

#if payout config is missing in config.txt default to BTC
if (-not ($PayoutCurrency -and $PayoutAddress)) {
    $PayoutCurrency = "BTC"
    $PayoutAddress = $Wallet
}

$ZergPool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name | Where-Object {$ZergPool_Request.$_.hashrate -gt 0} | ForEach-Object {
    $ZergPool_Host = "zergpool.com"
    $ZergPool_Port = $ZergPool_Request.$_.port
    $ZergPool_Algorithm = $ZergPool_Request.$_.name
    $ZergPool_Algorithm_Norm = Get-Algorithm $ZergPool_Algorithm
    $ZergPool_Coin = ""

    $Divisor = 1000000

    switch ($ZergPool_Algorithm_Norm) {
        "blake2s"   {$Divisor *= 1000}
        "blakecoin" {$Divisor *= 1000}
        "decred"    {$Divisor *= 1000}
        "equihash"  {$Divisor /= 1000}
        "keccak"    {$Divisor *= 1000}
        "phi"       {$Divisor *= 1000}
        "quark"     {$Divisor *= 1000}
        "qubit"     {$Divisor *= 1000}
        "scrypt"    {$Divisor *= 1000}
        "x11"       {$Divisor *= 1000}
    }

    if ((Get-Stat -Name "$($Name)_$($ZergPool_Algorithm_Norm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($ZergPool_Algorithm_Norm)_Profit" -Value ([Double]$ZergPool_Request.$_.estimate_last24h / $Divisor) -Duration (New-TimeSpan -Days 1)}
    else {$Stat = Set-Stat -Name "$($Name)_$($ZergPool_Algorithm_Norm)_Profit" -Value ([Double]$ZergPool_Request.$_.estimate_current / $Divisor) -Duration $StatSpan -ChangeDetection $true}

    $ZergPool_Regions | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
        $ZergPool_Region = $_
        $ZergPool_Region_Norm = Get-Region $ZergPool_Region

        [PSCustomObject]@{
            Algorithm     = $ZergPool_Algorithm_Norm
            Info          = $ZergPool_Coin
            Price         = $Stat.Live
            StablePrice   = $Stat.Week
            MarginOfError = $Stat.Week_Fluctuation
            Protocol      = "stratum+tcp"
            Host          = "$($ZergPool_Regions.$_)"
            Port          = $ZergPool_Port
            User          = $PayoutAddress
            Pass          = "$Worker,c=$PayoutCurrency"
            Region        = $ZergPool_Region_Norm
            SSL           = $false
            Updated       = $Stat.Updated
        }
    }
}

#Read mining currency from "c=<PayoutCurrency, e.g. LTC>,mc=<YOUR_MINING_CURRENCY. e.g INN>"; relevant i the part following ,mc=
$Currencies | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name | Select-Object -Unique | ForEach-Object {
    
    $MiningCurrency = $_ -replace ".+,mc\=",""
    $PayoutCurrency = $_ -replace "^c=","" -replace ",mc.+",""
    $PayoutAddress = $Currencies.$_

    # On donate run set payout to BTC
    if ($DonateRun) {
        $PayoutCurrency = "BTC"
        $PayoutAddress = $Wallet
    }    

    if ($ZergPoolCurrencies_Request.$MiningCurrency.hashrate -gt 0) {
        
        $ZergPool_Port = $ZergPoolCurrencies_Request.$MiningCurrency.port
        $ZergPool_Algorithm = $ZergPoolCurrencies_Request.$MiningCurrency.algo
        $ZergPool_Algorithm_Norm = Get-Algorithm $ZergPool_Algorithm
        $ZergPool_Coin = $ZergPoolCurrencies_Request.$MiningCurrency.name

        $Divisor = 1000000

        switch ($ZergPool_Algorithm_Norm) {
            "blake2s"   {$Divisor *= 1000}
            "blakecoin" {$Divisor *= 1000}
            "decred"    {$Divisor *= 1000}
            "equihash"  {$Divisor /= 1000}
            "keccak"    {$Divisor *= 1000}
            "phi"       {$Divisor *= 1000}
            "quark"     {$Divisor *= 1000}
            "qubit"     {$Divisor *= 1000}
            "scrypt"    {$Divisor *= 1000}
            "x11"       {$Divisor *= 1000}
        }

        $Stat = Set-Stat -Name "$($Name)Currencies_$($ZergPool_Algorithm_Norm)_Profit" -Value ([Double]$ZergPoolCurrencies_Request.$MiningCurrency.estimate / $Divisor) -Duration $StatSpan -ChangeDetection $true

        $ZergPool_Regions | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
            $ZergPool_Region = $_
            $ZergPool_Region_Norm = Get-Region $ZergPool_Region

            [PSCustomObject]@{
                Algorithm     = $ZergPool_Algorithm_Norm
                Info          = $ZergPool_Coin
                Price         = $Stat.Live
                StablePrice   = $Stat.Week
                MarginOfError = $Stat.Week_Fluctuation
                Protocol      = "stratum+tcp"
                Host          = "$($ZergPool_Regions.$_)"
                Port          = $ZergPool_Port
                User          = $PayoutAddress
                Pass          = "$Worker,c=$PayoutCurrency,mc=$MiningCurrency"
                Region        = $ZergPool_Region_Norm
                SSL           = $false
                Updated       = $Stat.Updated
            }
        }
    }
}
