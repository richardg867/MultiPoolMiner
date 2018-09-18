using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Path = ".\Bin\AMD_NVIDIA-Claymore-Ethash\EthDcrMiner64.exe"
$HashSHA256 = "4A9AC40A4E8C2F59683294726616A1BE7DE6A78B4929AC490D6844C2CB69E347"
$Uri = "https://github.com/MultiPoolMiner/miner-binaries/releases/download/ethdcrminer64/ClaymoreDual_v11.9.zip"
$ManualUri = "https://bitcointalk.org/index.php?topic=1433925.0"
$Port = "50{0:d2}"

$Commands = [PSCustomObject[]]@(
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = ""; SecondaryIntensity = 00; Params = ""} #Ethash
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 05; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 10; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 15; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 20; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 25; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 30; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 35; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 40; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 45; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 50; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 55; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 60; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 65; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 70; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 75; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 80; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 85; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 90; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 95; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 100; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 05; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 10; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 15; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 20; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 25; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 30; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 35; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 40; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 45; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 50; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 55; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 60; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 65; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 70; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 75; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 80; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 85; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 90; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 95; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "decred"; SecondaryIntensity = 100; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 05; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 10; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 15; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 20; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 25; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 30; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 35; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 40; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 45; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 50; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 55; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 60; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 65; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 70; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 75; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 80; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 85; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 90; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 95; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 100; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 05; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 10; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 15; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 20; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 25; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 30; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 35; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 40; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 45; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 50; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 55; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 60; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 65; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 70; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 75; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 80; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 85; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 90; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 95; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 100; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 05; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 10; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 15; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 20; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 25; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 30; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 35; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 40; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 45; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 50; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 55; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 60; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 65; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 70; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 75; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 80; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 85; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 90; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 95; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 100; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 05; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 10; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 15; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 20; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 25; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 30; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 35; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 40; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 45; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 50; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 55; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 60; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 65; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 70; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 75; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 80; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 85; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 90; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 95; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash2gb"; MinMemGB = 2; SecondaryAlgorithm = "sia"; SecondaryIntensity = 100; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = ""; SecondaryIntensity = 00; Params = ""} #Ethash
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 05; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 10; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 15; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 20; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 25; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 30; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 35; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 40; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 45; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 50; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 55; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 60; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 65; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 70; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 75; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 80; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 85; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 90; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 95; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 100; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 05; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 10; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 15; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 20; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 25; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 30; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 35; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 40; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 45; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 50; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 55; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 60; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 65; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 70; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 75; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 80; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 85; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 90; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 95; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "decred"; SecondaryIntensity = 100; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 05; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 10; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 15; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 20; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 25; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 30; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 35; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 40; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 45; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 50; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 55; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 60; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 65; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 70; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 75; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 80; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 85; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 90; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 95; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 100; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 05; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 10; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 15; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 20; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 25; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 30; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 35; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 40; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 45; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 50; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 55; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 60; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 65; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 70; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 75; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 80; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 85; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 90; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 95; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 100; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 05; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 10; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 15; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 20; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 25; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 30; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 35; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 40; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 45; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 50; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 55; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 60; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 65; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 70; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 75; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 80; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 85; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 90; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 95; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 100; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 05; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 10; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 15; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 20; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 25; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 30; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 35; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 40; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 45; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 50; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 55; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 60; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 65; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 70; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 75; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 80; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 85; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 90; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 95; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash3gb"; MinMemGB = 3; SecondaryAlgorithm = "sia"; SecondaryIntensity = 100; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = ""; SecondaryIntensity = 00; Params = ""} #Ethash
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 05; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 10; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 15; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 20; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 25; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 30; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 35; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 40; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 45; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 50; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 55; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 60; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 65; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 70; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 75; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 80; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 85; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 90; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 95; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "blake2s"; SecondaryIntensity = 100; Params = ""} #Ethash/Blake2s
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 05; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 10; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 15; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 20; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 25; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 30; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 35; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 40; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 45; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 50; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 55; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 60; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 65; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 70; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 75; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 80; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 85; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 90; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 95; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "decred"; SecondaryIntensity = 100; Params = ""} #Ethash/Decred
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 05; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 10; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 15; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 20; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 25; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 30; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 35; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 40; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 45; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 50; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 55; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 60; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 65; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 70; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 75; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 80; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 85; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 90; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 95; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "keccak"; SecondaryIntensity = 100; Params = ""} #Ethash/Keccak
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 05; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 10; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 15; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 20; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 25; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 30; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 35; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 40; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 45; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 50; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 55; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 60; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 65; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 70; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 75; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 80; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 85; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 90; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 95; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "lbry"; SecondaryIntensity = 100; Params = ""} #Ethash/Lbry
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 05; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 10; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 15; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 20; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 25; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 30; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 35; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 40; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 45; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 50; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 55; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 60; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 65; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 70; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 75; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 80; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 85; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 90; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 95; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "pascal"; SecondaryIntensity = 100; Params = ""} #Ethash/Pascal
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 05; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 10; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 15; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 20; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 25; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 30; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 35; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 40; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 45; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 50; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 55; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 60; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 65; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 70; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 75; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 80; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 85; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 90; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 95; Params = ""} #Ethash/Siacoin
    [PSCustomObject]@{MainAlgorithm = "ethash"; MinMemGB = 4; SecondaryAlgorithm = "sia"; SecondaryIntensity = 100; Params = ""} #Ethash/Siacoin
)

