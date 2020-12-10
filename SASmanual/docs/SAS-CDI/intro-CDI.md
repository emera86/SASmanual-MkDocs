!!! summary "Check these Websites"
    * [Using SAS CDI to Implement and Manage CDISC Standards](https://www.yumpu.com/en/document/view/32137420/using-sas-clinical-data-integration-to-implement-and-phuse-wiki)

!!! summary "Series of Short Videos on the SAS Clinical Data Integration Solution (CDI)"
    1. [Defining a Clinical Study](https://youtu.be/JftoqxZdd5I)
    2. [Registering Source or Raw Data](https://youtu.be/lRz5t5UIN_U)
    3. [Defining SDTM Domain Metadata](https://youtu.be/kockvXrONiE)
    4. [Mapping Source Data to SDTM Domains](https://youtu.be/h0Ds8zr5DHc)
    5. [Creating Job Templates](https://youtu.be/vEOy6EkTbIA)

## Implementing SDTM with SAS Clinical Data Integration

SAS Clinical Data Integration is an ETL tool built on top of SAS Data Management that includes specific functionality to support clinical trials. The main steps to take during the SDTM domains creation process are:

  1. Define your study on SAS CDI and the working folders as needed (Jobs, SRCDATA, SDTM, ADaM, TEMP, etc.)
  2. Extract raw datasets from the clinical database
  3. Register the raw datasets and assign the corresponding libraries
  4. Identify the source variables/datasets that will be needed to build each domain
  5. Load SDTM domains standard structure
  6. Create a new job (recommended one per domain depending on the complexity of the transformations needed)
  7. Create a work flow of transformations inside the job to reach the final desired SDTM structure from the raw datasets
  8. Load SDTM domains with the transformed data
  9. Validate SDTM Domains
  
### Libraries

### Jobs

### Domains
The domains are the 

Conjuntos de variables. Los estándares definen qué variables tiene cada uno, cuales son obligatorias, opcionales o recomendables y cuales se deben enviar. En algunas te tienes que limitar a una estructura restringida y tienes que meter la información extra en un dominio suplementario que va ligado al principal, pero otros dominios son un poco más flexibles. Hay información que te puede cuadrar en varios dominios, ahí entra ya la interpretación del sponsor o del que mapea la base de datos. El estándar no está totalmente cerrado y hay cosas que hay que decidir y será necesario justificar las decisiones.

### Pinacle21/OpenCDISC
Validar que tus data sets cumplen todas las reglas y estándares que impone CDISC. Te presenta un informe en excel de los errores.

### Define.xml compliance
SAS CDI genera este fichero automáticamente agrupando toda la información necesaria para enviar a las agencias regulatorias con hipervínculos entre sección.
El archivo Define.xml contiene toda la información anterior.

## How to Create a Standard SDTM Domain

### Loading the Standard Structure

Please note before starting this process that each project is not allowed to have more than one active domain with the same name.

To create a standard SDTM Domain:
Folders > [Project name] > SDTM (right click)> New > Standard Domain(s)...

![new-standard-domain](../images/CDI/new-standard-domain.png "New Standard Domain")

Then you need to follow these steps:

  * **Domain Location**: select the folder where the new Domain(s) will be placed
  * **Data Standard Selection**: select the applicable data standard (right now there is only one available, SDTMv3.2)
  * **Domain Template Selection**: select the *Domain Template* to apply
  * **Library Selection**: right now there are no default libraries so you would need to define it later 

After a *Creating the specified domains* message you will find the new Domain in your SDTM folder, it will be empty as you have only created the structure.
As the library was not specified during the creation process you will also need to define it in the properties menu of the SDTM standard domain:

![assign-library-to-standard-domain](../images/CDI/assign-library-to-standard-domain.png "Assigning library to standard domain")

### Fill with Data

Once you have the structure of the dataset you want to create, you need to define a operation flow to achieve this structure thourgh the concatenation of the following **transformations**: 

  * **Access > Table Loader**: is needed as the previous step to a SDTM domain definition
  
  ![table-loader](../images/CDI/table-loader.PNG "Table Loader")
  
  * **SQL > Create Table**: will allow any kind of operations in the input dataset
  
  ![create-table](../images/CDI/create-table.PNG "Create Table")
  
  * **SQL > Join**:
  
  * **SQL > Extract**:
  
  * **Data > Sort**:
  
  * **Data > Append**:
  
  * **Data > User written Code**:
  
  * **Clinical > Subject Sequence Generator**:
  
  * **Clinical > CDISC-SDTM/ADaM Compliance**:

## Warnings and Errors
  
### Integrity Constraint Compliance
The following warning message can appear for two main reasons:

![integrity-constraint](../images/CDI/integrity-constraint.PNG "Integrity Constraint")

  * The primary keys of the output dataset are not well defined: some are automatically defined but you may need to add some extra ones to avoid information overlapping
  
  ![primary-keys](../images/CDI/primary-keys.PNG "Primary Keys")
  
  * Some variables have missing values: this may come from an earlier flow step or mapping mistake, but some variables can't be null 
