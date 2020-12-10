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
