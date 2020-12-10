!!! summary "Check these websites"
    * [CDISC Official Site](https://www.cdisc.org/)
    * [CDISC Standards](https://www.cdisc.org/standards)
    * [Macro-Supported Metadata-Driven Process for Mapping SDTM VISIT and VISITNUM](https://www.lexjansen.com/pharmasug/2018/AD/PharmaSUG-2018-AD09.pdf)

## CDISC Standards
The Clinical Data Interchange Standards Consortium (CDISC) has worked over the last several years to create standards for the pharmaceutical, biotechnology and medical
device companies to adopt. Now, there is a whole new level of data management programming that needs to be done during the submission process. 

Let's see the differences between CDASH, SDTM/SEND and ADaM.

### Clinical Data Acquisition Standards Harmonization (**CDASH**)

CDASH establishes a standard way to collect data consistently across studies and sponsors so that data collection formats and structures provide clear traceability of submission data into the Study Data Tabulation Model (SDTM), delivering more transparency to regulators and others who conduct data review. 

This is a standard for data collecting, not for data submission. The datasets may not be inspired in SDTM (vertical structure) to design the clinical database but in CDASH instead. From this first data structure some transformations will be applied to build the SDTM domains.

### Study Data Tabulation Model (**SDTM**)

Along with the transformation from CDASH to SDTM, a new annotated CRF based on the original CDASH one has to be prepared with the new SDTM variables. This new annotation may require conditional structures to rearrange the old variables in a vertical manner into a single new variable.

Where the SDTM provides a standard model for organizing and formatting data for human and animal studies, the [SDTM Implementation Guide (SDTMIG)](https://www.cdisc.org/standards/foundational/sdtmig) is intended to guide the organization, structure, and format of standard clinical trial tabulation datasets.

### Analysis Data Model (**ADaM**)

ADaM defines dataset and metadata standards that support:

  * efficient generation, replication, and review of clinical trial statistical analyses, and
  * traceability among analysis results, analysis data, and data represented in the Study Data Tabulation Model (SDTM).

The ADaM [Implementation Guide (ADaMIG)](https://www.cdisc.org/standards/foundational/adam/adamig-v12) is intended to guide the organization, structure, and format of analysis datasets and related metadata. It specifies ADaM standard dataset structures and variables, including naming conventions, and presents standard solutions to implementation issues, illustrated with examples.

Among the analysis dataset there are different types:
  * Adverse Event Analysis Dataset (ADAE)
  * Subject-Level Analysis Dataset (ADSL)
  * ADaM Basic Data Structure (BDS)

### Standard for Exchange of Nonclinical Data (**SEND**)

A less restrictive implementation of the SDTM standards for non-clinical studies with more variability.

## CDISC General Concepts

### [Domain vs Dataset: What's the Difference?](https://www.cdisc.org/kb/articles/domain-vs-dataset-whats-difference)
The terms “domain” and “dataset” are commonly used in CDISC’s nomenclature and found frequently in the Study Data Tabulation Model (SDTM). The CDISC Glossary defines these terms as follows:

  * **Domain**: A collection of logically related observations with a common, specific topic that are normally collected for all subjects in a clinical investigation. Example domains include laboratory test results (LB), adverse events (AE), concomitant medications (CM). 
  * **Dataset**: A collection of structured data in a single file. 
  
In plainer terms, a domain is a grouping of observations that are related while a dataset is the data structure associated with that grouping of observations. Both domains and datasets use the same nomenclature, which is why they are often confused.

The distinction between domain and dataset is most clearly seen in cases where a general observation class domain is split into multiple datasets in a submission. Common examples are splitting the Laboratory Test Results (LB) domain due to size, splitting the Questionnaires (QS) domain by questionnaire, and splitting the Findings About Events or Interventions (FA) domain by parent domain.

However, since in most cases there is a one-to-one relationships between a conceptual domain and a dataset based on that conceptual domain, the words are used interchangeably in the standards and, therefore, by most users. 

### [Domain Variable Types (Core)](http://pharma-sas.com/sdtm-model-concepts-and-terms/)

| Variable Type   |  Abbreviation  |  Definition |
|---|---|---|
| Required  | **Req**  | **Required** variables must always be included in the dataset and cannot be null for any record. They are basic to the identification of a data record and are necessary to make the record meaningful (key variables and topic variables).  |
| Expected | **Exp**  | **Expected** variables may contain some null values and still are included in the dataset even when no data has been collected. In this case, a comment can be included in define.xml to state that data was not collected.  |
| Permissible | **Perm**  | The sponsor can decide whether a **Permissible** variable should be included as a column when all values for that variable are null.  |
