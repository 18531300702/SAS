************************************************************************************************

          ICON Study Number: xxxx/xxxx
    Sponsor Protocol Number: xxxxxxxx

               Program Name: lbtoxgr_v4.03
           Program Location: /* program location */
                Description: Applies Toxicity Grading to Laboratory Results per CTCAE4.03

             Program Author:
              Creation Date:

              Datasets Used: WORK.LB
    Name/Location of Output: WORK.LB

    Derived Dataset Library: N/A
Source(raw) Dataset Library: WORK.LB
             Format Library: N/A
   External Macros Location: N/A

      Modification Notes (include name of person modifying the program, date of modification
                          And description/reason for the change):

	  27Aug13 - Toxicity grades applied to the following tests:
	  Amylase, Cholesterol, Creatine Kinase, Glomerular Filtration Rate, Triacylglycerol Lipase,
	  Prothrombin Time and Triglycerides

	  28Aug13 - Standard unit 10**3/MM**3 added for tests:
	  Lymphocytes, Neutrophils, Platelet and Leukocytes.

	  04Nov13 - Added Rounding factor for lab range values per CDARS standards when deriving toxicity grading:
	  Prothrombin Time, Bilirubin, Aspartate Aminotransferase, Creatine Kinase, Alanine Aminotransferase,
	  Gamma Glutamyl Transferase, Alkaline Phosphatase, Creatinine, Activated Partial Thromboplastin Time,
	  Fibrinogen, Amylase, Prothrombin Intl. Normalized Ratio and Lipase.

	  29Oct14 - Added filter for Urinalysis lab tests to assign toxicity only for Urine Protein.

	  24Dec14 - Programming logic updated for Neutrophils and Lymphocytes to assign using normal local lab range
	  when Pfizer standard range are missing due to conversion issue for % original unit converted to absolute missing standard range values.

      10Feb15 - Update for Calcium to used Corrected Calcium only if Serum albumin is <4.0 g/dL, else applied for collected Serum Calcium.

	  10Feb15 - Update for all lab tests to grade a lab result by prioritizing the CTCAE grade values over the local lab normal range values.

	  25Feb15 - Toxicity grade applied to Urine Protein/Creatinine Lab test.

      Checklist before each transfer
		-

***********************************************************************************************;

/* Input code after work dataset LB is created with variables
	LBCAT/LBSCAT/LBTESTCD/LBSTRESN/LBSTRESU/LBSTNRLO/LBSTNRHI/LBNRIND/LBBLFL populated
		and Unscheduled VISITNUM assigned */
%macro lbtoxgr_ng(indat =, outdat = );


proc sort data=&indat out=lb_toxgr;
 	by usubjid lbcat lbtestcd;
run;

/* Get Creatinine Baseline */
proc sort data=&indat(keep=usubjid lbcat lbblfl lbtestcd lbstresn)
  			out=lb_creat(rename=(lbstresn=lbstresn_creatbl lbblfl=lbblfl_creat));
 	by usubjid lbcat lbtestcd;
 	where lbtestcd eq 'CREAT' and lbblfl eq 'Y' and lbstresn ne .;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_creat;
	by usubjid lbcat lbtestcd;
	if a;
run;

/* Get Fibrinogen Baseline */
proc sort data=&indat(keep=usubjid lbcat lbblfl lbtestcd lbstresn)
			out=lb_fibro(rename=(lbstresn=lbstresn_fibrobl lbblfl=lbblfl_fibro));
 	by usubjid lbcat lbtestcd;
 	where lbtestcd eq 'FIBRINO' and lbblfl eq 'Y' and lbstresn ne .;
run;
data lb_toxgr;
	merge lb_toxgr(in=a) lb_fibro;
	by usubjid lbcat lbtestcd;
	if a;
run;

/* Get Hemoglobin Baseline */
proc sort data=&indat(keep=usubjid lbcat lbblfl lbtestcd lbstresn)
  		  	out=lb_hgb(rename=(lbstresn=lbstresn_hgbbl lbblfl=lbblfl_hgb));
 	by usubjid lbcat lbtestcd;
 	where lbtestcd eq 'HGB' and lbblfl eq 'Y' and lbstresn ne .;
run;
data lb_toxgr;
	merge lb_toxgr(in=a) lb_hgb;
	by usubjid lbcat lbtestcd;
	if a;
run;

proc sort data=lb_toxgr;
 	by usubjid visitnum lbdtc;
run;

/*------------------------ Get Albumin Value for unit G/DL -----------------------------------------*/
proc sort data=&indat(keep=usubjid visitnum lbdtc lbtestcd lbstresn lbstresu lbnrind)
  			out=lb_albumin1(rename=(lbstresn=lbstresn_albumin1 lbtestcd=lbtestcd_alb1 lbnrind=lbnrind_alb1
									lbstresu=lbstresu_alb1)) nodupkey;
 	by usubjid visitnum lbdtc;
 	where lbtestcd eq 'ALB' and upcase(lbstresu) eq 'G/DL' /*and lbstresn < 4*/  and lbstresn ne .;
run;
/* Get Albumin Value for G/L */
proc sort data=&indat(keep=usubjid visitnum lbdtc lbtestcd lbstresn lbstresu lbnrind)
  			out=lb_albumin2(rename=(lbstresn=lbstresn_albumin2 lbtestcd=lbtestcd_alb2 lbnrind=lbnrind_alb2
									lbstresu=lbstresu_alb2)) nodupkey;
 	by usubjid visitnum lbdtc;
 	where lbtestcd eq 'ALB' and upcase(lbstresu) eq 'G/L' /*and lbstresn < 40*/  and lbstresn ne .;
run;
data lb_toxgr;
	merge lb_toxgr(in=a) lb_albumin1 lb_albumin2;
	by usubjid visitnum lbdtc;
	if a;
run;

/* Corrected Calcium Value */
data lb_toxgr;
 	set lb_toxgr;
 	if lbtestcd eq 'CA' then do;
	lbstresn_corrcal2 = .; lbstresn_corrcal1 = .;
 		if cmiss(lbstresn, lbstresn_albumin1) = 0 and upcase(LBSTRESU_ALB1) = "G/DL" /*and LBSTRESN_albumin1 < 4*/ and upcase(LBSTRESU) = "MG/DL" then
			lbstresn_corrcal1 = lbstresn - (0.8*(lbstresn_albumin1 - 4));
		if cmiss(lbstresn, lbstresn_albumin1) = 0 and upcase(LBSTRESU_ALB1) = "G/DL" /*and LBSTRESN_albumin1 < 4*/ and upcase(LBSTRESU) = "MMOL/L" then
			lbstresn_corrcal2 = lbstresn - (0.2*(lbstresn_albumin1 - 4));
		if cmiss(lbstresn, lbstresn_albumin2) = 0 and upcase(LBSTRESU_ALB2) = "G/L" /*and LBSTRESN_albumin2 < 40*/ and upcase(LBSTRESU) = "MG/DL" then
			lbstresn_corrcal1 = lbstresn - (0.08*(lbstresn_albumin2 - 40));
		if cmiss(lbstresn, lbstresn_albumin2) = 0 and upcase(LBSTRESU_ALB2) = "G/L" /*and LBSTRESN_albumin2 < 40*/ and upcase(LBSTRESU) = "MMOL/L" then
			lbstresn_corrcal2 = lbstresn - (0.02 *(lbstresn_albumin2 - 40));
 	end;
run;

/* Get WBC values */
proc sort data=&indat(keep=usubjid visitnum lbdtc lbstresn lbcat lbtestcd)
			out=lb_wbc(rename=(lbstresn=lbstresn_wbc lbtestcd=lbtestcd_wbc lbcat=lbcat_wbc));
	by usubjid visitnum lbdtc;
	where lbcat eq '血生化' and lbtestcd eq 'WBC' and lbstresn ne .;/*24Dec14-SS*//*27Feb15-SS*/
run;
proc sort data=lb_wbc nodupkey;
	by usubjid visitnum lbdtc;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_wbc;
	by usubjid visitnum lbdtc;
	if a;
run;

