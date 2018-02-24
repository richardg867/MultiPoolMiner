# Personal MultiPoolMiner Fork

This is my personal MultiPoolMiner code playground. Many of this fork's changes are for the sake of "why not", but feel free to use it.

## List of changes (important notes in bold)

* ~~Litecoin payout on supported pools~~ *Upstreamed*
* Additional Claymore dual-mining intensity values (5-10-15-20-25-30-35-40), takes longer to benchmark but increases profit switching granularity
* All supported algorithms enabled on JayDDee's and TPruvot's cpuminer
* Optimization detection for CPU miners, improves benchmarking times
* New miners:
  * [Excavator 1.2.11](https://github.com/nicehash/excavator/releases/tag/v1.2.11a): the last version to support AMD cards
    * **If you have AMD cards, download Excavator 1.2.11** from the link above and place it in Bin/Excavator-AMD
  * [Claymore AMD NeoScrypt](https://bitcointalk.org/index.php?topic=3012600.0)
  * [Gateless Gate Sharp](https://github.com/zawawawa/GatelessGateSharp)
    * Preliminary support for some algorithms. Only enabled if MultiPoolMiner is running as administrator (or UAC is disabled)
  * ~~[Claymore CPU CryptoNight](https://bitcointalk.org/index.php?topic=647251.0)~~ *Upstreamed*
  * ~~Ryzen SHA builds of [JayDDee's cpuminer](https://github.com/JayDDee/cpuminer-opt)~~ *Upstreamed*
    * Most Intel CPUs don't support SHA instructions at the moment; in that case, the SHA builds will be ignored
* Many other minor tweaks...
