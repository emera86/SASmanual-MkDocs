**CDISC** (Clinical Data Interchanging Standards Consortium) standards are to support the acquisition, exchange, submission and archival of clinical trial and research data. **SDTM** (Study Data Tabulation Model) for **CRFs** (Case Report Forms) was recommended for U.S. Food and Drug Administration (FDA) regulatory submissions since 2004. Although the SDTM Implementation Guide gives a standardized and predefined collection of submission metadata "domains" containing extensive variable collections, transforming CRFs to SDTM files for FDA submission is still a very hard and time-consuming task. 

!!! summary "Check these websites"
    * [Using CDISC Standards with an MDR for EDC to Submission Traceability (2019)](https://www.lexjansen.com/pharmasug/2019/DS/PharmaSUG-2019-DS-308.pdf)
    * [Streamline process: To Generate SDTM Program by Automation (2019)](https://pdfs.semanticscholar.org/6b5f/8e004c38735c4dd104065b0b5d983394f4d3.pdf)
    * [CDISC SDTM - An Automated Approach (2018)](https://www.lexjansen.com/phuse/2018/si/SI11.pdf)
    * [AUTOSDTM: A Macro to Automatically Map CDASH Data to SDTM (2017)](https://support.sas.com/resources/papers/proceedings17/1352-2017.pdf)
    * [SDTM Automation with Standard CRF Pages (2016)](https://www.pharmasug.org/proceedings/2016/PO/PharmaSUG-2016-PO21.pdf)
    * [CDISC Transformer: a metadata-based transformation tool for clinical trial and research data into CDISC standards (2011)](http://www.itiis.org/digital-library/manuscript/239)  
    * [Confessions of a Clinical Programmer: Creating SDTM Domains with SAS](https://www.sas.com/content/dam/SAS/en_us/doc/whitepaper1/confessions-of-a-clinical-programmer-105353.pdf)
    
## [Target Domain](https://www.semanticscholar.org/paper/Practical-Methods-for-Creating-CDISC-SDTM-Domain-Graebner/cfa34869f92bec4f7c9c58505b64ef5201ea0dee/figure/0)

| Category/Class      | Domain abbreviation   | Domain name | Comments |
|---------------------|----|------------------------------|------------|
| **Special Purpose** | DM | Demographics                 | One of the few domains with one register per subject, contain variables that are always present for all studies.|
|                     | CO | Comments                     | |
|                     | SE | Subject Elements             | It details the visit scheme that each subject should have.|
|                     | SV | Subject Visits               | Visit dates.|
| **Interventions**   | CM | Concomitant and Prior Medications      | |
|                     | EC | Exposure as Collected        | |
|                     | EX | Exposure                     | |
|                     | PR | Procedures                   | |
|                     | SU | Substance Use                | |
| **Events**          | AE | Adverse Events               | |
|                     | DS | Disposition                  | |
|                     | MH | Medical History              | |
|                     | DV | Protocol Deviations          | |
|                     | HE | Health Encounters            | |
|                     | CE | Clinical Events              | |
| **Findings**        | EG | ECG Test Results             | |
|                     | IE | Inclusion/Exclusion Exception | |
|                     | LB | Laboratory Tests Results     | |
|                     | PE | Physical Examination         | |
|                     | QS | Questionnaires               | |
|                     | SC | Subject Characteristics      | |
|                     | VS | Vital Signs                  | |
|                     | DA | Drug Accountability          | |
|                     | MB | Microbiology Specimen        | |
|                     | MS | Microbiology Susceptibility  | |
|                     | PC | Pharmacokinetic Concentrations | |
|                     | PP | Pharmacokinetic Parameters    | |
|                     | FA | Findings About Events       | |
| **Experimental Design**        | UK | UK             | |
| **Scheduling of Assessments**        | UK | UK             | |
| **Trial Summary Eligilility**        | UK | UK             | |

## [SDTM Model Concepts and Terms](http://pharma-sas.com/sdtm-model-concepts-and-terms/)

### [Domain vs Dataset: What's the Difference?](https://www.cdisc.org/kb/articles/domain-vs-dataset-whats-difference)
The terms “domain” and “dataset” are commonly used in CDISC’s nomenclature and found frequently in the Study Data Tabulation Model (SDTM). The CDISC Glossary defines these terms as follows:

  * **Domain**: A collection of logically related observations with a common, specific topic that are normally collected for all subjects in a clinical investigation. Example domains include laboratory test results (LB), adverse events (AE), concomitant medications (CM). 
  * **Dataset**: A collection of structured data in a single file. 
  
In plainer terms, a domain is a grouping of observations that are related while a dataset is the data structure associated with that grouping of observations. Both domains and datasets use the same nomenclature, which is why they are often confused.

The distinction between domain and dataset is most clearly seen in cases where a general observation class domain is split into multiple datasets in a submission. Common examples are splitting the Laboratory Test Results (LB) domain due to size, splitting the Questionnaires (QS) domain by questionnaire, and splitting the Findings About Events or Interventions (FA) domain by parent domain.

However, since in most cases there is a one-to-one relationships between a conceptual domain and a dataset based on that conceptual domain, the words are used interchangeably in the standards and, therefore, by most users. 

### Variable Types

Note that **Core** variable together with the other two shaded columns **CDISC Notes** and **References** are not sent to FDA. Three categories of variables are specified in the **Core** column:

| Core variable       | Meaning             | Description         |
|---------------------|---------------------|---------------------|
| **Req** | Required | **Required** variables must always be include in the dataset and cannot be null for any record. They are basic to the identification of a data record and are necessary to make record meaningful (key variables and topic variables). |
| **Exp** | Expected | **Expected** variables may contain some null values and still are included in the dataset even when no data has been collected. In this case, a comment can be included in define.xml to state that data was not collected. |
| **Perm** | Permissible | The sponsor can decide whether a **Permissible** variable should be included as a column when all values for that variable are null. |
