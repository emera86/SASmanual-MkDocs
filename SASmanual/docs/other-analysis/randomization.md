## Permuted Block Randomization

Permuted block randomization is a way to randomly allocate a participant to a treatment group, while maintaining a balance (at the end of every block) across treatment groups. Each “block” has a specified number of randomly ordered treatment assignments.

Random permuted blocks are **blocks of different sizes**, where the size of the next block is randomly chosen from the available block sizes. For example, here is a list of random permuted blocks of sizes 4 or 6:

```
A A B A B B 
A B A B 
B B A A 
B A A B 
A B A B B A 
B A A A B B
```

Blocking can be used within **strata**, so that important prognostic characteristics (the **stratification factors**) are balanced between the treatment groups.

### Assigning Blocks

Two basic methods for assigning blocks are random number generation and permutations.

#### Random Number Generation

1. Randomly generate a number for each treatment assignment. For example, if you had a block with treatments AABB, you might get:

```
A = 4
A = 88
B = 9
B = 17
```

2. Rank the generated numbers from highest to lowest:

```
A = 88
B = 17
B = 9
A = 4
```

This gives you your first block, `ABBA`.

3. Repeat the process to assign a new block.

#### Permutations

1. Write a list of all permutations for the block size (`b`). The number of possible arrangements is given by: `b! / ((b/2)! (b/2!))`

For example, for a block of size 4, you would have 6 possible arrangements:
```
AABB
ABAB
BAAB
BABA
BBAA
ABBA
```

2. Randomly choose one arrangement for each block.

### Choice of block size

Block sizes must be multiples of the number of treatments and take the allocation ratio into account. 
* For 1:1 randomisation of 2 groups, blocks can be size 2, 4, 6, etc. 
* For 1:1:1 randomisation of 3 groups, blocks can be size 3, 6, 9, etc.
* For 2:1 randomisation of 2 groups, blocks can be size 3, 6, 9, etc.

The **treatment allocation is predictable towards the end of a block**. For this reason block sizes should be kept confidential and not shared with those randomising. Large blocks reduce predictability, but will not restrict the randomisation as closely as small blocks. If interim analyses are planned at particular sample sizes, it is desirable that the **treatments are balanced at these points**. If your experiment involves a number that isn't divisible by the block size, then your treatment groups may not have the exact same amounts. Having **many stratification factors** can lead to many incomplete blocks and thereby **imbalance**. For large trials, a small imbalance usually doesn't make a big difference, but this is something to take into consideration for smaller trials.

Therefore, choice of block size(s) should take into account:
* the sample size
* planned interim analyses
* number of stratification factors

You can experiment with different block sizes and stratification factors on a [simulation](https://www.sealedenvelope.com/randomisation/simulation/). This will show you how much imbalance to expect for various choices.
