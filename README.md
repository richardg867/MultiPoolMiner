# Personal MultiPoolMiner Fork

This is my personal MultiPoolMiner code playground. Many of this fork's changes are for the sake of "why not", but feel free to use it.

## List of changes (important notes in bold)

* Additional Claymore dual-mining intensity values (5-10-15-20-25-30-35-40-45-50-55-60, range depends on algorithm), takes longer to benchmark but increases profit switching granularity
  * This change will be revisited since upstream is currently overhauling Claymore support
* All supported algorithms enabled on:
  * JayDDee's cpuminer
  * TPruvot's cpuminer
  * TPruvot's ccminer and forks
  * CryptoNight miners (all CryptoNight variants enabled where supported)
* Optimization detection for both cpuminers, for faster benchmarking when CPU mining
  * SHA support for Ryzen CPUs on JayDDee's cpuminer is enabled as well
* New miners:
  * [Excavator 1.2.11](https://github.com/nicehash/excavator/releases/tag/v1.2.11a): the last version to support AMD cards
    * **If you have AMD cards, download Excavator 1.2.11** from the link above and place it in Bin/Excavator-AMD
  * [Gateless Gate Sharp](https://github.com/zawawawa/GatelessGateSharp)
    * Preliminary support for some algorithms. Only enabled if MultiPoolMiner is running as administrator (or UAC is disabled)
* Other minor tweaks...
