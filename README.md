# Personal MultiPoolMiner Fork

This is my personal MultiPoolMiner code playground. Many of this fork's changes are for the sake of "why not", but feel free to use it.

## List of changes (important notes in bold)

* ~~Litecoin payout on supported pools~~ *Upstreamed*
* Additional Claymore dual-mining intensity values (10-15-20-25-30-35-40), takes longer to benchmark but increases profit switching granularity
* Automatic downloading of Claymore's miners, no need to merge the fork's files with an upstream MultiPoolMiner release
* All supported algorithms enabled on JayDDee's and TPruvot's cpuminer
* New miners:
  * [Excavator 1.2.11](https://github.com/nicehash/excavator/releases/tag/v1.2.11a): the last version to support AMD cards
    * **If you have AMD cards, download Excavator 1.2.11** from the link above and place it in Bin/Excavator-AMD
  * ~~[Claymore CPU CryptoNight](https://bitcointalk.org/index.php?topic=647251.0)~~ *Upstreamed*
  * Ryzen SHA builds of [JayDDee's cpuminer](https://github.com/JayDDee/cpuminer-opt)
    * Most Intel CPUs don't support SHA instructions at the moment, so **ignore cpuminer crashes**
