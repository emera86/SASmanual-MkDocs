!!! summary "Check these websites"
    * [CDISC Official Site](https://www.cdisc.org/)
    * [CDISC Standards](https://www.cdisc.org/standards)
    * [Macro-Supported Metadata-Driven Process for Mapping SDTM VISIT and VISITNUM](https://www.lexjansen.com/pharmasug/2018/AD/PharmaSUG-2018-AD09.pdf)

## CDISC Standards
The Clinical Data Interchange Standards Consortium (CDISC) has worked over the last several years to create standards for the pharmaceutical, biotechnology and medical
device companies to adopt. Now, there is a whole new level of data management programming that needs to be done during the submission process. 

## [Domain vs Dataset: What's the Difference?](https://www.cdisc.org/kb/articles/domain-vs-dataset-whats-difference)
The terms “domain” and “dataset” are commonly used in CDISC’s nomenclature and found frequently in the Study Data Tabulation Model (SDTM). The CDISC Glossary defines these terms as follows:

  * **Domain**: A collection of logically related observations with a common, specific topic that are normally collected for all subjects in a clinical investigation. Example domains include laboratory test results (LB), adverse events (AE), concomitant medications (CM). 
  * **Dataset**: A collection of structured data in a single file. 
  
In plainer terms, a domain is a grouping of observations that are related while a dataset is the data structure associated with that grouping of observations. Both domains and datasets use the same nomenclature, which is why they are often confused.

The distinction between domain and dataset is most clearly seen in cases where a general observation class domain is split into multiple datasets in a submission. Common examples are splitting the Laboratory Test Results (LB) domain due to size, splitting the Questionnaires (QS) domain by questionnaire, and splitting the Findings About Events or Interventions (FA) domain by parent domain.

However, since in most cases there is a one-to-one relationships between a conceptual domain and a dataset based on that conceptual domain, the words are used interchangeably in the standards and, therefore, by most users. 

----

## Diferencias entre CDASH, SDTM/SEND y ADAM

### CDASH
Clinical Data Acquisition Standards Harmonization

Lograr que los datos sean recogidos de manera más homogénea. No está pensado para presentar los datos sino para recogerlos. Estándar para la recogida de datos. No hay que inspirarse en SDTM (estructura vertical) para diseñar la base de datos sino en CDASH, y luego ya se hará una transformación a SDTM.

### SDTM
Study Data Tabulation Model

Depués de la transformación se tiene que reportar sobre el CRF anotado una nueva anotación con las variables SDTM. Esta nueva anotación puede requerir estructuras condicionales para poder reconocer las nuevas variables.

### ADaM
Analysis Data Model

Define los estándares de data sets y metadata de cara a un análisis y presentación de resultados. Permite una generación eficiente, replicación y revisión de los datos usados para realizar análisis estadísticos en ensayos clínicos.

### SEND
Standard for Exchange of Nonclinical Data

Una implementación menos restrictiva de SDTM para estudios no clínicos que tienen más variabilidad.
	
## ¿Qué es el CDI?
SAS Clinical Data Integration. Te permite hacer un mapeo de tu base de datos original y la documentación de la transformación se genera automáticamente.

### Librerías

### Jobs

### Dominios
Conjuntos de variables. Los estándares definen qué variables tiene cada uno, cuales son obligatorias, opcionales o recomendables y cuales se deben enviar. En algunas te tienes que limitar a una estructura restringida y tienes que meter la información extra en un dominio suplementario que va ligado al principal, pero otros dominios son un poco más flexibles. Hay información que te puede cuadrar en varios dominios, ahí entra ya la interpretación del sponsor o del que mapea la base de datos. El estándar no está totalmente cerrado y hay cosas que hay que decidir y será necesario justificar las decisiones.

### Pinacle21/OpenCDISC
Validar que tus data sets cumplen todas las reglas y estándares que impone CDISC. Te presenta un informe en excel de los errores.

## Diferentes tipos de dominios

### Dominios de propósito especial

* CO (Comments)
* DM (Demographics): una de las pocas tablas que es plana, se recogen variables que siempre están en todos los estudios que tienen nombre propio.
* SE (Subject Elements): especifica las visitas que va a tener el paciente a nivel de elemento, el esquema de visitas que debería tener el paciente.
* SV (Subject Visits): fechas de visitas
	
### General Observation Classes

* Intervenciones: dominios que recogen acciones o intervenciones sobre los pacientes: CM (Concomitant and Prior Medications), EX (Exposure), EC (Exposure as Collected), PR (Procedures), SU (Substance Use)
* Eventos: dominios donde se recogen los acontecimientos que suceden sobre el paciente: AE (Adverse Events), CE (Clinical Events), DS (Disposition), DV (Protocol Deviations), HO (Helthcare Encounters), MH (Medical History)
* Findings: todo el resto de la información del estudio.
* Experimental Design
* Scheduling of Assessments
* Trial Summary Eligilility

## Caso práctico

1. Extract from OC
2. Transform in SAS CDI
3. Load SDTM Domains
4. Validate SDTM Domains

### Implementación
Requerimientos: se define el estudio, la librería, los data sets originales y se carga la versión de los estándares que se van a usar (SDTM, ADaM) que se quedará registrado en la metadata del estudio.
Pasos: 

1. registrar los data sets originales, 
2. crear un nuevo job, 
3. identificar las variables y data sets que van a componer cada dominio, 
4. hacer la transformación pertinente, 
5. validar los dominios.

### Tipos de variables

* Required: obligatorias y no permiten missing ni duplicados
* Expected: hay que incluirlas pero pueden no estar informadas
* Permissible: si tiene datos en algún registro se supone que hay que reportarla, aunque no saben que la tienes recogida porque no es required, con lo cual a efectos prácticos las puedes quitar si quieres
	
## Validación de los dominios

### Define.xml compliance
SAS CDI genera este fichero automáticamente agrupando toda la información necesaria para enviar a las agencias regulatorias con hipervínculos entre sección.
El archivo Define.xml contiene toda la información anterior.
