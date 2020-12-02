!!! summary "Series of Short Videos on the SAS Clinical Data Integration Solution (CDI)"
    1. [Defining a Clinical Study](https://youtu.be/JftoqxZdd5I)
    2. [Registering Source or Raw Data](https://youtu.be/lRz5t5UIN_U)
    3. [Defining SDTM Domain Metadata](https://youtu.be/kockvXrONiE)
    4. [Mapping Source Data to SDTM Domains](https://youtu.be/h0Ds8zr5DHc)
    5. [Creating Job Templates](https://youtu.be/vEOy6EkTbIA)

## Implementing SDTM with SAS Clinical Data Integration

SAS Clinical Data Integration is an ETL tool built on top of SAS Data Management that includes specific functionality to support clinical trials.

## How to Create a Standard SDTM Domain

Please not before starting this process that each project is not allowed to have more than one active domain with the same name.

To create a standard SDTM Domain:
Folders > [Project name] > SDTM (right click)> New > Standard Domain(s)...
![new-standard-domain](../images/CDI/new-standard-domain.png "New Standard Domain")

Then you need to follow these steps:

  * **Domain Location**: select the folder where the new Domain(s) will be placed
  * **Data Standard Selection**: select the applicable data standard (right now there is only one available, SDTMv3.2)
  * **Domain Template Selection**: select the *Domain Template* to apply
  * **Library Selection**: right now there are no default libraries so you would need to define it later 

After a *Creating the specified domains* message you will find the new Domain in your SDTM folder, it will be empty as you have only created the structure.
  
## Warnings and Errors
  
### Integrity Constraint Compliance
The following warning message can appear for two main reasons:
![integrity-constraint](../images/CDI/integrity-constraint.PNG "Integrity Constraint")

  * The primary keys of the output dataset are not well defined: some are automatically defined but you may need to add some extra ones to avoid information overlapping
  
  ![primary-keys](../images/CDI/primary-keys.PNG "Primary Keys")
  
  * Some variables have missing values: this may come from an earlier flow step or mapping mistake, but some variables can't be null 
