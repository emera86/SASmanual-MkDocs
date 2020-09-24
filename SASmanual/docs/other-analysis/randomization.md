The most compelling way to establish that an intervention definitively causes a clinical outcome is to randomly allocate patients into treatment groups. Randomization helps to ensure that a certain proportion of patients receive each treatment and that the treatment groups being compared are similar in both measured and unmeasured patient characteristics. **Simple or unrestricted, equal randomization** of patients between 2 treatment groups is equivalent to tossing a fair coin for each patient assignment. As the sample size increases, the 2 groups will become more perfectly balanced. However, this **balance is not guaranteed when there are relatively few patients enrolled in a trial**. In the coin toss scenario, obtaining several consecutive heads, for example, is more likely than typically perceived. If a long series of assignments to 1 group occurred when randomizing patients in a clinical trial, imbalances between the groups would occur.

**Imbalances between groups can be minimized in small sample–size studies by restricting the randomization procedure**. Restricted randomization means that simple randomization is applied within defined groups of patients.

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

### Why Are Permuted Blocks and Stratified Randomization Important?

The most efficient allocation of patients for **maximizing statistical power is often equal allocation into groups**. Power to detect a treatment effect is increased as the standard error of the treatmenteffect estimate is decreased. In a 2-group setting, allocating more patients to 1 group would reduce the standard error for that 1 group but doing so would decrease the sample size and increase the standard error in the other group. The standard error of the treatment effect or the difference between the groups is therefore minimized with equal allocation. **Permuted block randomization avoids such imbalances**.

**Stratified randomization ensures balance between treatment groups** for the selected, measurable prognostic characteristics used to define the strata. Because stratified randomization essentially produces a randomized trial within each stratum, stratification can be used when different patient populations are being enrolled or if it is important to analyze results within the subgroups defined by the stratifying characteristics. For example, when there are concerns that an intervention is influenced by patient sex, stratification might occur by sex. Because patients are randomly allocated both in the male and female groups, the effect of the intervention can be tested for the entire population and —assuming sufficient sample size— separately in men and women.

### Limitations of Permuted Block Randomization and Stratified Randomization

The main limitation of permuted block randomization is the potential for bias if **treatment assignments become known or predictable**. For example, with a block size of 4, if an investigator knew the first 3 assignments in the block, the investigator also would know with certainty the assignment for the next patient enrolled. The use of reasonably large block sizes, random block sizes, and strong blinding procedures such as double-blind treatment assignments and identical-appearing placebos are strategies used to prevent this.

In stratified randomization, the **number of strata should be fairly limited**, such as 3 or 4, but even fewer strata should be used in trials enrolling relatively few research participants. There is no particular statistical disadvantage to stratification, but **strata do result in more complex randomization procedures**. In some settings, stratified randomization may not be possible because it is simply not feasible to determine a patient's prognostic characteristics before getting a treatment assignment, such as in an emergency setting.

An alternative to stratification is to prespecify a statistical adjustment for the key characteristics in the primary analysis that are thought to influence outcomes and may not be completely balanced between groups by the randomization procedure. Another **alternative to stratification is minimization**. Minimization considers the current balance of the key prognostic characteristics between treatment groups and if an imbalance exists, assigns future patients as necessary to rebalance the groups. For example, if the experimental group had a smaller proportion of women than did the control group and the next patient to be randomized is a woman, a minimization procedure might assign that patient to the experimental group. **Minimization can bemore complex than stratification**, but is effective and **can accommodate more factors than stratification**.

### How Does the Approach to Randomization Affect the Trial's Interpretation?

In a clinical trial, the **ultimate goal of the randomization** procedure is to create **similar treatment groups that allow an unbiased comparison**. Restricted randomization procedures such as stratified randomization and permuted block randomization create balance between important prognostic characteristics and are useful when conducting randomized trials enrolling relatively few patients.