/* Get GLUC: 高血糖 */
proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat LBDTC)
			out=lb_GLUCab(rename=(lbstresn=lbstresn_GLUCBA LBSTNRLO = LBSTNRLO_GLUC1 LBSTNRHI = LBSTNRHI_GLUC1 LBBLFL = LBBLFLGLUC1 LBDTC = lbdtc_GLUCB  )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'GLUC' and lbstresn ne . and LBBLFL = "Y" /*and (LBSTNRLO > lbstresn or lbstresn >LBSTNRHI)*/;
run;


proc sort data=lb_toxgr ;
	by usubjid lbcat lbtestcd;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_GLUCab;
	by usubjid lbcat lbtestcd;
	if a;
run;

/* Get AST baseline flag/Normal/abnomal */
proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat ) 
			out=lb_astn(rename=(lbstresn=lbstresn_ast  LBSTNRLO = LBSTNRLO_ast LBSTNRHI = LBSTNRHI_ast LBBLFL = LBBLFLast )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'AST' and lbstresn ne . and LBBLFL = "Y" and /*LBSTNRLO<=*/lbstresn<=LBSTNRHI;
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat )
			out=lb_astab(rename=(lbstresn=lbstresn_astBA LBSTNRLO = LBSTNRLO_ast1 LBSTNRHI = LBSTNRHI_ast1 LBBLFL = LBBLFLast1 )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'AST' and lbstresn ne . and LBBLFL = "Y" and (/*LBSTNRLO > lbstresn or*/ lbstresn >LBSTNRHI);
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbdtc LBBLFL)
			out=lb_astabdtc(rename=( lbdtc = lbdtc_ASTB LBBLFL = LBBLFL_ast)) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'AST' and LBBLFL = "Y";
run;


proc sort data=lb_toxgr ;
	by usubjid lbcat lbtestcd;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_astn (in = b) lb_astab (in = c) lb_astabdtc;
	by usubjid lbcat lbtestcd;
	if a;
	if b THEN AST_ABF = "Y";
	if C THEN AST_ABnF = "Y";
run;


/* Get alt baseline flag/Normal/abnomal */
proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat ) 
			out=lb_altn(rename=(lbstresn=lbstresn_alt  LBSTNRLO = LBSTNRLO_alt LBSTNRHI = LBSTNRHI_alt LBBLFL = LBBLFL_alt )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALT' and lbstresn ne . and LBBLFL = "Y" and /*LBSTNRLO<=*/lbstresn<=LBSTNRHI;
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat )
			out=lb_altab(rename=(lbstresn=lbstresn_altBA LBSTNRLO = LBSTNRLO_alt1 LBSTNRHI = LBSTNRHI_alt1 LBBLFL = LBBLFL_alt1 )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALT' and lbstresn ne . and LBBLFL = "Y" and (/*LBSTNRLO > lbstresn or*/ lbstresn >LBSTNRHI);
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbdtc LBBLFL)
			out=lb_altabdtc(rename=( lbdtc = lbdtc_altB LBBLFL = LBBLFL_alt3)) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALT' and LBBLFL = "Y";
run;


proc sort data=lb_toxgr ;
	by usubjid lbcat lbtestcd;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_ALTn (in = b) lb_ALTab (in = c) lb_ALTabdtc;
	by usubjid lbcat lbtestcd;
	if a;
	if b THEN ALT_ABF = "Y";
	if C THEN ALT_ABnF = "Y";
run;

/* Get ALP baseline flag/Normal/abnomal */
proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat ) 
			out=lb_ALPn(rename=(lbstresn=lbstresn_ALP  LBSTNRLO = LBSTNRLO_ALP LBSTNRHI = LBSTNRHI_ALP LBBLFL = LBBLFL_ALP )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALP' and lbstresn ne . and LBBLFL = "Y" and /*LBSTNRLO<=*/lbstresn<=LBSTNRHI;
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat )
			out=lb_ALPab(rename=(lbstresn=lbstresn_ALPBA LBSTNRLO = LBSTNRLO_ALP1 LBSTNRHI = LBSTNRHI_ALP1 LBBLFL = LBBLFL_ALP1 )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALP' and lbstresn ne . and LBBLFL = "Y" and (/*LBSTNRLO > lbstresn or*/ lbstresn >LBSTNRHI);
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbdtc LBBLFL)
			out=lb_ALPabdtc(rename=( lbdtc = lbdtc_ALPB LBBLFL = LBBLFL_ALP2)) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'ALP' and LBBLFL = "Y";
run;


proc sort data=lb_toxgr ;
	by usubjid lbcat lbtestcd;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_ALPn (in = b) lb_ALPab (in = c) lb_ALPabdtc;
	by usubjid lbcat lbtestcd;
	if a;
	if b THEN ALP_ABF = "Y";
	if C THEN ALP_ABnF = "Y";
run;

/* Get TBIL 血胆红素增高 */
proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat ) 
			out=lb_TBILn(rename=(lbstresn=lbstresn_TBIL  LBSTNRLO = LBSTNRLO_TBIL LBSTNRHI = LBSTNRHI_TBIL LBBLFL = LBBLFLTBIL )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'TBIL' and lbstresn ne . and LBBLFL = "Y" and /*LBSTNRLO<=*/lbstresn<=LBSTNRHI;
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbstresn LBBLFL LBSTNRLO LBSTNRHI lbcat )
			out=lb_TBILab(rename=(lbstresn=lbstresn_TBILBA LBSTNRLO = LBSTNRLO_TBIL1 LBSTNRHI = LBSTNRHI_TBIL1 LBBLFL = LBBLFLTBIL1 )) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'TBIL' and lbstresn ne . and LBBLFL = "Y" and (/*LBSTNRLO > lbstresn or*/ lbstresn >LBSTNRHI);
run;

proc sort data=&indat(keep=usubjid lbcat lbtestcd lbdtc LBBLFL)
			out=lb_TBILabdtc(rename=( lbdtc = lbdtc_TBILB LBBLFL = LBBLFL_TBIL)) nodupkey;
	by usubjid lbcat lbtestcd;
	where lbcat eq '血生化' and lbtestcd eq 'TBIL' and LBBLFL = "Y";
run;


proc sort data=lb_toxgr ;
	by usubjid lbcat lbtestcd;
run;

data lb_toxgr;
	merge lb_toxgr(in=a) lb_TBILn (in = b) lb_TBILab (in = c) lb_TBILabdtc;
	by usubjid lbcat lbtestcd;
	if a;
	if b THEN TBIL_ABF = "Y";
	if C THEN TBIL_ABnF = "Y";
run;
/**-- End --**/

