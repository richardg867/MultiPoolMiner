﻿using module ..\Include.psm1

param(
    [alias("Wallet")]
    [String]$BTC, 
    [alias("WorkerName")]
    [String]$Worker, 
    [TimeSpan]$StatSpan
)

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

if (-not $BTC) {
    Write-Log -Level Verbose "Cannot mine on pool ($Name) - no wallet address specified. "
    return
}

$RetryCount = 3
$RetryDelay = 2
while (-not ($NiceHash_Request) -and $RetryCount -gt 0) {
    try {
        if (-not $NiceHash_Request) {$NiceHash_Request = Invoke-RestMethod "http://api.nicehash.com/api?method=simplemultialgo.info" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop}
    }
    catch {
        Start-Sleep -Seconds $RetryDelay # Pool might not like immediate requests
        $RetryCount--        
    }
}

if (-not $NiceHash_Request) {
    Write-Log -Level Warn "Pool API ($Name) has failed. "
    return
}

if (($NiceHash_Request.result.simplemultialgo | Measure-Object).Count -le 1) {
    Write-Log -Level Warn "Pool API ($Name) returned nothing. "
    return
}

$NiceHash_Regions = "eu", "usa", "hk", "jp", "in", "br"

$NiceHash_Request.result.simplemultialgo | Where-Object {$_.paying -gt 0} <# algos paying 0 fail stratum #> | ForEach-Object {
    $NiceHash_Host = "nicehash.com"
    $NiceHash_Port = $_.port
    $NiceHash_Algorithm = $_.name
    $NiceHash_Algorithm_Norm = Get-Algorithm $NiceHash_Algorithm
    $NiceHash_Coin = ""

    #if ($NiceHash_Algorithm_Norm -eq "Sia") {$NiceHash_Algorithm_Norm = "SiaNiceHash"} #temp fix
    #if ($NiceHash_Algorithm_Norm -eq "Decred") {$NiceHash_Algorithm_Norm = "DecredNiceHash"} #temp fix

    $Divisor = 1000000000

    $Stat = Set-Stat -Name "$($Name)_$($NiceHash_Algorithm_Norm)_Profit" -Value ([Double]$_.paying / $Divisor) -Duration $StatSpan -ChangeDetection $true

    $NiceHash_Regions | ForEach-Object {
        $NiceHash_Region = $_
        $NiceHash_Region_Norm = Get-Region $NiceHash_Region

        [PSCustomObject]@{
            Algorithm     = $NiceHash_Algorithm_Norm
            CoinName      = $NiceHash_Coin
            Price         = $Stat.Live
            StablePrice   = $Stat.Week
            MarginOfError = $Stat.Week_Fluctuation
            Protocol      = "stratum+tcp"
            Host          = "$NiceHash_Algorithm.$NiceHash_Region.$NiceHash_Host"
            Port          = $NiceHash_Port
            User          = "$BTC.$Worker"
            Pass          = "x"
            Region        = $NiceHash_Region_Norm
            SSL           = $false
            Updated       = $Stat.Updated
            PayoutScheme  = "PPS"
        }
        [PSCustomObject]@{
            Algorithm     = "$($NiceHash_Algorithm_Norm)-NHMP"
            CoinName      = $NiceHash_Coin
            Price         = $Stat.Live
            StablePrice   = $Stat.Week
            MarginOfError = $Stat.Week_Fluctuation
            Protocol      = "stratum+tcp"
            Host          = "nhmp.$($NiceHash_Region.ToLower()).nicehash.com"
            Port          = 3200
            User          = "$BTC.$Worker"
            Pass          = "x"
            Region        = $NiceHash_Region_Norm
            SSL           = $false
            Updated       = $Stat.Updated
            PayoutScheme  = "PPS"
        }

        if ($NiceHash_Algorithm_Norm -match "Cryptonight*" -or $NiceHash_Algorithm_Norm -eq "Equihash") {
            [PSCustomObject]@{
                Algorithm     = $NiceHash_Algorithm_Norm
                CoinName      = $NiceHash_Coin
                Price         = $Stat.Live
                StablePrice   = $Stat.Week
                MarginOfError = $Stat.Week_Fluctuation
                Protocol      = "stratum+ssl"
                Host          = "$NiceHash_Algorithm.$NiceHash_Region.$NiceHash_Host"
                Port          = $NiceHash_Port + 30000
                User          = "$BTC.$Worker"
                Pass          = "x"
                Region        = $NiceHash_Region_Norm
                SSL           = $true
                Updated       = $Stat.Updated
                PayoutScheme  = "PPS"
            }
        }
    }
}
