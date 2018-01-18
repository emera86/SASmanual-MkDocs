## Dealing with Study Identification Numbers

### Site calculation from the two first numbers of the patient number:

```
site = SUBSTR(PUT(patient,z4.),1,2);
```

* `PUT`: turns the numeric variable *patient* into a string (`z4.` adds leading zeroes if needed)
* `SUBSTR`: takes the first **2** characters starting from position **1**

!!! warning
    The `patient` variable has to be **numeric**, otherwise an format note will be generated. Build a numeric version of your `patient` variable if it originally it is a character value.
    
### Subtract the patient number (e.g. last 4 characters) from a string:

```
patient = substr(patient_code,max(1,length(patient_code)-3));
```

### Join the site number and the patient number to get a more general ID number for each patient:

```
patient = PUT(nsite,z2.) || PUT(npatient,z2.);
```
