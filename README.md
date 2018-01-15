# Personal MultiPoolMiner Fork

This is my personal MultiPoolMiner code playground, based on the MiningPoolHubStats fork. Feel free to use it.

## List of changes (important notes in bold)

* Litecoin payout on supported pools through the `-walletltc yourLTCaddress` option
* Additional Claymore dual-mining intensity values (10-15-20-25-30-35-40), takes longer to benchmark but increases profit switching granularity
* Proper support for [Excavator 1.2.11](https://github.com/nicehash/excavator/releases/tag/v1.2.11a), the last version to support AMD cards
  * **If you have AMD cards, download Excavator 1.2.11 from the link above and place it in Bin/Excavator-AMD**
* Added SHA builds of JayDDee's cpuminer for Ryzen CPU mining