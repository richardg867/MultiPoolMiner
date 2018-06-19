using module ..\Include.psm1

class Prospector : Miner {
    [String]GetWorkingDirectory () {
        return "$(Split-Path $this.Path)\$($this.Name)"
    }

    [String[]]UpdateMinerData () {
        if ($this.GetStatus() -ne [MinerStatus]::Running) {return @()}

        $Server = "localhost"
        $Timeout = 10 #seconds

        $Request = ""
        $Response = ""

        $HashRate = [PSCustomObject]@{}

        try {
            $Response = Invoke-WebRequest "http://$($Server):$($this.Port)/api/v0/rates" -UseBasicParsing -TimeoutSec $Timeout -ErrorAction Stop
            $Data = $Response | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-Log -Level Error  "Failed to connect to miner ($($this.Name)). "
            return @($Request, $Response)
        }

        $LastEntry = $Data | Select-Object -Last 1

        $HashRate_Name = [String]$this.Algorithm[0]
        $HashRate_Value = [Double]$LastEntry.rate

        $HashRate | Where-Object {$HashRate_Name} | Add-Member @{$HashRate_Name = [Int64]$HashRate_Value}

        $this.Data += [PSCustomObject]@{
            Date     = (Get-Date).ToUniversalTime()
            Raw      = $Response
            HashRate = $HashRate
            Device   = @()
        }

        return @($Request, $LastEntry <# Prospector's responses are long, don't flood the log file with them #> | ConvertTo-Json -Compress)
    }

    SetStatus([MinerStatus]$Status) {
        Remove-Item "$($this.GetWorkingDirectory())\info.db" -ErrorAction Ignore
        ([Miner]$this).SetStatus($Status)
    }
}
