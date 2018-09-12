**soh**********************************************************************************************************************
   Eli Lilly and Company - GSS & Advanced Analytics Group - Program
   PROGRAM NAME          : survRM2_1_0.sas 
   PROJECT NAME          : Restricted Mean Survival Time (RMST2)
   DESCRIPTION           : Comparing two survival curves using the restricted mean survival time 

   SOFTWARE/VERSION#     : SAS 9.3 
   INFRASTRUCTURE        : PC SAS
   LIMITED-USE MODULES   : N/A
   BROAD-USE MODULES     : N/A
   INPUT                 :  
   OUTPUT                : Restricted mean survival time difference
   VALIDATION LEVEL      : N/A
   REPLICATION PROGRAM   : N/A
   REGULATORY STATUS     : 
   REQUIREMENTS LOCATION : 
  -----------------------------------------------------------------------------
  Requirements: 
  -----------------------------------------------------------------------------
  Ver#  Author &                    Program History Description
        Peer Reviewer
  ----  ---------------            --------------------------------------------
  002   CHAKIB BATTIOUI            	Dev version of the program

  **eoh************************************************************************************************************;


options mprint;


/*#############################
# RMST1 (one-arm)  
#############################*/

 %macro RMST1 (dtin=,     /* source data */
			   time=,     /* time to event */
			   status=,   /* censoring are values where event is equal 0 */
			   tau=,      /* truncation time */
			   alpha=,    /* gives (1-alpha) confidence interval */
			   path=,     /* specify the path where to store the survival plots */
               SP_arm=,   /* Survival plot name. RMST2 macro will output SP_arm1.rtf and SP_arm0.rtf */
			   dtout=);   /* the output data file name */

	 ods rtf file ="&path.\&SP_arm.";
	 ods Graphics on;
	 ods output ProductLimitEstimates=_estimates (where=(ObservedEvents ^=.));
	 ods trace on;
		proc lifetest data=&dtin. outsurv=_outsurv atrisk plots=(s,p) timemax=&tau.;   
					ods select SurvivalPlot;
			time &time.*&status.(0);
		 run;
	 ods trace off;
	 ods Graphics off;
	 ods rtf close;

	data _outsurv;
		set _outsurv ;
		 	retain _survival;
		  	if not missing(survival) then _survival=survival;
			else survival=_survival;
	run;
	 
	data _estimates_cl;
	 	merge _outsurv (in=a) _estimates (keep= &time. NumberAtRisk ObservedEvents );
		if a;
		by &time.;
		if missing(NumberAtRisk) then delete;
		if &time. <= &tau.;
	run;
  	
  	data _estimates_cl;
	 	set _estimates_cl end=last;
	 	lagt=lag(&time.);
		lags=lag(survival);
	 	output ;
	 	if last then do;
			lagt=&time.;
			&time.=&tau.;
			lags=survival;
		output ;
	 	end;
	run;

	data _area (keep=RMST_est) _wk_var (keep=&time. wk_var index);
		set _estimates_cl ;
			format wk_var 12.10;
			index=_n_;
			if lagt =. then delete;
			RMST_est=(&time.-lagt)*lags;
			if (NumberAtRisk = ObservedEvents) then wk_var=0; 
			else wk_var=(ObservedEvents /(NumberAtRisk *(NumberAtRisk - ObservedEvents)));
			if &time. ^= &tau. then output _wk_var;
			output _area;
	run;
	
	proc summary data=_area; 
		var RMST_est; 
		output out=_RMST (keep=RMST_est) sum=;
	run;

	data _area;
		set _area;
		if _n_=1 then delete;
 		index = _n_ ;
	run ;

	data _var;
		merge _area _wk_var;
		by index;
	run;

	proc sort data=_var ; by descending index ; run ;
	
	data _var;
		set _var;
		retain cumarea;
		if _n_=1 then cumarea=RMST_est; else cumarea=RMST_est+cumarea;
		RMST_var=cumarea*cumarea*wk_var;
	run;

	proc summary data=_var; 
		var RMST_var; 
		output out=_RMST_var (keep=RMST_var) sum=;
	run;

	%let c= 1-&alpha./2;
	data &dtout.  ;
		merge _RMST _RMST_var;
		RMST_se=sqrt(RMST_var);
		RMST_low_ci=RMST_est-RMST_se*quantile('NORMAL',&c. , 0, 1);
		RMST_upp_ci=RMST_est+RMST_se*quantile('NORMAL',&c. , 0, 1);
		RMTL_est=&tau.-RMST_est; RMTL_se=RMST_se; RMTL_low_ci=&tau.-RMST_upp_ci; RMTL_upp_ci=&tau.-RMST_low_ci;
	run;

	proc delete data = _estimates _outsurv _estimates_cl _area _wk_var _RMST _var _RMST_var ; run;

