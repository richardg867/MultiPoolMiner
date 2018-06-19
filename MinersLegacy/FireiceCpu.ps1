﻿using module ..\Include.psm1

$Path = ".\Bin\CryptoNight-FireIce\xmr-stak.exe"
$HashSHA256 = "1BFEAA00CCE185C889F82A2C87DCACABF2EE966B379384470E778E1DA72FB7E1"
$Uri = "https://github.com/fireice-uk/xmr-stak/releases/download/2.4.5/xmr-stak-win64.zip"

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName
$Port = 3334

$Commands = [PSCustomObject]@{
    "cryptonight"             = "" # CryptoNight
    "cryptonight_haven"       = "" # CryptoNight-Haven
    "cryptonight_heavy"       = "" # CryptoNight-Heavy
    "cryptonight_lite"        = "" # CryptoNight-Lite
    "cryptonight_lite_v7"     = "" # CryptoNight-Lite V7
    "cryptonight_lite_v7_xor" = "" # CryptoNight-Lite V7 XOR
    "cryptonight_v7"          = "" # CryptoNightV7
}
$Currencies = [PSCustomObject]@{
    "aeon"        = "aeon7"
    "bbs"         = "bbscoin"
    "bittube"     = "ipbc"
    "croat"       = "croat"
    "edollar"     = "edollar"
    "electroneum" = "electroneum"
    "graft"       = "graft"
    "haven"       = "haven"
    "intense"     = "intense"
    "ipbc"        = "ipbc"
    "karbo"       = "karbo"
    "masari"      = "masari"
    "monero"      = "monero7"
    "sumokoin"    = "sumokoin"
    "turtle"      = "turtlecoin"
}

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.$(Get-Algorithm $_)} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_
    $Currency = ""
    If ($Pools.$Algorithm_Norm.Info) {
        $Currency = $Currencies.$($Pools.$Algorithm_Norm.Info -replace "coin$")
    }

    ([PSCustomObject]@{
            pool_list       = @([PSCustomObject]@{
                    pool_address    = "$($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port)"
                    wallet_address  = "$($Pools.$Algorithm_Norm.User)"
                    pool_password   = "$($Pools.$Algorithm_Norm.Pass)"
                    use_nicehash    = $true
                    use_tls         = $Pools.$Algorithm_Norm.SSL
                    tls_fingerprint = ""
                    pool_weight     = 1
                    rig_id = ""
                }
            )
            currency        = if ($Currency) {"$Currency"} else {"$_"}
            call_timeout    = 10
            retry_time      = 10
            giveup_limit    = 0
            verbose_level   = 3
            print_motd      = $true
            h_print_time    = 60
            aes_override    = $null
            use_slow_memory = "warn"
            tls_secure_algo = $true
            daemon_mode     = $false
            flush_stdout    = $false
            output_file     = ""
            httpd_port      = $Port
            http_login      = ""
            http_pass       = ""
            prefer_ipv4     = $true
        } | ConvertTo-Json -Depth 10
    ) -replace "^{" -replace "}$" | Set-Content "$(Split-Path $Path)\$($Pools.$Algorithm_Norm.Name)_$($Algorithm_Norm)_$($Pools.$Algorithm_Norm.User)_Cpu.txt" -Force -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        Type       = "CPU"
        Path       = $Path
        HashSHA256 = $HashSHA256
        Arguments  = "-C $($Pools.$Algorithm_Norm.Name)_$($Algorithm_Norm)_$($Pools.$Algorithm_Norm.User)_Cpu.txt --noUAC --noAMD --noNVIDIA -i $($Port)"
        HashRates  = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week}
        API        = "XMRig"
        Port       = $Port
        URI        = $Uri
    }
}