data &outdat;
	set lb_toxgr;
	length lbtox $40. lbtoxgr $1.;
	*---------------------ALB  in G/dL*-------------------------*;
	if LBTESTCD = "ALB" and upcase(LBSTRESU) = "G/DL" and LBSTRESN > . then do;
		if 3 <= LBSTRESN < LBSTNRLO then LBTOXGR = "1";
		if (2 <= LBSTRESN < 3) then LBTOXGR = "2";
		if (LBSTRESN < 2) then LBTOXGR = "3";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "低白蛋白血症";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Hypoalbuminemia";
		end;*/
	end;

	*---------------------ALB in G/L----------------------------*;
	if LBTESTCD = "ALB" and upcase(LBSTRESU) = "G/L" and LBSTRESN > . then do; 
		if 30 <= LBSTRESN < LBSTNRLO then LBTOXGR = "1";
		if (20 <= LBSTRESN < 30) then LBTOXGR = "2";
		if (LBSTRESN < 20) then LBTOXGR = "3";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "低白蛋白血症";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "低白蛋白血症";
		end;*/
	end;

	*----------------------ALP*----------------------------------------*;


	if LBTESTCD = "ALP" and upcase(LBSTRESU) in ("U/L", "IU/L")  then do;
      if ALP_ABF = "Y" then do;
	     if LBSTRESN > . and LBSTNRHI > . then do;
		    if  . < LBSTNRHI < LBSTRESN <= round(2.5*LBSTNRHI, 0.0001) then LBTOXGR = "1";
		    if  round(2.5*LBSTNRHI, 0.0001) < LBSTRESN <= round(5*LBSTNRHI, 0.0001) then LBTOXGR = "2";                 
		    if  round(5*LBSTNRHI, 0.0001) < LBSTRESN <= round(20*LBSTNRHI, 0.0001) then LBTOXGR = "3";
		    if  round(20*LBSTNRHI, 0.0001) < LBSTRESN then LBTOXGR = "4";
         end;
	  end;
      else if ALP_ABnF = "Y" then do;
            if LBSTRESN > . and lbstresn_ALPBA > . then do;
               if . < 2*lbstresn_ALPBA < LBSTRESN <= round(2.5*lbstresn_ALPBA, 0.0001) then LBTOXGR = "1";
			   if  round(2.5*lbstresn_ALPBA, 0.0001) < LBSTRESN <= round(5*lbstresn_ALPBA, 0.0001) then LBTOXGR = "2";                 
		       if  round(5*lbstresn_ALPBA, 0.0001) < LBSTRESN <= round(20*lbstresn_ALPBA, 0.0001) then LBTOXGR = "3";
		       if  round(20*lbstresn_ALPBA, 0.0001) < LBSTRESN then LBTOXGR = "4";
	        end;
	  end;
	  if cmiss (lbdtc_ALPB,lbdtc) eq 0 and lbdtc_ALPB >= lbdtc then do;
	      if   LBSTRESN > round(LBSTNRHI, 0.0001) > . then LBTOXGR = "1";
	  end;
	  if visitnum = 1 and not missing (lbdtc) and missing (lbdtc_ALPB) and (/*. < LBSTRESN < round(LBSTNRLO, 0.0001) or*/  LBSTRESN > round(LBSTNRHI, 0.0001)> .) then LBTOXGR = "1"; 
	  if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "碱性磷酸酶增高";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "天冬氨酸氨基转移酶增高";
		end;*/
	end;

	*-----------------------ALT---------------------------------------*;

	if LBTESTCD = "ALT" and upcase(LBSTRESU) in ("U/L", "IU/L") & LBSTRESN > .  then do;
      if ALT_ABF = "Y" then do;
	     if LBSTRESN > . and LBSTNRHI > . then do;
		    if  . < LBSTNRHI < LBSTRESN <= round(3*LBSTNRHI, 0.0001) then LBTOXGR = "1";
		    if  round(3*LBSTNRHI, 0.0001) < LBSTRESN <= round(5*LBSTNRHI, 0.0001) then LBTOXGR = "2";                 
		    if  round(5*LBSTNRHI, 0.0001) < LBSTRESN <= round(20*LBSTNRHI, 0.0001) then LBTOXGR = "3";
		    if  round(20*LBSTNRHI, 0.0001) < LBSTRESN then LBTOXGR = "4";
         end;
	  end;
      else if ALT_ABnF = "Y" then do;
            if LBSTRESN > LBSTNRHI > . and lbstresn_ALTBA > . then do;
               if . < 1.5*lbstresn_ALTBA < LBSTRESN <= round(3*lbstresn_ALTBA, 0.0001) then LBTOXGR = "1";
			   if  round(3*lbstresn_ALTBA, 0.0001) < LBSTRESN <= round(5*lbstresn_ALTBA, 0.0001) then LBTOXGR = "2";                 
		       if  round(5*lbstresn_ALTBA, 0.0001) < LBSTRESN <= round(20*lbstresn_ALTBA, 0.0001) then LBTOXGR = "3";
		       if  round(20*lbstresn_ALTBA, 0.0001) < LBSTRESN then LBTOXGR = "4";
	        end;
	  end;
	  if cmiss (lbdtc_ALTB,lbdtc) eq 0 and lbdtc_ALTB >= lbdtc then do;
	      if   LBSTRESN > round(LBSTNRHI, 0.0001) > . then LBTOXGR = "1";
	  end;
	  if visitnum = 1 and not missing (lbdtc) and missing (lbdtc_ALTB) and (/*. < LBSTRESN < round(LBSTNRLO, 0.0001) or*/  LBSTRESN > round(LBSTNRHI, 0.0001)> .) then LBTOXGR = "1"; 
	  if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "丙氨酸氨基转移酶增高";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "天冬氨酸氨基转移酶增高";
		end;*/
	end;

	*-----------------------TBIL 总胆红素---------------------------------------*;

	if LBTESTCD = "TBIL" and upcase(LBSTRESU) in ("UMOL/L") & LBSTRESN > . then do;
      if TBIL_ABF = "Y" then do;
	     if LBSTRESN > LBSTNRHI > . then do;
		    if  . < LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI, 0.0001) then LBTOXGR = "1";
		    if  round(1.5*LBSTNRHI, 0.0001) < LBSTRESN <= round(3*LBSTNRHI, 0.0001) then LBTOXGR = "2";                 
		    if  round(3*LBSTNRHI, 0.0001) < LBSTRESN <= round(10*LBSTNRHI, 0.0001) then LBTOXGR = "3";
		    if  round(10*LBSTNRHI, 0.0001) < LBSTRESN then LBTOXGR = "4";
         end;
	  end;
      else if TBIL_ABnF = "Y" then do;
            if LBSTRESN > LBSTNRHI > . and lbstresn_TBILBA > . then do;
               if . < 1*lbstresn_TBILBA < LBSTRESN <= round(1.5*lbstresn_TBILBA, 0.0001) then LBTOXGR = "1";
			   if  round(1.5*lbstresn_TBILBA, 0.0001) < LBSTRESN <= round(3*lbstresn_TBILBA, 0.0001) then LBTOXGR = "2";                 
		       if  round(3*lbstresn_TBILBA, 0.0001) < LBSTRESN <= round(10*lbstresn_TBILBA, 0.0001) then LBTOXGR = "3";
		       if  round(10*lbstresn_TBILBA, 0.0001) < LBSTRESN then LBTOXGR = "4";
	        end;
	  end;
	  if cmiss (lbdtc_TBILB,lbdtc) eq 0 and lbdtc_TBILB >= lbdtc>'' then do;
	        if LBSTRESN > round( 10*LBSTNRHI, 0.0001) > . then LBTOXGR = "4" ;
       else if LBSTRESN > round(  3*LBSTNRHI, 0.0001) > . then LBTOXGR = "3" ;
       else if LBSTRESN > round(1.5*LBSTNRHI, 0.0001) > . then LBTOXGR = "2" ;
       else if LBSTRESN > round(    LBSTNRHI, 0.0001) > . then LBTOXGR = "1" ;

	  end;
	  if visitnum = 1 and not missing (lbdtc) and missing (lbdtc_TBILB) and (/*. < LBSTRESN < round(LBSTNRLO, 0.0001) or*/  LBSTRESN > round(LBSTNRHI, 0.0001)> .) then LBTOXGR = "1"; 
	  if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "血胆红素增高";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "天冬氨酸氨基转移酶增高";
		end;*/
	end;


	*---------------------AMYLASE---------------------------------*;
	if LBTESTCD = "AMYLASE" and upcase(LBSTRESU) in ("U/L", "IU/L") and LBSTRESN > . and LBSTNRHI > . then do;
		if (. < LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI, 0.0001)) then LBTOXGR = "1";
		if (round(1.5*LBSTNRHI, 0.0001) < LBSTRESN <= round(2*LBSTNRHI, 0.0001)) then LBTOXGR = "2";
		if (round(2*LBSTNRHI, 0.0001) < LBSTRESN <= round(5*LBSTNRHI, 0.0001)) then LBTOXGR = "3";
		if (round(5*LBSTNRHI, 0.0001) < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Serum amylase increased";
		if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Serum amylase increased";
		end;
	end;

	*----------------APTT---------------------------------------;
	if LBTESTCD = "APTT" and upcase(LBSTRESU) in ("SEC", "S") and LBSTRESN > . and LBSTNRHI > . then do;
		if (. < LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI, 0.0001)) then LBTOXGR = "1";
		if (round(1.5*LBSTNRHI, 0.0001) < LBSTRESN <= round(2.5*LBSTNRHI, 0.0001)) then LBTOXGR = "2";
		if (round(2.5*LBSTNRHI, 0.0001) < LBSTRESN) then LBTOXGR = "3";

		
		*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			*LBTOXGR = "0"; 
			*LBTOX = "活化部分凝血活蛋白时间延长";
            *LBTOX = "Activated partial thromboplastin time prolonged";
		*end;
	end;
	if NOT MISSING (LBTOXGR) and LBTESTCD = "APTT" then LBTOX = "活化部分凝血活酶时间延长";		
