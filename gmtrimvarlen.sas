/*----------------------------------------------------------------------------- 
Program Purpose:  Trim the length of all character variables in a dataset to the maximum length of the text string in each variable.
Macro Parameters:
Name: dataIn
Default Value: REQUIRED
Description: User input SAS dataset name to be processed.
 
Name:  excludeVars
Description: User input SAS variable names to be excluded from processing. 
Regular expressions can be used to specify rules for variables to be excluded. 

Name: splitChar
Default Value: @
Description: Split character used to separate exclusion variables. 

REVISION HISTORY SECTION: 
Ver#            Peer Reviewer        Code History Description
------------   ----------------     ------------------------------------------------------
                        
-----------------------------------------------------------------------------*/

%MACRO GmTrimVarLen(dataIn=, excludeVars=,splitChar=@);

%let tvl_excludeVars =;   

/*[CHECKS] If the input dataset does not exist or if the argument dataIn= is blank then ABORT the macro*/
%if %sysfunc(exist(&dataIn)) = 0 or %length(&dataIn) = 0 %then %do;
    data _null_;
       put "Warning: Dataset &dataIn does not exist.";
    run;
%end;

/*[CHECKS] If the dataset has 0 observations then issue a note that dataset is empty*/
%let tvl_dsnid = %sysfunc(open(&dataIn)); 
%let tvl_nobs=%sysfunc(attrn(&tvl_dsnid,nlobs));
  %if &tvl_nobs = 0 %then %do;
    data _null_;
       put "Warning: Dataset &dataIn is empty.";
    run; 
  %end;
%let tvl_rc  =%sysfunc(close(&tvl_dsnid));
            
%if %length(&excludeVars) > 0 %then %do;  
%let excludeVars = %qcmpres(&excludeVars);

