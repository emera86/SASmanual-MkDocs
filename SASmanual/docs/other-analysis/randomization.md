## Permuted Block Randomization

### Choice of block size

Block sizes must be multiples of the number of treatments and take the allocation ratio into account. 
* For 1:1 randomisation of 2 groups, blocks can be size 2, 4, 6, etc. 
* For 1:1:1 randomisation of 3 groups, blocks can be size 3, 6, 9, etc.
* For 2:1 randomisation of 2 groups, blocks can be size 3, 6, 9, etc.

The **treatment allocation is predictable towards the end of a block**. For this reason block sizes should be kept confidential and not shared with those randomising. Large blocks reduce predictability, but will not restrict the randomisation as closely as small blocks. If interim analyses are planned at particular sample sizes, it is desirable that the **treatments are balanced at these points**. Having **many stratification factors** can lead to many incomplete blocks and thereby **imbalance**. 

Therefore choice of block size(s) should take into account:
* the sample size
* planned interim analyses
* number of stratification factors

You can experiment with different block sizes and stratification factors on a [simulation](https://www.sealedenvelope.com/randomisation/simulation/). This will show you how much imbalance to expect for various choices.
