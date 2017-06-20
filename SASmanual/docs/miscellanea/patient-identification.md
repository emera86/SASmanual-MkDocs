## Separate Site ID from Patient Number

* Site calculation from the two first numbers of the patient number:

```
site = SUBSTR(PUT(patient,z4.),1,2);
```

!!! note
    1. `PUT`: turns the numeric variable *patient* into a string (`z4.` adds leading zeroes if needed)
    2. `SUBSTR`: takes the first **2** characters starting from position **1**