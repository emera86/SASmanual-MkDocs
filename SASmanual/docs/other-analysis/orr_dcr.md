## Objective Response Rate (ORR)

In medicine, a **response rate** is the percentage of patients whose cancer shrinks or disappears after treatment. When used as a clinical endpoint for clinical trials of cancer treatments, this often called the **objective response rate (ORR)**. The FDA definition of ORR is *"the proportion of patients with tumor size reduction of a predefined amount and for a minimum time period"*.

## Disease Control Rate (DCR)

The **disease control rate (DCR)** or **clinical benefit rate (CBR)** is defined as the percentage of patients with advanced or metastatic cancer who have achieved complete response, partial response or stable disease to a therapeutic intervention in clinical trials of anticancer agents. 

## Calculation

```
data orr_dcr;
   	input pt $ bestresp $ orr dcr c_orr $ c_dcr $;
   	datalines;
001 PD 0 0 N N
002 SD 0 1 N Y
003 SD 0 1 N Y
004 PD 0 0 N N
005 PD 0 0 N N 
006 PD 0 0 N N 
007 SD 0 1 N Y
008 SD 0 1 N Y
009 PD 0 0 N N 
010 SD 0 1 N Y
011 PR 1 1 Y Y 
012 PR 1 1 Y Y 
;
run;

ods exclude all;
proc freq data=orr_dcr;
	table orr / nocum binomial(exact level=2) alpha=0.05;
	ods output BinomialCLs=orr_prop_ci;
run;
proc freq data=orr_dcr;
	table dcr / nocum binomial(exact level=2) alpha=0.05;
	ods output BinomialCLs=dcr_prop_ci;
run;
ods exclude none;

data orr_dcr_prop_ci;
	set orr_prop_ci dcr_prop_ci;
	propci = trim(left(put(Proportion*100,5.2)))||' ('||trim(left(put(LowerCL*100,5.2)))||', '||trim(left(put(UpperCL*100,5.2)))||')';
	prop = trim(left(put(Proportion*100,5.2)));
	ci = trim(left(put(LowerCL*100,5.2)))||', '||trim(left(put(UpperCL*100,5.2)));
	if table = 'Table orr' then texto = 'ORR';
	if table = 'Table dcr' then texto = 'DCR';
	drop type;
run;

proc report data=orr_dcr_prop_ci nowd headline style(header)={background=very light grey fontsize=8pt} missing style(column)={fontsize=8pt} style(report)={width=100%} split='*';
	title "Response Rates";
	column ("Response Rates" texto propci prop ci);

	define texto / display ' ' flow;
	define propci / display 'Proportion (CI 95%)' flow;
	define prop / display 'Proportion' flow;
	define ci / display 'CI 95%' flow;
run;
```
