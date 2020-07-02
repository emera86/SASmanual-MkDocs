**CDISC** (Clinical Data Interchanging Standards Consortium) standards are to support the acquisition, exchange, submission and archival of clinical trial and research data. **SDTM** (Study Data Tabulation Model) for **CRFs** (Case Report Forms) was recommended for U.S. Food and Drug Administration (FDA) regulatory submissions since 2004. Although the SDTM Implementation Guide gives a standardized and predefined collection of submission metadata "domains" containing extensive variable collections, transforming CRFs to SDTM files for FDA submission is still a very hard and time-consuming task. 

!!! summary "Check these websites"
    [Using CDISC Standards with an MDR for EDC to Submission Traceability (2019)](https://www.lexjansen.com/pharmasug/2019/DS/PharmaSUG-2019-DS-308.pdf)
    [Streamline process: To Generate SDTM Program by Automation (2019)](https://pdfs.semanticscholar.org/6b5f/8e004c38735c4dd104065b0b5d983394f4d3.pdf)
    [CDISC SDTM - An Automated Approach (2018)](https://www.lexjansen.com/phuse/2018/si/SI11.pdf)
    [AUTOSDTM: A Macro to Automatically Map CDASH Data to SDTM (2017)](https://support.sas.com/resources/papers/proceedings17/1352-2017.pdf)
    [SDTM Automation with Standard CRF Pages (2016)](https://www.pharmasug.org/proceedings/2016/PO/PharmaSUG-2016-PO21.pdf)
    [CDISC Transformer: a metadata-based transformation tool for clinical trial and research data into CDISC standards (2011)](http://www.itiis.org/digital-library/manuscript/239)  
    [Confessions of a Clinical Programmer: Creating SDTM Domains with SAS](https://www.sas.com/content/dam/SAS/en_us/doc/whitepaper1/confessions-of-a-clinical-programmer-105353.pdf)
    
## Target Domain

| Category/Class      | Domain abbreviation   | Domain name |
|---------------------|----|------------------------------|
| **Special Purpose** | DM | Demographics                 |
|                     | CO | Comments                     |
|                     | SE | Subject Elements             |
|                     | SV | Subject Visits               |
| **Interventions**   | CM | Concomitant Medications      |
|                     | EX | Exposure                     |
|                     | SU | Substance Use                |
| **Events**          | AE | Adverse Events               |
|                     | DS | Disposition                  |
|                     | MH | Medical History              |
|                     | DV | Protocol Deviations          |
|                     | CE | Clinical Events              |
| **Findings**        | EG | ECG Test Results             |
|                     | IE | Inclusion/Exclusion Exception |
|                     | LB | Laboratory Tests Results     |
|                     | PE | Physical Examination         |
|                     | QS | Questionnaires               |
|                     | SC | Subject Characteristics      |
|                     | VS | Vital Signs                  |
|                     | DA | Drug Accountability          |
|                     | MB | Microbiology Specimen        |
|                     | MS | Microbiology Susceptibility  |
|                     | PC | Pharmacokinetic Concentrations |
|                     | PP | Pharmacokinetic Parameters    |
|                     | FA | Findings About Events       |

https://www.semanticscholar.org/paper/Practical-Methods-for-Creating-CDISC-SDTM-Domain-Graebner/cfa34869f92bec4f7c9c58505b64ef5201ea0dee/figure/0

There is no common rule for converting clinical trial data to CDISC standard-compliant data. Without automation, they require labor intensive or time-consuming processes such as
re-entering data and manually mapping the data to the standard models.

## SDTM Model Concepts and Terms

Note that **Core** variable together with the other two shaded columns **CDISC Notes** and **References** are not sent to FDA. Three categories of variables are specified in the **Core** column:

| Core variable       | Meaning             | Description         |
|---------------------|---------------------|---------------------|
| **Req** | Required | **Required** variables must always be include in the dataset and cannot be null for any record. They are basic to the identification of a data record and are necessary to make record meaningful (key variables and topic variables). |
| **Exp** | Expected | **Expected** variables may contain some null values and still are included in the dataset even when no data has been collected. In this case, a comment can be included in define.xml to state that data was not collected. |
| **Perm** | Permissible | The sponsor can decide whether a **Permissible** variable should be included as a column when all values for that variable are null. |
