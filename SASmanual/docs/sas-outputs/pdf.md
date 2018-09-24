## `ODS` definition for \*.pdf format

```
ODS PDF DPI=700 STYLE=customstyle FILE="path\file (&sysdate).pdf" PDFTOC=1;
(...)
ODS PDF CLOSE;
```

* `DPI` needs to be increased to show the preimage logo with good definition
* The `FILE` definition must contain the output path too, `ODS PDF` is not compatible with the `PATH=` option
* `PDFTOC` fixed the number of TOC levels displayed by default when openning the file (even if there are more defined the tree will appear contracted)

## TOC customization

* First level: `ods proclabel="Name";`
* Second level (remove): `contents = ""` inside `PROC REPORT` statement
* Third level (remove): define an auxiliary variable `count = 1` in your data set and include it in the `PROC REPORT`
``` 
column ("Title" count ...);
define count / group noprint;
break before count / contents="" page; 
```
