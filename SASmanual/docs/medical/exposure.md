## Dose Intensity

In comparing various protocols you will find that not only do doses vary from one protocol to the next, but also how many doses and when they are given. This can make comparisons difficult or impossible.

### Absolute Dose Intensity

The concept of **Dose Intensity (DI)** may allow a rough comparison. Dose Intensity is the total amount of drug given in a fixed unit of time (usually 1 week), thus is a function of dose and frequency of administration.

$DI = \frac{sum \ of \ all \ administered \ doses}{(last \ dose \ date - 1^{st} \  dose \ date + planned \ cycle \ duration)/ 7} $

### Relative Dose Intensity

The **Relative Dose Intensity (RDI)** is the ratio of *delivered* respect to the *planned* dose intensity and can be expressed as a percentage. An RDI of 100% indicates that the drug was administered at the dose planned per protocol, without delay and without cancellations.

$RDI = \frac{sum \ of \ all \ administered \ doses}{(last \ dose \ date - 1^{st} \  dose \ date + planned \ cycle \ duration)/ 7} \cdot \left (\frac{planned \ dose \ per \ cycle}{planned \ cycle \ duration / 7}  \right )^{-1} \cdot 100 =$

$= \frac{sum \ of \ all \ administered \ doses}{planned \ dose \ per \ cycle} \cdot \frac{planned \ cycle \ duration}{last \ dose \ date - 1^{st} \  dose \ date + planned \ cycle \ duration} \cdot 100$

!!! note
    For **RDI** calculation, the full theoretical dose and cycle duration stablished by protocol are used (not the intended dose registered by cycle which may account for reductions). Regarding the last cycle, the protocol or principal investigator should specify the criteria to accound for interrupted treatments.
    **Example:** treatment consisting on administrations on day 1, 7 and 15 of a 21-day cycle. What should we do with a patient who received the 100% of the treatment until the last cycle on which he only received the doses of day 1 and 7? Should we consider the administration of day 15 as zero dose (RDI will be less than 100%)? Should we consider this last cycle as reduced in duration (finished with the last dose administered and, thus, RDI maintained in 100%)? 
    When there is a special interest in safety (Phase I trials) we need to be careful when defining these variables, otherwise the variations introduced by these details are minimal and it's not worth the trouble.
    If there is a delay during the cycle (between doses), we may need to use the last dose date plus the theoretical rest period (until the end of the cycle) to account for the cycle duration (moreover if it's the last one).
    
A different definition is sometimes used for the **Relative Dose Intensity (RDI)** on which the time factor is not considered:

$RDI = \frac{sum \ of \ all \ administered \ doses}{sum \ of \ all \ planned \ doses} \cdot 100$

This definition is equivalent to the previous one if there are not delays in the treatment respect to the planned cycle duration, however, if that is the case (there are delays) using this definition one would be overestimating the **RDI**.
    
### Derived Variables

Key derived variables for exposure derived datasets could be:

* The **Cumulative dose**, usually given in $mg$, is the sum of all administered Dose/Cycles
* The **Planned Treatment Duration** ($days$) is the planned time between two consecutive administrations, i.e. the planned cycle duration
* The **Treatment Duration** ($weeks$) is calculated as: (date of last administration of trial drug - date of first administration of trial drug + Planned Duration)/ 7
* The **Dose Intensity (DI)** ($mg/week$) is calculated as: Cumulative dose ($mg$) / Treatment duration ($weeks$)
* The **Planned Dose Intensity (PDI)** ($mg/week$) is calculated as: Cumulative planned dose per cycle ($mg$) / (Planned Treatment duration/7) ($weeks$)
* The **Relative Dose Intensity (RDI)** ($%$) is calculated as: 100 * DI ($mg/week$) / PDI ($mg/week$)

Related considerations:

* An RDI of 100% indicates that the drug was administered at the right dose within the planned timeframe
* Dose may also be measured as $mg/m^2$ when treatment are infused, in this case the total dose expressed in $mg$ is divided by the subject **body surface area (BSA)** ($m^2$) measured at the time of the drug administration
* For some study drugs the doses may also be measured as $mg/kg$
* Both DI and RDI together with Cumulative Dose and Treatment Duration, are described by means of descriptive statistics for continuos variables. Additionally frequency distribution together with % of number of Administered Cycle is also provided
* In combination studies, when applicable, the above information is derived and presented for each drug administered taking into account that the treatment duration may be different for each one of them

## Treatment Delays, Reductions and Interruptions

If it's not explicitely defined in the protocol, in oncology clinical trials a delay of more than 3 days will be considered as a relevant delay. Delays of less than 3 days will be considered as if the treatment was given at the right date. This standard definition is stablished to account for weekends as non-working days.

Other point that must be defined in the protocol is if delays are permitted or not, so you wouldn't/would need to include 0-dose cycles when computing the DI or RDI.