$CommonCommands = " -dbg 1 -logfile debug.log"
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
        $Main_Algorithm = $_.MainAlgorithm
        $Main_Algorithm_Norm = Get-Algorithm $Main_Algorithm
        $MinMemGB = $_.MinMemGB

        $Miner_Device = @($Device | Where-Object {$_.OpenCL.GlobalMemsize -ge $MinMemGB * 1000000000})

        if ($Arguments_Platform -and $Miner_Device) {
            if ($_.SecondaryAlgorithm) {
                $Secondary_Algorithm = $_.SecondaryAlgorithm
                $Secondary_Algorithm_Norm = Get-Algorithm $Secondary_Algorithm

                $Miner_Name = (@($Name) + @("$($Main_Algorithm_Norm -replace '^ethash', '')$Secondary_Algorithm_Norm") + @(if ($_.SecondaryIntensity -ge 0) {$_.SecondaryIntensity}) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'

                $Miner_HashRates = [PSCustomObject]@{"$Main_Algorithm_Norm" = $Stats."$($Miner_Name)_$($Main_Algorithm_Norm)_HashRate".Week; "$Secondary_Algorithm_Norm" = $Stats."$($Miner_Name)_$($Secondary_Algorithm_Norm)_HashRate".Week}
                $Arguments_Secondary = " -dcoin $Secondary_Algorithm -dpool $($Pools.$Secondary_Algorithm_Norm.Host):$($Pools.$Secondary_Algorithm_Norm.Port) -dwal $($Pools.$Secondary_Algorithm_Norm.User) -dpsw $($Pools.$Secondary_Algorithm_Norm.Pass)$(if($_.SecondaryIntensity -ge 0){" -dcri $($_.SecondaryIntensity)"})"
                $ExtendInterval = 2

                if ($Miner_Device | Where-Object {$_.OpenCL.GlobalMemsize -gt 2000000000}) {
                    $Miner_Fees = [PSCustomObject]@{"$Main_Algorithm_Norm" = 1.5 / 100; "$Secondary_Algorithm_Norm" = 0 / 100}
                }
                else {
                    $Miner_Fees = [PSCustomObject]@{"$Main_Algorithm_Norm" = 0 / 100; "$Secondary_Algorithm_Norm" = 0 / 100}
                }
            }
            else {
                $Miner_Name = ((@($Name) + @("$($Main_Algorithm_Norm -replace '^ethash', '')") + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-') -replace "[-]{2,}", "-"

                $Miner_HashRates = [PSCustomObject]@{"$Main_Algorithm_Norm" = $Stats."$($Miner_Name)_$($Main_Algorithm_Norm)_HashRate".Week}
                $Arguments_Secondary = ""
                $ExtendInterval = 1

                if ($Miner_Device | Where-Object {$_.OpenCL.GlobalMemsize -gt 2000000000}) {
                    $Miner_Fees = [PSCustomObject]@{"$Main_Algorithm_Norm" = 1 / 100}
                }
                else {
                    $Miner_Fees = [PSCustomObject]@{"$Main_Algorithm_Norm" = 0 / 100}
                }
            }

            [PSCustomObject]@{
                Name           = $Miner_Name
                DeviceName     = $Miner_Device.Name
                Path           = $Path
                HashSHA256     = $HashSHA256
                Arguments      = ("-mport -$Miner_Port -epool $($Pools.$Main_Algorithm_Norm.Host):$($Pools.$Main_Algorithm_Norm.Port) -ewal $($Pools.$Main_Algorithm_Norm.User) -epsw $($Pools.$Main_Algorithm_Norm.Pass) -allpools 1 -allcoins exp -esm 3$Arguments_Secondary$($_.Params)$Arguments_Platform$CommonCommands -di $(($Miner_Device | ForEach-Object {'{0:x}' -f $_.Type_Vendor_Index}) -join '')" -replace "\s+", " ").trim()
                HashRates      = $Miner_HashRates
                API            = "Claymore"
                Port           = $Miner_Port
                URI            = $Uri
                Fees           = $Miner_Fees
                ExtendInterval = $ExtendInterval
            }
        }
    }
}