%mend RMST1;
*%RMST1(dtin=D,time=time, status=status, tau=10, alpha=0.05,path=c:\temp,SP_arm=all.rtf,dtout=_RMST_out);

%macro rmst2reg (dt_in=,       /* source data */
			     time=,       /* time to event */
			     status=,     /* censoring are values where event is equal 0 */
			     tau=,        /* truncation time */
				 trt=,        /* treatment variable */
				 covariates=, /* list of covariates to use for the adjustment.*/
				 type=,       /* type of RMST method. DIFFERENCE, RATIO or LOSSRATIO.*/
                 dt_out=);    /* output data file */

	%if %upcase(&type.) ^=DIFFERENCE and %upcase(&type.) ^=RATIO and %upcase(&type.) ^=LOSSRATIO %then %do;
		%put ERROR:<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    Type must be difference, ratio or lossratio
                   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>;
	%end;
	%else %if %upcase(&type.)=DIFFERENCE or %upcase(&type.)=RATIO or %upcase(&type.)=LOSSRATIO %then %do;
		data _armx1 _armx0;
			set &dt_in.;
				_y=min(&time.,&tau.);
				_y_lr=&tau.-_y;
				if _y=&tau. then _d=0; else _d=(1-&status.);
				if &trt.=1 then output _armx1;
				else if &trt.=0 then output _armx0;
		run;

		ods output ProductLimitEstimates=_estm1 (where=(ObservedEvents ^=.));
			proc lifetest data=_armx1 atrisk ;    
				time _y*_d(0); * censoring are values where event is equal 0;
	 		run;
		ods output close;

		data _estm12;
	 		set _estm1 ;
			format obsevt 12.0  weights 12.6;
			retain _survival;
			if missing(survival) then do;
				survival = _survival;
			end; 
			else do;
				_survival = survival;
			end;
			weights=CENSOR/_survival;
			if censor =. then delete;
			if ObservedEvents>1 then obsevt=ObservedEvents; else obsevt=1;
		run;

		data _Duplics1 ;
  			set _estm12;
			do ObservedEvents = 1 to obsevt;
  				output;
			end;
		run; 
		proc sort data=_Duplics1; by _y; run;
				
		ods output ProductLimitEstimates=_estm0 (where=(ObservedEvents ^=.));
			proc lifetest data=_armx0  atrisk ;    
				time _y*_d(0); * censoring are values where event is equal 0;
	 		run;
		ods output close;

		data _estm02;
	 		set _estm0 ;
			retain _survival;
			if missing(survival) then do;
			survival = _survival;
			end; else do;
			_survival = survival;
			end;
			weights=CENSOR/_survival;
			if censor =. then delete;
			if ObservedEvents>1 then obsevt=ObservedEvents; else obsevt=1;
		run;
		
		data _Duplics0 ;
  			set _estm02;
			do ObservedEvents = 1 to obsevt;
  				output;
			end;
		run; 

		proc sort data=_Duplics0 ;by _y; run;
		proc sort data=_armx0 ; by _y; run;
		proc sort data=_armx1 ; by _y; run;

		data arm1;
			merge _armx1 (in=a) _Duplics1;
			by _y;
			if a;
		run;

		data arm0;
			merge _armx0 (in=a) _Duplics0;
			by _y;
			if a;
		run;
		
		data _armx;
			set arm1 arm0;
			intercept=1;
		run;
		%if %upcase(&type.)=DIFFERENCE %then %do;
			ods output  parameterEstimates=_par;
				proc glm data = _armx ;
					model _y = &trt. &covariates.  / predicted solution ;
					weight weights;
					output out=_glm p=pred ;
				run; 
			ods output close;
		%end;
		%else %if %upcase(&type.)=RATIO %then %do; 
			ods output  parameterEstimates=_par;
				proc genmod data=_armx;
					model _y = &trt. &covariates.   /  predicted RESIDUALS  dist = poisson;
					weight weights;
					output out = _glm
					pred = Pred; 
				run;
			ods output close;
			data _par; set _par; if df=0 then delete; run;
		%end;
		%else %if %upcase(&type.)=LOSSRATIO %then %do; 
			ods output  parameterEstimates=_par;
				proc genmod data=_armx;
					model _y_lr = &trt. &covariates.   /  predicted RESIDUALS  dist = poisson;
					weight weights;
					output out = _glm
					pred = Pred; 
				run;
			ods output close;
			data _par; set _par; if df=0 then delete; run;
		%end;

			data _glm;
				set _glm;
				%if %upcase(&type.)=LOSSRATIO %then %do;
					resid=_y_lr-pred;
				%end;
				%else %do;
					resid=_y-pred;
				%end;
			run; 
			proc iml;
				use _glm;
					read all var {resid} into r;
					read all var {weights} into w;
					read all var {intercept &trt. &covariates.} into x;
				close _glm;
				use _par;
					read all var {estimate} into beta0;
				close _par;
				kappa=diag(r*t(w))*x;
				gamma=t(kappa)*kappa;
				%if %upcase(&type.)=DIFFERENCE %then %do;
					A=t(x)*x;
					varbeta=INV(A)*gamma*INV(A);
					se0=sqrt(diag(varbeta));
					z0=diag(beta0/se0);
					p0=diag(1-probchi(z0*z0, 1));
			  	 	cilow=diag(beta0-se0*1.96);
			   		cihigh=diag(beta0+se0*1.96);
					m= beta0 || se0[,+] || z0[,+] || p0[,+] || cilow[,+] || cihigh[,+];
					create _iml from m[colname={"coef" "se_coef" "z" "p" "lower_95" "upper_95"}];
				%end;
				%else %do;
					A=t(x#exp(x*beta0))*x;
					varbeta=INV(A)*gamma*INV(A);
					se0=sqrt(diag(varbeta));
					z0=diag(beta0/se0);
					p0=diag(1-probchi(z0*z0, 1));
					r0=exp(beta0);
			  	 	cilow=diag(exp(beta0-se0*1.96));
  					cihigh=diag(exp(beta0+se0*1.96));
					m= beta0 || se0[,+] || z0[,+] || p0[,+] || r0 || cilow[,+] || cihigh[,+];
					create _iml from m[colname={"coef" "se_coef" "z" "p" "exp_coef" "lower_95" "upper_95"}];
					print m;
				%end;

				append from m;
				close _iml; 
			quit;

			data &dt_out. (keep= parameter coef se_coef z p exp_coef lower_95 upper_95);
				merge _par _iml;
			run;

			proc delete data =arm1 arm0 _armx1 _armx0 _armx _duplics0 _duplics1 _estm0 _estm1 _estm02 _estm12 _glm _iml _par; run;
		%end;
		

%mend rmst2reg;

*#########################################
# rmst2 (2-arm) contrast (main function)
#########################################;

%macro RMST2 (dt_in=,       /* source data */
			  time=,       /* time to event */
			  status=,     /* censoring are values where event is equal 0 */
			  tau=,        /* truncation time */
			  trt=,        /* treatment variable */
			  covariates=, /* list of covariates to use for the adjustment.*/
			  alpha=,      /* gives (1-alpha) confidence interval */
			  path=,       /* specify the path where to store the survival plots */
              SP_arm=,     /* Survival plot name. RMST2 macro will output SP_arm1.rtf and SP_arm0.rtf */
			  dt_out=);     /* the output data file name */

	proc summary data=&dt_in.; 
		var &time.; 
		class &trt. &status.;
		output out=_e max=;
	run;
	proc sort data=_e (where=(&status.=1 and not missing(&trt.))); by &time.; run;
	data _null_;
		set _e;
		if _N_=1 then call symput("tau_default", &time.);
	run;

	proc summary data=&dt_in.; 
		var &time.; 
		class &trt. ;
		output out=_f max=;
	run;

	proc sort data=_f; by &time.; run;
	data _null_;
		set _f;
		if _N_=1 then call symput("tau_max", &time.);
	run;
	
	data _arm1 _arm0;
		set &dt_in.;
		if &trt.=1 then output _arm1;
		if &trt.=0 then output _arm0;
	run;
	%put &tau_default.;
	%put &tau_max.;
	
    %if %sysevalf(&tau. > &tau_max.) %then %do;
		%put ERROR:<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    The truncation time, tau, needs to be shorter than or equal to the
minimum of the largest observed time on each of the two groups &tau_max.
                   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>;
	%end;
	%else %do;
		%if %length(&tau.)=0 %then %do;
			%let tau=&tau_default.;
			%put NOTE:<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
					The truncation time, tau, was not specified. Thus, the default tau
(the minimum of the largest observed event time on each of the two groups) is used &tau_default.
					<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
		%end;
		%else %do;
			%if %sysevalf(&tau.>= &tau_default.) %then %do;
			%let tau=&tau.;
			%put NOTE:<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
					The truncation time: tau =&tau. was specified, but there are no observed 
events after tau=&tau. on either or both groups. Make sure that the size of risk set is large 
enough in each group
					<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
		 %end;
		 %else %do;	
			%let tau=&tau.;
			%put NOTE:<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
						The truncation time: tau =&tau. was specified
					  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
		 %end;
	  %end;
		%if %length(&covariates.)=0 %then %do;
			%RMST1(dtin=_arm1,time=&time., status=&status., tau=&tau., alpha=&alpha.,path=&path.,SP_arm=SP_arm1.rtf,dtout=&dt_out._arm1);
			%RMST1(dtin=_arm0,time=&time., status=&status., tau=&tau., alpha=&alpha.,path=&path.,SP_arm=SP_arm0.rtf,dtout=&dt_out._arm0);

			%let c=1-&alpha./2;
			data &dt_out.;
				merge &dt_out._arm1 &dt_out._arm0 (rename= (RMST_est=RMST_est0 RMST_var=RMST_var0 RMST_se=RMST_se0 RMST_low_ci=RMST_upp_ci0 RMST_upp_ci=RMST_low_ci0
														RMTL_est=RMTL_est0 RMTL_se=RMTL_se0 RMTL_low_ci=RMTL_upp_ci0 RMTL_upp_ci=RMTL_low_ci0));
			 	RMST_diff_est     = RMST_est-RMST_est0;
		 		RMST_diff_se  	  = sqrt(RMST_var + RMST_var0);
		 		RMST_diff_low_ci  = RMST_diff_est - RMST_diff_se*quantile('NORMAL',&c. , 0, 1);
		 		RMST_diff_upp_ci  = RMST_diff_est + RMST_diff_se*quantile('NORMAL',&c. , 0, 1);
				%let a=-abs(RMST_diff_est)/RMST_diff_se; 
		 		RMST_diff_pval    = cdf('NORMAL',&a. , 0, 1)*2;

				RMST_log_ratio_est  = (log(RMST_est) - log(RMST_est0));
				RMST_log_ratio_se  = sqrt(RMST_var/RMST_est/RMST_est + RMST_var0/RMST_est0/RMST_est0);
		 		RMST_log_ratio_low_ci = exp(RMST_log_ratio_est - RMST_log_ratio_se*quantile('NORMAL',&c. , 0, 1));
		 		RMST_log_ratio_upp_ci = exp(RMST_log_ratio_est + RMST_log_ratio_se*quantile('NORMAL',&c. , 0, 1));
		 		%let a=-abs(RMST_log_ratio_est)/RMST_log_ratio_se; 
		 		RMST_log_ratio_pval   = cdf('NORMAL',&a. , 0, 1)*2;
				RMST_log_ratio_est=exp(RMST_log_ratio_est);

				RMTL_log_ratio_est  = (log(RMTL_est) - log(RMTL_est0));
				RMTL_log_ratio_se  = sqrt(RMST_var/RMTL_est/RMTL_est + RMST_var0/RMTL_est0/RMTL_est0);
		 		RMTL_log_ratio_low_ci = exp(RMTL_log_ratio_est - RMTL_log_ratio_se*quantile('NORMAL',&c. , 0, 1));
		 		RMTL_log_ratio_upp_ci = exp(RMTL_log_ratio_est + RMTL_log_ratio_se*quantile('NORMAL',&c. , 0, 1));
		 		%let a=-abs(RMTL_log_ratio_est)/RMTL_log_ratio_se; 
		 		RMTL_log_ratio_pval   = cdf('NORMAL',&a. , 0, 1)*2;
				RMTL_log_ratio_est=exp(RMTL_log_ratio_est);

				keep RMST_diff_est RMST_diff_low_ci RMST_diff_upp_ci RMST_diff_pval RMST_log_ratio_est RMST_log_ratio_low_ci RMST_log_ratio_upp_ci 
					RMST_log_ratio_pval RMTL_log_ratio_est RMTL_log_ratio_low_ci RMTL_log_ratio_upp_ci RMTL_log_ratio_pval;
		 	run;
			proc print data=&dt_out. ; title 'Unadjusted Analysis Results: RMST Difference, RMST Ratio & RMTL Ratio for Between-group contrast';run;
			proc print data=&dt_out._arm1; title 'Unadjusted Analysis Results: RMST & RMTL for arm 1'; run;
			proc print data=&dt_out._arm0; title 'Unadjusted Analysis Results: RMST & RMTL for arm 0'; run;			
		%end;
		%else %do;
		 	%rmst2reg (dt_in=&dt_in.,time=&time., status=&status., covariates=&covariates. , trt=&trt., tau=&tau., type=difference, dt_out=&dt_out._diff);
		 	%rmst2reg (dt_in=&dt_in.,time=&time., status=&status., covariates=&covariates. , trt=&trt., tau=&tau., type=ratio, dt_out=&dt_out._ratio);
		 	%rmst2reg (dt_in=&dt_in.,time=&time., status=&status., covariates=&covariates. , trt=&trt., tau=&tau., type=lossratio, dt_out=&dt_out._lossratio);

			proc print data=&dt_out._diff; title 'Adjusted Results: Model summary (difference of RMST)';run;
			proc print data=&dt_out._ratio; title 'Adjusted Results: Model summary (ratio of RMST)'; run;
			proc print data=&dt_out._lossratio; title 'Adjusted Results: Model summary (ratio of time-lost)'; run;
		%end;
	%end;
	proc delete data = _e _f _arm0 _arm1 ; run; 
%mend;

* Example of RMST2 macro using pbc data from the survival package in R;
 libname temp "c:\RMST" ;

 data pbc2;
	set temp.pbc; 
	if id<=312;
	time=time/365;
	if status=2 then status=1; else status=0;
	if trt=2 then trt=1; else trt=0;
	keep time status trt age edema bili albumin protime;
 run;

%RMST2 (dt_in=pbc2,time=time, status=status, trt=trt, tau=9, alpha=0.05,path=c:\temp,dt_out=rmst2);

