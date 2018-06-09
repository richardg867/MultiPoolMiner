# Personal MultiPoolMiner Fork

This is my personal MultiPoolMiner code playground. Many of this fork's changes are for the sake of "why not", but feel free to use it.

## List of changes (important notes in bold)

* All supported algorithms enabled on:
  * JayDDee's cpuminer
  * TPruvot's cpuminer
  * ccminer forks not targeted at a specific algorithm
  * CryptoNight miners (all CryptoNight variants enabled where supported)
* Optimization detection for both cpuminers, for faster benchmarking when CPU mining
  * SHA support for Ryzen CPUs on JayDDee's cpuminer is enabled as well
* New miners:
  * [Excavator 1.2.11](https://github.com/nicehash/excavator/releases/tag/v1.2.11a): final version of Excavator with AMD support
  * [Gateless Gate Sharp](https://github.com/zawawawa/GatelessGateSharp)
    * Only enabled if MultiPoolMiner is running as administrator (or UAC is disabled)
    * Installs to `Program Files` instead of the `Bin` directory
    * Automatic optimizations are disabled to avoid issues with other miners
* Other minor tweaks...