/*
    if b THEN AST_ABF = "Y";
	if C THEN AST_ABnF = "Y";lbstresn_astBA lbdtc_ASTB lbdtc_ASTB1
*/
	*--------------AST---------------------------------------------;
	if LBTESTCD = "AST" and upcase(LBSTRESU) in ("U/L", "IU/L") & LBSTRESN > . then do;
      if AST_ABF = "Y" then do;
	     if LBSTRESN > . and LBSTNRHI > . then do;
		    if  . < LBSTNRHI < LBSTRESN <= round(3*LBSTNRHI, 0.0001) then LBTOXGR = "1";
		    if  round(3*LBSTNRHI, 0.0001) < LBSTRESN <= round(5*LBSTNRHI, 0.0001) then LBTOXGR = "2";                 
		    if  round(5*LBSTNRHI, 0.0001) < LBSTRESN <= round(20*LBSTNRHI, 0.0001) then LBTOXGR = "3";
		    if  round(20*LBSTNRHI, 0.0001) < LBSTRESN then LBTOXGR = "4";
         end;
	  end;
      else if AST_ABnF = "Y" then do;
            if LBSTRESN > LBSTNRHI > . and lbstresn_astBA > . then do;
               if . < 1.5*lbstresn_astBA < LBSTRESN <= round(3*lbstresn_astBA, 0.0001) then LBTOXGR = "1";
			   if  round(3*lbstresn_astBA, 0.0001) < LBSTRESN <= round(5*lbstresn_astBA, 0.0001) then LBTOXGR = "2";                 
		       if  round(5*lbstresn_astBA, 0.0001) < LBSTRESN <= round(20*lbstresn_astBA, 0.0001) then LBTOXGR = "3";
		       if  round(20*lbstresn_astBA, 0.0001) < LBSTRESN then LBTOXGR = "4";
	        end;
	  end;
	  if cmiss (lbdtc_ASTB,lbdtc) eq 0 and lbdtc_ASTB >= lbdtc then do;
	      if   LBSTRESN > round(LBSTNRHI, 0.0001) > . then LBTOXGR = "1";
	  end;
	  if visitnum = 1 and not missing (lbdtc) and missing (lbdtc_ASTB) and (/*. < LBSTRESN < round(LBSTNRLO, 0.0001) or*/  LBSTRESN > round(LBSTNRHI, 0.0001)> .) then LBTOXGR = "1"; 
	  if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "天冬氨酸氨基转移酶增高";
		/*if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "天冬氨酸氨基转移酶增高";
		end;*/
	end;

	*------------------BILI-----------------------------------;
	if LBTESTCD = "BILI" and LBSTRESN > . and LBSTNRHI > . then do;
		if (. < round(LBSTNRHI, 0.000001) < round(LBSTRESN , 0.000001) <= round(1.5*LBSTNRHI, 0.0001)) then LBTOXGR = "1";
		if (round(1.5*LBSTNRHI, 0.0001) < LBSTRESN <= round(3*LBSTNRHI, 0.0001)) then LBTOXGR = "2";
		if (round(3*LBSTNRHI, 0.0001) < LBSTRESN <= round(10*LBSTNRHI, 0.0001)) then LBTOXGR = "3";
		if (round(10*LBSTNRHI, 0.0001) < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Blood bilirubin increased";
		if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Blood bilirubin increased";
		end;
	end;

	*-----------------CA in MMOL/L and MG/L---------------------------------------;
	if LBTESTCD = "CA" and upcase(LBSTRESU) = "MMOL/L" /* and not missing(LBSTRESN)*/ /*and cmiss(lbstresn_albumin1, lbstresn_albumin2) le 1*/ then do;
/* 	if cmiss(lbstresn_corrcal1, lbstresn_corrcal2) = 2 and cmiss(LBSTRESN, LBSTNRLO) = 0 and LBSTRESN < LBSTNRLO then do;
			if (2 <= LBSTRESN < LBSTNRLO) then LBTOXGR = "1";
			if (1.75 <= LBSTRESN < 2) then LBTOXGR = "2";
			if (1.5 <= LBSTRESN < 1.75) then LBTOXGR = "3";
			if (LBSTRESN < 1.5) then LBTOXGR = "4";
		end;
*/
		if LBSTRESN_corrcal2 > . then do;
			if (LBSTNRHI >= LBSTRESN_corrcal2 >= LBSTNRLO >.) then LBTOXGR = "0";
			if (2 <= LBSTRESN_corrcal2 < LBSTNRLO) then LBTOXGR = "1";
			if (1.75 <= LBSTRESN_corrcal2 < 2) then LBTOXGR = "2";
			if (1.5 <= LBSTRESN_corrcal2 < 1.75) then LBTOXGR = "3";
			if (LBSTRESN_corrcal2 < 1.5) then LBTOXGR = "4";
		end;
		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypocalcemia";

			if LBSTRESN_corrcal2 > . then do;
			if (LBSTNRHI >= LBSTRESN_corrcal2>= LBSTNRLO >.) then LBTOXGR = "0";
			if (. < LBSTNRHI < LBSTRESN_corrcal2 <= 2.9) then LBTOXGR = "1";
			if (2.9 < LBSTRESN_corrcal2 <= 3.1) then LBTOXGR = "2";
			if (3.1 < LBSTRESN_corrcal2 <= 3.4) then LBTOXGR = "3";
			if (LBSTRESN_corrcal2 > 3.4) then LBTOXGR = "4";
		end;
		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypercalcemia";
	end;

	if LBTESTCD = "CA" and upcase(LBSTRESU) = "MG/DL" /*and not missing(LBSTRESN)*/ /*and cmiss(lbstresn_albumin1, lbstresn_albumin2) le 1*/ then do;
	    if LBSTRESN_corrcal1 > . then do;
			if (LBSTNRHI >= LBSTRESN_corrcal1 >= LBSTNRLO > .) then LBTOXGR = "0";
			if (8 <= LBSTRESN_corrcal1 < LBSTNRLO) then LBTOXGR = "1";
			if (7 <= LBSTRESN_corrcal1 < 8) then LBTOXGR = "2";
			if (6 <= LBSTRESN_corrcal1 < 7) then LBTOXGR = "3";
			if (LBSTRESN_corrcal1 < 6) then LBTOXGR = "4";
		end;
		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypocalcemia";

			if LBSTRESN_corrcal1 > . then do;
			if (LBSTNRHI >= LBSTRESN_corrcal1 >= LBSTNRLO > .) then LBTOXGR = "0";
			if (LBSTNRHI < LBSTRESN_corrcal1 <= 11.5) then LBTOXGR = "1";
			if (11.5 < LBSTRESN_corrcal1 <= 12.5) then LBTOXGR = "2";
			if (12.5 < LBSTRESN_corrcal1 <= 13.5) then LBTOXGR = "3";
			if (LBSTRESN_corrcal1 > 13.5) then LBTOXGR = "4";
		end;
		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypercalcemia";
	end;
	
	*----------------------------CAION-------------------------------------------;
	if LBTESTCD = "CAION" and upcase(LBSTRESU) = "MMOL/L" and not missing(LBSTRESN) then do;
		if LBSTRESN > . then do;
			if (. < LBSTNRHI < LBSTRESN <= 1.5) then do; LBTOXGR = "1";LBTOX = "Hypercalcemia"; end;
			if (1.5 < LBSTRESN <= 1.6) then do; LBTOXGR = "2"; LBTOX = "Hypercalcemia"; end;
			if (1.6 < LBSTRESN <= 1.8) then do;  LBTOXGR = "3"; LBTOX = "Hypercalcemia"; end;
			if (1.8 < LBSTRESN) then do; LBTOXGR = "4"; LBTOX = "Hypercalcemia"; end;
		  if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Hypercalcemia";
		end; 
		end;
		if LBSTRESN > . then do;
			if (1.0 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = "1"; LBTOX = "Hypocalcemia"; end;
			if (0.9 <= LBSTRESN < 1.0) then do;  LBTOXGR = "2"; LBTOX = "Hypocalcemia"; end;
			if (0.8 <= LBSTRESN < 0.9) then do; LBTOXGR = "3"; LBTOX = "Hypocalcemia"; end;
			if (LBSTRESN < 0.8) then do;LBTOXGR = "4"; LBTOX = "Hypocalcemia"; end;
		if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Hypocalcemia";
		end; 
		end;

	end;
	*-----------------------CHOL----------------------------------------------;
	if LBTESTCD = "CHOL" and upcase(LBSTRESU) = "MMOL/L" and LBSTRESN > . then do;
		if (. < LBSTNRHI < LBSTRESN <= 7.75) then LBTOXGR = "1";
		if (7.75 < LBSTRESN <= 10.34) then LBTOXGR = "2";
		if (10.34 < LBSTRESN <= 12.92) then LBTOXGR = "3";
		if (12.92 < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypercholesteremia";
		if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Hypercholesteremia";
		end;
	end;

	if LBTESTCD = "CHOL" and upcase(LBSTRESU) = "MG/DL" and LBSTRESN > . then do;
		if (. < LBSTNRHI < LBSTRESN <= 300) then LBTOXGR = "1";
		if (300 < LBSTRESN <= 400) then LBTOXGR = "2";
		if (400 < LBSTRESN <= 500) then LBTOXGR = "3";
		if (500 < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Hypercholesteremia";
		if cmiss(LBTOX, LBTOXGR) = 2 then do;
			LBTOXGR = "0"; LBTOX = "Hypercholesteremia";
		end;
	end;

	*--------------------CK-------------------------------------------------;
	if LBTESTCD = "CK" and upcase(LBSTRESU) = "U/L" and LBSTRESN > . and LBSTNRHI > . then do;
		if (. < LBSTNRHI < LBSTRESN <= round(2.5*LBSTNRHI, 0.0001)) then LBTOXGR = "1";
		if (round(2.5*LBSTNRHI,0.0001) < LBSTRESN <= round(5*LBSTNRHI,0.0001)) then LBTOXGR = "2";
    	if (round(5*LBSTNRHI,0.0001) < LBSTRESN <= round(10*LBSTNRHI,0.0001)) then LBTOXGR = "3";
		if (round(10*LBSTNRHI,0.0001) < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "CPK increased";
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0"; LBTOX = "CPK increased";
		end;
	end;

	*-------------------CREAT---------------------------------------------;
	if LBTESTCD = "CREAT" and LBCAT = "CHEMISTRY" and not missing(LBSTRESN) then do;
		if not missing(LBSTNRHI) and (round(LBSTNRHI, 0.00001) < round(LBSTRESN, 0.00001) <= round(1.5*LBSTNRHI, 0.00001)) then LBTOXGR = "1";
		if not missing(LBSTRESN_creatbl) and  (LBSTRESN_creatbl < LBSTRESN <= round(1.5*LBSTRESN_creatbl, 0.00001)) then LBTOXGR = "1";
		if not missing(LBSTNRHI) and (round(1.5*LBSTNRHI, 0.00001) < LBSTRESN <= round(3*LBSTNRHI, 0.00001)) then LBTOXGR = "2";
		if not missing(LBSTRESN_creatbl) and (round(1.5*LBSTRESN_creatbl, 0.00001) < LBSTRESN <= round(3*LBSTRESN_creatbl, 0.00001)) then LBTOXGR = "2";
		if not missing(LBSTNRHI) and (round(3*LBSTNRHI, 0.00001) < LBSTRESN <= round(6*LBSTNRHI, 0.00001)) then LBTOXGR = "3";
		if not missing(LBSTRESN_creatbl) and (round(3*LBSTRESN_creatbl, 0.00001) < LBSTRESN) then LBTOXGR = "3";
		if not missing(LBSTNRHI) and (round(6*LBSTNRHI, 0.00001) < LBSTRESN) then LBTOXGR = "4";
		*if not missing(LBSTRESN_creatbl) and (round(6*LBSTRESN_creatbl, 0.0001) < LBSTRESN) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX = "Creatinine increased";
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Creatinine increased";
		end;
	end;

	*--------------------------------CREATCLR--------------------------------;

	if LBTESTCD = "CREATCLR" and upcase(LBSTRESU) = "ML/MIN" and LBSTRESN > . then do;
		if (LBSTNRLO ne .) and (60 =< LBSTRESN < LBSTNRLO) then LBTOXGR = "1";
		if (30 <= LBSTRESN < 60) then LBTOXGR = "2";
		if (15 <= LBSTRESN < 30) then LBTOXGR = "3";
		if (LBSTRESN < 15) then LBTOXGR = "4";

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX="慢性肾脏疾病";
		/*if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Chronic kidney disease";
		end;*/
	end;

	*------------------------------FIBRINO------------------------------------;
	if LBTESTCD = "FIBRINO" and LBSTRESN > . then do;
		if (. < round(0.75*LBSTNRLO,0.0001) <= LBSTRESN < LBSTNRLO) then LBTOXGR = "1";
		if (. < round(0.5*LBSTNRLO,0.0001) <= LBSTRESN < round(0.75*LBSTNRLO,0.0001)) then LBTOXGR = "2";
		if (. < round(0.25*LBSTNRLO,0.0001) <= LBSTRESN < round(0.5*LBSTNRLO,0.0001)) then LBTOXGR = '3';
		if (LBSTRESN < round(0.25*LBSTNRLO,0.0001)) then LBTOXGR = '4';
		if LBSTRESU eq 'MG/DL' and LBSTRESN < 50 then LBTOXGR = '4';

		if not missing(LBSTRESN_fibrobl) and LBSTRESN_fibrobl > LBSTRESN then do;
    		if ((LBSTRESN_fibrobl - LBSTRESN)/LBSTRESN_fibrobl)*100 < 25 then LBTOXGR = '1';
    	 	if (25 <= ((LBSTRESN_fibrobl - LBSTRESN)/LBSTRESN_fibrobl)*100 < 50) then LBTOXGR = '2';
     		if (50 <= ((LBSTRESN_fibrobl - LBSTRESN)/LBSTRESN_fibrobl)*100 < 75) then LBTOXGR = '3';
     		if (((LBSTRESN_fibrobl - LBSTRESN)/LBSTRESN_fibrobl)*100 >= 75) then LBTOXGR = '4';
 		end;

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX='Fibrinogen decreased';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Fibrinogen decreased";
		end;
	end;

	*------------------GRF------------------------------------------------------;
	if LBTESTCD eq 'GFR' and upcase(LBSTRESU) eq 'ML/MIN' and LBSTRESN ne . then do;
		if (LBSTNRLO ne .) and (60 =< LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
		if (30 <= LBSTRESN < 60) then LBTOXGR = '2';
		if (15 <= LBSTRESN < 30) then LBTOXGR = '3';
 		if (LBSTRESN < 15) then LBTOXGR = '4';

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX='Chronic kidney disease';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Chronic kidney disease";
		end;
	end;
	*-----------------------------------GLUC: 高血糖症-----------------------------------------;
	if LBTESTCD eq 'GLUC' /*and upcase(LBSTRESU) eq 'MG/DL'*/ and LBSTRESN ne . then do;
			*if (LBSTNRHI >= LBSTRESN >= LBSTNRLO >.) then LBTOXGR = '0';
			/*if (55 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
			if (40 <= LBSTRESN < 55) then LBTOXGR = '2';
			if (30 <= LBSTRESN < 40) then LBTOXGR = '3';
			if (LBSTRESN < 30) then LBTOXGR = '4';*/
            
	        if lbstresn_GLUCBA < lbstresn and not missing (lbstresn_GLUCBA) and (LBDTC >=lbdtc_GLUCB and cmiss (LBDTC,lbdtc_GLUCB) eq 0 ) then do;
                 if cmiss (LBSTNRLO,LBSTNRHI) eq 0 and (lbstresn < LBSTNRLO or lbstresn > LBSTNRHI) then do;   
				       LBTOXGR = '1';
                       LBTOX='高血糖症';
                 end; 
			end;
           if upcase(LBSTRESU) eq 'MMOL/L' then do;
			  if (LBSTNRLO ne .) and (3 < LBSTRESN <= LBSTNRLO) then do;LBTOXGR = '1';LBTOX='低糖血症';end;
			  if (2.2 <= LBSTRESN < 3) then do;LBTOXGR = '2';LBTOX='低糖血症';end;
			  if (1.7 <= LBSTRESN < 2.2) then do;LBTOXGR = '3';LBTOX='低糖血症';end;
			  if LBSTRESN < 1.7 then do;LBTOXGR = '4';LBTOX='低糖血症';end;
		   end;

			/*if LBSTNRHI >= LBSTRESN >= LBSTNRLO >. then do;LBTOXGR = '0';LBTOX='高血糖症';end;*/
			/*if (LBSTNRHI ne .) and (LBSTNRHI < LBSTRESN <= 160) then do;LBTOXGR = '1';LBTOX='高血糖症';end;
			if (160 < LBSTRESN <= 250) then do;LBTOXGR = '2';LBTOX='高血糖症';end;
			if (250 < LBSTRESN <= 500) then do;LBTOXGR = '3';LBTOX='高血糖症';end;
			if LBSTRESN > 500 then do;LBTOXGR = '4';LBTOX='高血糖症';end;*/
	end;
	*-----------------------------GGT-----------------------------------------;
	if LBTESTCD eq 'GGT' and upcase(LBSTRESU) in ('U/L','IU/L') and LBSTRESN ne . and LBSTNRHI ne . then do;
		if (LBSTNRHI < LBSTRESN <= round(2.5*LBSTNRHI,0.0001)) then LBTOXGR = '1';
		if (round(2.5*LBSTNRHI,0.0001) < LBSTRESN <= round(5*LBSTNRHI,0.0001)) then LBTOXGR = '2';
		if (round(5*LBSTNRHI,0.0001) < LBSTRESN <= round(20*LBSTNRHI,0.0001)) then LBTOXGR = '3';
		if (round(20*LBSTNRHI,0.0001) < LBSTRESN) then LBTOXGR = '4';

		if not missing(LBTOXGR) and missing(LBTOX) then LBTOX='Gamma Glutamyl Transpeptidase increased';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Gamma Glutamyl Transpeptidase increased";
		end;
	end;

	*------------------------HGB----------------------------------------------------;
	if LBTESTCD eq 'HGB' and upcase(LBSTRESU) eq "G/L" and LBSTRESN ne . then do;
    		/*if (LBSTRESN*0.1 >= LBSTNRLO*0.1 > .) then do; LBTOXGR = "0"; LBTOX = "贫血"; end;*/
    		if (10 <= LBSTRESN*0.1 < LBSTNRLO*0.1) then do; LBTOXGR = "1"; LBTOX = "贫血"; end;
    		if (8 <= LBSTRESN*0.1 < 10) then do; LBTOXGR = "2"; LBTOX = "贫血"; end;
    		if (LBSTRESN*0.1 < 8) then do; LBTOXGR = "3"; LBTOX = "贫血"; end;

		if not missing(LBSTNRHI) and LBSTRESN > LBSTNRHI then do; 
    		if NOT MISSING (LBSTRESN_hgbbl) AND LBSTNRHI > LBSTRESN_hgbbl or lbblfl = "Y" then do;
    			if (LBSTNRHI*0.1 < LBSTRESN*0.1 <= (2 + LBSTNRHI*0.1)) then do;LBTOXGR = "1"; LBTOX = "血红蛋白增高"; end;
    			if ((2 + LBSTNRHI*0.1) < LBSTRESN*0.1  <= (4 + LBSTNRHI*0.1)) then do; LBTOXGR = "2"; LBTOX = "血红蛋白增高"; end;
    			if (LBSTRESN*0.1 > (4 + LBSTNRHI*0.1)) then do;LBTOXGR = "3"; LBTOX = "血红蛋白增高"; end;

				if lbblfl = "Y" then do;
                    if LBSTRESN*0.1 > LBSTNRHI*0.1 then do;
                       LBTOXGR = "1"; LBTOX = "血红蛋白增高";
					end;                     
				end;
			end;

			if NOT MISSING (LBSTRESN_hgbbl) AND LBSTRESN_hgbbl > LBSTNRHI and lbblfl ne "Y" then do;
    			if (LBSTRESN_hgbbl*0.1 < LBSTRESN*0.1 <= (2 + LBSTRESN_hgbbl*0.1)) then do;LBTOXGR='1';LBTOX='血红蛋白增高';end;
 				if ((2 + LBSTRESN_hgbbl*0.1) < LBSTRESN*0.1  <= (4 + LBSTRESN_hgbbl*0.1)) then do;LBTOXGR='2';LBTOX='血红蛋白增高';end;
				if (LBSTRESN*0.1 > (4 + LBSTRESN_hgbbl*0.1)) then do;LBTOXGR='3';LBTOX='血红蛋白增高';end;
			end;
		end;

	end;

	*-----------------------INR------------------------------------------------------;
	if LBTESTCD eq 'INR' and LBSTRESN ne . then do; 
		if  1.2 < LBSTRESN <= 1.5 then LBTOXGR = '1';
		if  1.5 < LBSTRESN <= 2.5 then LBTOXGR = '2';
		if  2.5 < LBSTRESN then LBTOXGR = '3';

		if not missing(LBTOXGR) then LBTOX='INR增高';
   		/*if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "INR 增高";
		end;*/
	end;

	*------------------------K-----------------------------------------------;
	if LBTESTCD eq 'K' and upcase(LBSTRESU) in ('MEQ/L','MMOL/L') and LBSTRESN ne . then do;
			/*if (LBSTNRHI >= LBSTRESN >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Hypokalemia'; end;*/
			if (3 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='低钾血症'; end;
			if (2.5 <= LBSTRESN < 3) then do; LBTOXGR = '3'; LBTOX='低钾血症'; end;
			if (LBSTRESN < 2.5) then do; LBTOXGR = '4'; LBTOX='低钾血症'; end;

			if not missing(LBTOXGR) and missing(LBTOX) then LBTOX='Hypokalemia';

			/*if LBSTNRHI >= LBSTRESN >= LBSTNRLO >. then do;LBTOXGR = '0';LBTOX='Hyperkalemia';end;*/
			if (. < LBSTNRHI < LBSTRESN <= 5.5) then do;LBTOXGR = '1';LBTOX='高钾血症';end;
			if (5.5 < LBSTRESN <= 6) then do;LBTOXGR = '2';LBTOX='高钾血症';end;
			if (6 < LBSTRESN <= 7) then do;LBTOXGR = '3';LBTOX='高钾血症';end;
			if (LBSTRESN > 7) then do;LBTOXGR = '4';LBTOX='高钾血症';end;

	end;

	*----------------------------LIPASE----------------------------------------------------;
	if LBTESTCD eq 'LIPASE' and upcase(LBSTRESU) in ('U/L','IU/L') and LBSTRESN ne . and LBSTNRHI ne . then do;
		if (LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI,0.0001)) then LBTOXGR = '1';
		if (round(1.5*LBSTNRHI,0.0001) < LBSTRESN <= round(2*LBSTNRHI,0.0001)) then LBTOXGR = '2';
		if (round(2*LBSTNRHI,0.0001) < LBSTRESN <= round(5*LBSTNRHI,0.0001)) then LBTOXGR = '3';
		if (round(5*LBSTNRHI,0.0001) < LBSTRESN) then LBTOXGR = '4';

		if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Lipase increased';
   		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Lipase increased";
		end;
	end;

	*-------------------------------LYM---------------------------------------------------;
	if LBTESTCD eq 'LYM' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3','10^9/L') and LBSTRESN ne . then do;
/*			if (LBSTRESN >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Lymphopenia'; end;*/
/*			else if (0.8 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='Lymphopenia'; end;*/
/*			else if (0.5 <= LBSTRESN < 0.8) then do; LBTOXGR = '2'; LBTOX='Lymphopenia'; end;*/
/*			else if (0.2 <= LBSTRESN < 0.5) then do; LBTOXGR = '3'; LBTOX='Lymphopenia'; end;*/
/*			else if (LBSTRESN < 0.2) then do; LBTOXGR = '4'; LBTOX='Lymphopenia'; end;*/
                                                /*if (LBSTRESN >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Lymphopenia'; end;*/
                                                if (0.8 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='淋巴细胞计数降低'; end;
                                                if (0.5 <= LBSTRESN < 0.8) then do; LBTOXGR = '2';LBTOX='淋巴细胞计数降低' /*LBTOX='Lymphopenia'*/; end;
                                                if (0.2 <= LBSTRESN < 0.5) then do; LBTOXGR = '3'; LBTOX='淋巴细胞计数降低'; end;
                                                if (LBSTRESN < 0.2) then do; LBTOXGR = '4'; LBTOX='淋巴细胞计数降低'; end;

		if (4 < LBSTRESN <= 20) then do;LBTOXGR='2';LBTOX='淋巴细胞计数增高';end;
		if (LBSTRESN > 20) then do;LBTOXGR='3';LBTOX='淋巴细胞计数增高';end;
     /*
   		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Grade 0";
		end;*/ 
	end;

	*------------------------------------LYMLE-----------------------------------------;
	if LBTESTCD eq 'LYMLE' and LBSTRESU eq '%' and LBSTRESN ne . and LBSTRESN_wbc ne . then do;
			if (((LBSTRESN/100)*LBSTRESN_wbc) >= ((LBSTNRLO/100)*LBSTRESN_wbc) >.) then do; LBTOXGR = '0'; LBTOX='Lymphopenia'; end;
			if (0.8 <= ((LBSTRESN/100)*LBSTRESN_wbc) < ((LBSTNRLO/100)*LBSTRESN_wbc)) then do; LBTOXGR = '1'; LBTOX='Lymphopenia'; end;
			if (0.5 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 0.8) then do; LBTOXGR = '2'; LBTOX='Lymphopenia'; end;
			if (0.2 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 0.5) then do; LBTOXGR = '3'; LBTOX='Lymphopenia'; end;
			if (((LBSTRESN/100)*LBSTRESN_wbc)< 0.2) then do; LBTOXGR = '4'; LBTOX='Lymphopenia'; end;

		if (4 < ((LBSTRESN/100)*LBSTRESN_wbc) <= 20) then do;LBTOXGR='2';LBTOX='Lymphocyte count increased';end;
		if (((LBSTRESN/100)*LBSTRESN_wbc) > 20) then do;LBTOXGR='3';LBTOX='Lymphocyte count increased';end;

	end;

	*------------------------------------MG IN MG/DL-----------------------------------------------;
	if LBTESTCD eq 'MG' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
			if (LBSTNRHI >= LBSTRESN >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Hypomagnesemia'; end;
			if (LBSTNRLO ne .) and (1.2 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='Hypomagnesemia'; end;
			if (0.9 <= LBSTRESN < 1.2) then do; LBTOXGR = '2'; LBTOX='Hypomagnesemia'; end;
			if (0.7 <= LBSTRESN < 0.9) then do; LBTOXGR = '3'; LBTOX='Hypomagnesemia'; end;
			if (LBSTRESN < 0.7) then do; LBTOXGR = '4'; LBTOX='Hypomagnesemia'; end;
      		if (LBSTNRHI >= LBSTRESN >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Hypermagnesemia'; end;
      		if (LBSTNRHI ne .) and (LBSTNRHI < LBSTRESN <= 3) then do; LBTOXGR = '1'; LBTOX='Hypermagnesemia'; end;
      		if (3 < LBSTRESN <= 8) then do; LBTOXGR = '3'; LBTOX='Hypermagnesemia'; end;
      		if (LBSTRESN > 8) then do; LBTOXGR = '4'; LBTOX='Hypermagnesemia'; end;
	end;

	*---------------------------------MG IN MMOL/L-------------------------------------------------;
	if LBTESTCD eq 'MG' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
			if (LBSTRESN >= LBSTNRLO >= LBSTNRLO >.) then do; LBTOXGR = '0'; LBTOX='Hypomagnesemia'; end;
			if (LBSTNRLO ne .) and (0.5 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='Hypomagnesemia'; end;
			if (0.4 <= LBSTRESN < 0.5) then do; LBTOXGR = '2'; LBTOX='Hypomagnesemia'; end;
			if (0.3 <= LBSTRESN < 0.4) then do; LBTOXGR = '3'; LBTOX='Hypomagnesemia'; end;
			if (LBSTRESN < 0.3) then do; LBTOXGR = '4'; LBTOX='Hypomagnesemia'; end;

			if (LBSTNRHI >= LBSTRESN >= LBSTNRLO >.) then do;LBTOXGR = '0';LBTOX='Hypermagnesemia';end;
			if (LBSTNRHI ne .) and (LBSTNRHI < LBSTRESN <= 1.23) then do;LBTOXGR = '1';LBTOX='Hypermagnesemia';end;
			if (1.23 < LBSTRESN <= 3.3) then do;LBTOXGR = '3';LBTOX='Hypermagnesemia';end;
			if (LBSTRESN > 3.3) then do;LBTOXGR = '4';LBTOX='Hypermagnesemia';end;
	end;

	*-------------------------------------NEUT---------------------------------------------;
	if LBTESTCD eq 'NEUT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then do;
		if (LBSTNRLO ne .) and (1.5 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
		if (1 <= LBSTRESN < 1.5) then LBTOXGR = '2';
		if (0.5 <= LBSTRESN < 1) then LBTOXGR = '3';
		if (LBSTRESN < 0.5) then LBTOXGR = '4';
       /*
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Neutrophil count decreased";
		end;*/
	end;
    if LBTESTCD eq 'NEUT' and LBTOXGR ne '' then LBTOX='中性粒细胞计数降低';
	*-------------------------------NEUTLE-------------------------------------------------;
	if LBTESTCD eq 'NEUTLE' and LBSTRESU eq '%' and LBSTRESN ne . then do;
		if LBSTRESN_wbc ne . then do;
			if (LBSTNRLO ne .) and (1.5 <= ((LBSTRESN/100)*LBSTRESN_wbc) < ((LBSTNRLO/100)*LBSTRESN_wbc)) then LBTOXGR = '1';
			if (1 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 1.5) then LBTOXGR = '2';
			if (0.5 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 1) then LBTOXGR = '3';
			if (((LBSTRESN/100)*LBSTRESN_wbc) < 0.5) then LBTOXGR = '4';

			/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='中性粒细胞计数降低';
			if cmiss(LBTOXGR, LBTOX) = 2 then do;
				LBTOXGR = "0";
				LBTOX = "Neutrophil count decreased";
			end;*/
  		end;
	end;

	*-------------------------PHOS in MG/DL---------------------------------------------------------;
	if LBTESTCD eq 'PHOS' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
		if (LBSTNRLO ne .) and (2.5 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
		if (2 <= LBSTRESN < 2.5) then LBTOXGR = '2';
		if (1 <= LBSTRESN < 2) then LBTOXGR = '3';
		if (LBSTRESN < 1) then LBTOXGR = '4';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hypophosphatemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hypophosphatemia";
		end;*/
	end;

	*----------------PHOS in MMOL/L------------------------------------------------------------;
	if LBTESTCD eq 'PHOS' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
		if (LBSTNRLO ne .) and (0.8 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
		if (0.6 <= LBSTRESN < 0.8) then LBTOXGR = '2';
		if (0.3 <= LBSTRESN < 0.6) then LBTOXGR = '3';
		if (LBSTRESN < 0.3) then LBTOXGR = '4';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hypophosphatemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hypophosphatemia";
		end;*/
	end;

	*--------------------PLAT----------------------------------------------------;
	if LBTESTCD eq 'PLAT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then do;
		if (LBSTNRLO >= 75) and (75 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
		if (50 <= LBSTRESN < 75) then LBTOXGR = '2';
		if (25 <= LBSTRESN < 50) then LBTOXGR = '3';
		if (LBSTRESN < 25) then LBTOXGR = '4';

		
		/*if cmiss(LBTOXGR, LBTOX) = 2 & LBSTNRLO>. then do;
			LBTOXGR = "0";
			LBTOX = "Platelet count decreased";
		end;*/
	end;
	if LBTESTCD eq 'PLAT' and LBTOXGR ne '' then LBTOX='血小板计数降低';

	*-------------------------PROT------------------------------------------;
	if LBTESTCD in ('PROT', "UPROT") and LBCAT eq 'URINALYSIS' and upcase(LBSTRESU) in ('MG/D','G/24 HRS') and LBSTRESN ne . then do;
		if (150 < LBSTRESN <= 1000) then LBTOXGR = '1';
		if (1000 < LBSTRESN <= 3500) then LBTOXGR = '2';
		if (LBSTRESN > 3500) then LBTOXGR = '3';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Proteinuria increased';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Proteinuria increased";
		end;*/
	end;

	*---------------------PROT IN URIN------------------------------------;
	if LBTESTCD in ('PROT', "UPROT") and LBCAT eq 'URINALYSIS' and LBORRES ne '' then do;
		if upcase(LBORRES) in ('NEG','NEG.','NEGATIVE','NIL', 'TRACE','TRACES','TR','TRACE-NEG','TRACE/NEG','0',"ABSENT", "NOT DETE", "-", "+/-") then LBTOXGR='0';
		if upcase(LBORRES) in ('+',    '1+', "POS(+)",  "POS", "POSITIVE", "POSITIVE (+)", "A TRACE OF PROTEIN ASCORBINACID + (POSITIVE)","POSITIVE (+)","POSITIVE +", "POSITIVE(+)", "+","POSITIVE","POSITIVE (+)", "+1") then LBTOXGR='1';
		if upcase(LBORRES) in ("++",   "2+", "POS(++)", "2+ ESTIMETED BASED ON EXAM PERFORMED BY LOCAL LAB RESULTING IN 5MG/DL", "POSITIVE (++)","POSITIVE (2+)","2 +", "+2") then LBTOXGR='2';
		if upcase(LBORRES) in ("++++", "4+", "3+", "+++") then LBTOXGR='3';

		if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Urine Protein';
	end;

	*--------------------PROTCRT--------------------------------------;
	if LBTESTCD eq 'PROTCRT' and LBCAT eq 'URINALYSIS' and upcase(LBSTRESU) in ('MG/MG', "RATIO") and LBSTRESN ne . then do;
		if (LBSTRESN > 0.5) then LBTOXGR = '1';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Chronic kidney disease';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Chronic kidney disease";
		end;*/
	end;

	*-------------------PT----------------------------------------------;
	/*if LBTESTCD eq 'PT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . then do;
		if (. < LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI,0.0001)) then LBTOXGR = '1';
		if (. < round(1.5*LBSTNRHI,0.0001) < LBSTRESN <= round(2*LBSTNRHI,0.0001)) then LBTOXGR = '2';
		if (. < 2*LBSTNRHI < LBSTRESN) then LBTOXGR = '3';

		if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Prothrombin time increased';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Prothrombin time increased";
		end;
	end;*/

	*----------------PTT-------------------------------------------------------;
	if LBTESTCD eq 'PTT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . then do;
		if (. < LBSTNRHI < LBSTRESN <= round(1.5*LBSTNRHI,0.0001)) then LBTOXGR = '1';
		if (. < round(1.5*LBSTNRHI,0.0001) < LBSTRESN <= round(2.5*LBSTNRHI,0.0001)) then LBTOXGR = '2';
		if (. < round(2.5*LBSTNRHI,0.0001) < LBSTRESN) then LBTOXGR = '3';

	/*	if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Activated partial thromboplastin time prolonged';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Activated partial thromboplastin time prolonged";
		end;*/
	end;

	*----------------------------TRIG in MG/DL----------------------------------------------;
	if LBTESTCD eq 'TRIG' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
		if (150 < LBSTRESN <= 300) then LBTOXGR = '1';
		if (300 < LBSTRESN <= 500) then LBTOXGR = '2';
		if (500 < LBSTRESN <= 1000) then LBTOXGR = '3';
		if LBSTRESN > 1000 then LBTOXGR = '4';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hypertriglyceridemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hypertriglyceridemia";
		end;*/
	end;

	*------------------------TRIG in MMOL/L-----------------------------------------;
	if LBTESTCD eq 'TRIG' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
		if (1.71 < LBSTRESN <= 3.42) then LBTOXGR = '1';
		if (3.42 < LBSTRESN <= 5.7) then LBTOXGR = '2';
		if (5.7 < LBSTRESN <= 11.4) then LBTOXGR = '3';
		if LBSTRESN > 11.4 then LBTOXGR = '4';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hypertriglyceridemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hypertriglyceridemia";
		end;*/
	end;

	*------------------------------SODIUM-------------------------------;
	if LBTESTCD eq 'SODIUM' and upcase(LBSTRESU) in ('MEQ/L','MMOL/L') and LBSTRESN ne . then do;

			if (LBSTNRLO ne .) and (130 <= LBSTRESN < LBSTNRLO) then do; LBTOXGR = '1'; LBTOX='低钠血症'; end;
			if (125 <= LBSTRESN < 129) then do; LBTOXGR = '3'; LBTOX='低钠血症'; end;
			if (LBSTRESN < 120) then do; LBTOXGR = '4'; LBTOX='低钠血症'; end;

			if (LBSTNRHI ne .) and (LBSTNRHI < LBSTRESN <= 150) then do;LBTOXGR = '1';LBTOX='高钠血症';end;
			if (150 < LBSTRESN <= 155) then do;LBTOXGR = '2';LBTOX='高钠血症';end;
			if (155 < LBSTRESN <= 160) then do;LBTOXGR = '3';LBTOX='高钠血症';end;
			if (LBSTRESN > 160) then do;LBTOXGR = '4';LBTOX='高钠血症';end;
	end;

	*-----------------------------URATE-------------------------------------------;
	if LBTESTCD = 'URATE' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . and LBSTNRHI ne . then do;
		if (LBSTNRHI ne . ) and (LBSTNRHI < LBSTRESN <= 10) then LBTOXGR = '1';
		if (LBSTRESN > 10) then LBTOXGR = '4';

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hyperuricemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hyperuricemia";
		end;*/
	end;

	*------------------------WBC--------------------------------------------------;
	if LBTESTCD eq 'WBC' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then do;
			*if (LBSTRESN >= LBSTNRLO > .) then LBTOXGR = '0';
			if (LBSTNRLO ne .) and (3 <= LBSTRESN < LBSTNRLO) then LBTOXGR = '1';
			if (2 <= LBSTRESN < 3) then LBTOXGR = '2';
			if (1 <= LBSTRESN < 2) then LBTOXGR = '3';
			if (LBSTRESN < 1) then LBTOXGR = '4';
		

		/*if LBSTRESN > 100 then do;LBTOXGR='3';LBTOX='Leukocytosis';end;

		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Grade 0";
		end;*/
	end;
    if LBTOXGR ne '' and LBTESTCD eq 'WBC' then LBTOX='白细胞数降低';
*	if LBTOXGR = "0" then LBTOX = "Grade 0";

	*-----------------------------LDH: 血乳酸脱氢酶升高-------------------------------------------;
	if LBTESTCD = 'LDH' /*and upcase(LBSTRESU) eq 'U/L'*/ and LBSTRESN ne . and LBSTNRHI ne . then do;
		if (LBSTNRHI ne . ) and (LBSTNRHI < LBSTRESN ) then do;
            LBTOXGR = '1';
			LBTOX = "血乳酸脱氢酶升高";
		end;

		/*if LBTOXGR ne '' and LBTOX eq '' then LBTOX='Hyperuricemia';
		if cmiss(LBTOXGR, LBTOX) = 2 then do;
			LBTOXGR = "0";
			LBTOX = "Hyperuricemia";
		end;*/
	end;
run;
%mend lbtoxgr_ng;
/*** End of Program ***/