/*[CHECKS] If the user has entered a blank value between the two delimiter example: @@ or @ @ 
                 or if the user has entered a blank value followed by a valid request at the beginning of the string example: @xxx 
                 the macro will remove the blank and will convert it to a single delimiter. A note is issued to the log*/  
  %if %qsysfunc(prxmatch(/@\s*@/, &excludeVars)) %then %do;
    %let tvl_excludeVars = %qsysfunc(prxchange(s/@\s*@/@/, -1, %bquote(&excludeVars)));  
         data _null_;
            put "A blank value was requested as a variable for exclusion.";
		 run;                   
  %end;
  %else %do;
    %let tvl_excludeVars = &excludeVars;
  %end;

  %if %qsysfunc(prxmatch(/^@/, &tvl_excludeVars)) %then %do;
    %let tvl_excludeVars = %qsysfunc(prxchange(s/^@//, -1, %bquote(&tvl_excludeVars)));  
         data _null_;
            put "A blank value was requested as a variable for exclusion at the beginning of the string.";
		 run;   
  %end; 

/*[CHECKS] If the user has entered regex anchors (^ and $) between the two delimiter example: ^xxx@^xxx$@ 
                 the macro will remove the redundant anchors. A note is issued to the log*/  
  %if %qsysfunc(prxmatch(/(^|@)\^|\$(@|$)/, &tvl_excludeVars)) %then %do;
    %let tvl_excludeVars = %qsysfunc(prxchange(s/(^\^|(?<=@)\^)|\$(?=(@|$))//, -1, %bquote(&tvl_excludeVars))); 
         data _null_;
            put "A regex anchor (^ or $) was requested in the variable for exclusion.";
         run;
  %end;

/*2. Process the excludeVars argument values*/  
  %local tvl_exxn;
  %do tvl_zz = 1 %to %eval(%sysfunc(countc(%bquote(&tvl_excludeVars), %bquote(&splitChar))) +1); 
    %local tvl_wexx&tvl_zz; 
  %end; 

  %let tvl_instring=%nrbquote(&tvl_excludeVars);
  %let tvl_delim=%bquote(&splitChar);
  %let tvl_prefixx=tvl_exx;
  %let tvl_countx=1;
  %if %length(&tvl_delim) > 0 %then %let tvl_spac=%str(&tvl_delim);
  %else %let tvl_spac=%str( );;
  %let tvl_wordx=%scan(%superq(tvl_instring), &tvl_countx, &tvl_spac);
  %let &tvl_prefixx.&tvl_countx = &tvl_wordx;
  %do %while (%superq(tvl_wordx) ne);
    %let tvl_countx=%eval(&tvl_countx+1);
    %let tvl_wordx=%scan(%superq(tvl_instring), &tvl_countx, &tvl_spac);
    %let &tvl_prefixx.&tvl_countx = &tvl_wordx;
  %end;
  %let &tvl_prefixx.n=%eval(&tvl_countx-1); 
  %do tvl_i = 1 %to &&&tvl_prefixx.n;
    %let tvl_w&tvl_prefixx.&tvl_i = %qtrim(%bquote(&&&tvl_prefixx.&tvl_i));
  %end;
%end;

/*3. Initiate the processing of the variables*/
proc sql undo_policy=NONE noprint;  
%let tvl_lengthstr=;
%let tvl_maxstr=;
%let tvl_keepstr=;
%let tvl_macstr=;
%let tvl_counter=0;
%if %length(&tvl_excludeVars) > 0 %then %do;
  %let tvl_exclstr=;  
  %do tvl_yy = 1 %to &tvl_exxn;  
    %let tvl_matchstr&tvl_yy=;
  %end;
%end;

%let tvl_dsid=%sysfunc(open(&dataIn,i));  
%let tvl_nvar=%sysfunc(attrn(&tvl_dsid,nvars));
%do tvl_xx=1 %to &tvl_nvar;
  %let tvl_varnm&tvl_xx = %sysfunc(varname(&tvl_dsid, &tvl_xx));
  %let tvl_vartyp&tvl_xx = %sysfunc(vartype(&tvl_dsid,&tvl_xx));
  %let tvl_totvarlen&tvl_xx = %sysfunc(varlen(&tvl_dsid,&tvl_xx));	

/*3.1 Process only the Character Type Variables*/
  %if (&&tvl_vartyp&tvl_xx = C) %then %do;
/*[CHECKS] If the variable in the dataset match with the variable in the requested excludeVars argument then save 
                 the variable to the list and exit the processing*/  	
  	%if %length(&tvl_excludeVars) > 0 %then %do;
  		%do tvl_yy = 1 %to &tvl_exxn;      
  			%if %qsysfunc(prxmatch(/^&&tvl_wtvl_exx&tvl_yy..$/i, %upcase(&&tvl_varnm&tvl_xx))) %then %do;
  				%let tvl_matchstr&tvl_yy= &&tvl_matchstr&tvl_yy  &&tvl_varnm&tvl_xx;
  				%let tvl_exclstr = &tvl_exclstr &&tvl_varnm&tvl_xx;
  				%goto exitloop;
  			%end;
  		%end;
  	%end;
    
    %let tvl_counter = %eval(&tvl_counter + 1);   
    %let tvl_varlen&tvl_counter = &&tvl_totvarlen&tvl_xx;          
    %let tvl_maxstr&tvl_xx = max(length(&&tvl_varnm&tvl_xx));   	
    %if &tvl_counter = 1 %then %let tvl_delimiter = ; 
    %else %let tvl_delimiter = %str(,);;  
/*3.2 Construct the string of variables that need to be processed, the string for calculation of maximum length of variables, and 
         the variables that need to be in the keep statement for PROC SQL processing*/            
    %let tvl_maxstr = &tvl_maxstr.&tvl_delimiter &&tvl_maxstr&tvl_xx;  
    %let tvl_macstr&tvl_xx = :tvl_maxl&tvl_counter;
    %let tvl_macstr = &tvl_macstr.&tvl_delimiter &&tvl_macstr&tvl_xx;        
    %let tvl_keepstr = &tvl_keepstr &&tvl_varnm&tvl_xx;  
  %end;  
%exitloop:        
%end;
%let tvl_rc=%sysfunc(close(&tvl_dsid));

%if %length(&tvl_excludeVars) > 0 %then %do;
/*3.3 If there are no variables that matched with the requested exclusion variable or regex pattern then 
        take action as per the value passed by user in the selectType argument*/
  %do tvl_yy = 1 %to &tvl_exxn;  
    %if %length(&&tvl_matchstr&tvl_yy) = 0 %then %do;
        data _null_;
           put "No variables matched with the requested exclusion variable or regex pattern &&tvl_wtvl_exx&tvl_yy@or it is a duplicate of another exclusion rule.";
        run; 
    %end; 
  %end;           

/*3.4 Output a note to the log for list of variables that were excluded*/
  %if %length(&tvl_exclstr) > 0 %then %do;
      data _null_;
         put "The following variables were excluded from processing@&tvl_exclstr..";
	  run;    
  %end;
%end;

%if %length(&tvl_maxstr) > 0 and %length(&tvl_macstr) > 0 and %length(&tvl_keepstr) > 0 %then %do;
/*[CHECKS] if the tvl_maxstr exceeds the allowed limit of 65530 characters then ABORT*/	
	%if %length(superq(tvl_maxstr)) > 65530 or %length(superq(tvl_macstr)) > 65530 or %length(superq(tvl_keepstr)) > 65530 %then %do;
		data _null_;
           put "The number of variables requested has exceeded the maximum number of variables that can be processed.@The macro &tvl_currmac will stop executing."; 
		run;
    %end;
		                
/*3.5 Calculate the maximum length of the text string in each variable and store in macro variables*/	
	select &tvl_maxstr into &tvl_macstr
	from &dataIn (keep=&tvl_keepstr);
	
	%let tvl_wtext=The following variables were processed;
	%let tvl_text=;	
	%let tvl_counter=0;
	%do tvl_xx=1 %to &tvl_nvar;
		%if %symexist(tvl_maxstr&tvl_xx) > 0 %then %do;  	
			%let tvl_counter = %eval(&tvl_counter + 1);	
/*[CHECKS] If the dataset is empty then assign a maximum length of 1 to the variables*/  			  	
			%if &tvl_nobs = 0 %then %let tvl_maxl&tvl_counter = 1; 
          %else %let tvl_maxl&tvl_counter = &&tvl_maxl&tvl_counter;;
/*3.6 Construct a string with variables to be processed in PROC SQL modify statement*/			
			%if &tvl_counter = 1 %then %let tvl_delimiter=; 
			%else %let tvl_delimiter = %str(,);;	  	
			%let tvl_lengthstr = &tvl_lengthstr.&tvl_delimiter &&tvl_varnm&tvl_xx char(&&tvl_maxl&tvl_counter);	

/*3.7 Construct a string with results from processing to be output to the log as a note 
        if there was no change in the length then the result is displayed as Unchanged
        if there was a change the result displayed as [previous length->trimmed length]*/			
			%if &&tvl_varlen&tvl_counter = &&tvl_maxl&tvl_counter %then %do;
				%let tvl_text&tvl_counter = &&tvl_varnm&tvl_xx[Unchanged];
			%end;
			%else %do;
				%let tvl_text&tvl_counter = &&tvl_varnm&tvl_xx[&&tvl_varlen&tvl_counter->&&tvl_maxl&tvl_counter];
			%end;	
			%let tvl_text = &tvl_text &&tvl_text&tvl_counter; 
									
			%if %length(NOTE:XX/ &tvl_text) > %eval(%sysfunc(getoption(linesize)) - 25) %then %do;  
				%let tvl_wtext=&tvl_wtext@&tvl_text; 	
				%let tvl_text=;
			%end;	
		%end;
	%end;
	                    	
/*3.8 Perform the variable processing of trimming their length using PROC SQL MODIFY statement*/			
    alter table &dataIn 
    modify &tvl_lengthstr;
%end;
/*3.9 If no variables in the dataset were trimmed then output a note to the log*/	
%else %do; 
    data _null_;
       put "No variables in the dataset &dataIn were trimmed.";
    run;
%end; 
quit;
          
%MEND GmTrimVarLen;
