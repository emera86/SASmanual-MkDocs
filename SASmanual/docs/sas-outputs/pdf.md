## TOC customization

* First level: `ods proclabel="Name";`
* Second level (remove): `contents = ""` inside `PROC REPORT` statement
* Third level (remove): define an auxiliary variable `count = 1` in your data set and include it in the `PROC REPORT`
```column ("Title" count ...);
	 define count / group noprint;
	 break before count / contents="" page; ```
