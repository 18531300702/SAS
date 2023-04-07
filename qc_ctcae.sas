/*=============================================================================
                             Project Information
-------------------------------------------------------------------------------
 Customer Name          : Mabworks
 Protocol Number        : MIL62-CT02
 Project Code           : MIL62-CT02
 Study Drug             : ...
 Project Root Path      : MIL62-CT02\Biostatistics
-------------------------------------------------------------------------------
                             Program Information
-------------------------------------------------------------------------------
 Program                : \Qc\Macros\QC_AE_LST.sas 
 Brief Description      : Serious Adverse Events (From OC) Listing 
 Copied From            : None
 Raw Data Sets Used     : 
 Derived Data Sets Used : ADAE  
 Data Set Created       : QT14_03_02_02_01
 Output Files           :    
 Notes / Assumptions    : ...
-------------------------------------------------------------------------------
                             Programmer Information
-------------------------------------------------------------------------------
 Author                 : Lin Liu
 User ID                : q793880
 Creation Date          : 01Jul2020
-------------------------------------------------------------------------------
                            Environment Information
-------------------------------------------------------------------------------
 SAS Version            : 9.2
 Operating System       : Windows XP
-------------------------------------------------------------------------------  
                           Change Control Information
-------------------------------------------------------------------------------
 Modifications:
 Programmer/Date:         Reason:
 ----------------         --------------------------------------------------

==============================================================================*/


%macro QC_CTCAE ;

proc sql noprint ;
  create table ALT_BL as 
    select usubjid, lbstresn as LBSTRESN_ALTbl from FINAL where LBBLFL='Y' & LBTESTCD='ALT' order by USUBJID ; 
  create table AST_BL as 
    select usubjid, lbstresn as LBSTRESN_ASTbl from FINAL where LBBLFL='Y' & LBTESTCD='AST' order by USUBJID ; 
  create table ALP_BL as 
    select usubjid, lbstresn as LBSTRESN_ALPbl from FINAL where LBBLFL='Y' & LBTESTCD='ALP' order by USUBJID ;
  create table TBIL_BL as 
    select usubjid, lbstresn as LBSTRESN_TBILbl from FINAL where LBBLFL='Y' & LBTESTCD='TBIL' order by USUBJID ;
  create table GLUC_BL as 
    select usubjid, lbstresn as LBSTRESN_GLUCbl from FINAL where LBBLFL='Y' & LBTESTCD='GLUC' order by USUBJID ;
 
  create table CREAT_BL as 
    select usubjid, lbstresn as LBSTRESN_creatbl from FINAL where LBBLFL='Y' & LBTESTCD='CREAT' order by USUBJID ; 


  create table HGB_BL as 
    select usubjid, lbstresn as LBSTRESN_hgbbl from FINAL where LBBLFL='Y' & LBTESTCD='HGB' order by USUBJID ; 
  create table WBC as 
    select usubjid, lbstresn as LBSTRESN_wbc, VISITNUM, LBDTC from FINAL where LBTESTCD='WBC' order by USUBJID, VISITNUM, LBDTC ; 
  create table ALB as 
    select usubjid, lbstresn as LBSTRESN_alb, VISITNUM, LBDTC from FINAL where LBTESTCD='ALB' & lbstresn>. order by USUBJID, VISITNUM, LBDTC ; 

quit ;

proc sort data=FINAL ; by USUBJID VISITNUM LBDTC ; run ;

data FINAL ;
  merge FINAL wbc alb;
  by USUBJID VISITNUM LBDTC ;
  if .<LBSTRESN_alb & lbstresn>. then LBSTRESN_corrcal1=lbstresn+0.8*(4-LBSTRESN_alb) ;
  if LBSTRESN_corrcal1>. then LBSTRESN_corrcal2=LBSTRESN_corrcal1 ;
run ;

data FINAL ;
  merge FINAL creat_bl hgb_bl ALT_BL AST_BL ALP_BL TBIL_BL GLUC_BL;
  by USUBJID ;
 
***1.ALT ***;
if LBTESTCD eq 'ALT' and upcase(LBSTRESU) in ('U/L','IU/L') and .< LBSTNRHI < LBSTRESN then do;
  if (LBDY>1 & LBSTRESN_ALTbl<=LBSTNRHI) or LBDY<=1 then do ;
  if    LBSTNRHI < LBSTRESN <=  3*LBSTNRHI  then LBTOXGR = '1';
  if  3*LBSTNRHI < LBSTRESN <=  5*LBSTNRHI  then LBTOXGR = '2';
  if  5*LBSTNRHI < LBSTRESN <= 20*LBSTNRHI  then LBTOXGR = '3';
  if 20*LBSTNRHI < LBSTRESN                 then LBTOXGR = '4';
  end ;
  else if (LBDY>1 & LBSTRESN_ALTbl> LBSTNRHI) then do ;
  if 1.5*LBSTRESN_ALTbl < LBSTRESN <=  3*LBSTRESN_ALTbl  then LBTOXGR = '1';
  if   3*LBSTRESN_ALTbl < LBSTRESN <=  5*LBSTRESN_ALTbl  then LBTOXGR = '2';
  if   5*LBSTRESN_ALTbl < LBSTRESN <= 20*LBSTRESN_ALTbl  then LBTOXGR = '3';
  if  20*LBSTRESN_ALTbl < LBSTRESN                       then LBTOXGR = '4';
  end ;
  if LBTOXGR ne '' then LBTOX='丙氨酸氨基转移酶增高';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'ALT' and upcase(LBSTRESU) in ('U/L','IU/L') and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

*** 2.ALB ***;
if LBTESTCD eq 'ALB' and upcase(LBSTRESU) eq 'G/DL' and .< LBSTRESN < LBSTNRLO then do;
  if 3 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
  if 2 <= LBSTRESN < 3        then LBTOXGR = '2';
  if      LBSTRESN < 2        then LBTOXGR = '3';
  if LBTOXGR ne '' then LBTOX='低白蛋白血症';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'ALB' and upcase(LBSTRESU) eq 'G/DL' and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

if LBTESTCD eq 'ALB' and upcase(LBSTRESU) eq 'G/L' and .< LBSTRESN < LBSTNRLO then do;
  if 30 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
  if 20 <= LBSTRESN < 30        then LBTOXGR = '2';
  if       LBSTRESN < 20        then LBTOXGR = '3';
  if LBTOXGR ne '' then LBTOX='低白蛋白血症';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'ALB' and upcase(LBSTRESU) eq 'G/L' and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

*** 3.ALP ***;
if LBTESTCD eq 'ALP' and upcase(LBSTRESU) in ('U/L','IU/L') and .< LBSTNRHI < LBSTRESN then do;
  if (LBDY>1 & LBSTRESN_ALPbl<=LBSTNRHI) or LBDY<=1 then do ;
  if      LBSTNRHI < LBSTRESN <= 2.5*LBSTNRHI then LBTOXGR = '1';
  if  2.5*LBSTNRHI < LBSTRESN <= 5.0*LBSTNRHI then LBTOXGR = '2';
  if  5.0*LBSTNRHI < LBSTRESN <=20.0*LBSTNRHI then LBTOXGR = '3';
  if 20.0*LBSTNRHI < LBSTRESN                 then LBTOXGR = '4';
  end ;
  else if (LBDY>1 & LBSTRESN_ALPbl> LBSTNRHI) then do ;
  if  2.0*LBSTRESN_ALPbl < LBSTRESN <=  2.5*LBSTRESN_ALPbl  then LBTOXGR = '1';
  if  2.5*LBSTRESN_ALPbl < LBSTRESN <=  5.0*LBSTRESN_ALPbl  then LBTOXGR = '2';
  if  5.0*LBSTRESN_ALPbl < LBSTRESN <= 20.0*LBSTRESN_ALPbl  then LBTOXGR = '3';
  if 20.0*LBSTRESN_ALPbl < LBSTRESN                         then LBTOXGR = '4';
  end ;

  if LBTOXGR ne '' then LBTOX='碱性磷酸酶增高';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'ALP' and upcase(LBSTRESU) in ('U/L','IU/L') and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

*** 4.AST ***;
if LBTESTCD eq 'AST' and upcase(LBSTRESU) in ('U/L','IU/L') and .< LBSTNRHI < LBSTRESN then do;
  if (LBDY>1 & LBSTRESN_ASTbl<=LBSTNRHI) or LBDY<=1 then do ;
  if    LBSTNRHI < LBSTRESN <=  3*LBSTNRHI  then LBTOXGR = '1';
  if  3*LBSTNRHI < LBSTRESN <=  5*LBSTNRHI  then LBTOXGR = '2';
  if  5*LBSTNRHI < LBSTRESN <= 20*LBSTNRHI then LBTOXGR = '3';
  if 20*LBSTNRHI < LBSTRESN                then LBTOXGR = '4';
  end ;
  else if (LBDY>1 & LBSTRESN_ASTbl> LBSTNRHI) then do ;
  if 1.5*LBSTRESN_ASTbl < LBSTRESN <=  3*LBSTRESN_ASTbl  then LBTOXGR = '1';
  if   3*LBSTRESN_ASTbl < LBSTRESN <=  5*LBSTRESN_ASTbl  then LBTOXGR = '2';
  if   5*LBSTRESN_ASTbl < LBSTRESN <= 20*LBSTRESN_ASTbl  then LBTOXGR = '3';
  if  20*LBSTRESN_ASTbl < LBSTRESN                       then LBTOXGR = '4';
  end ;

  if LBTOXGR ne '' then LBTOX='天冬氨酸氨基转移酶增高';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'AST' and upcase(LBSTRESU) in ('U/L','IU/L') and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

*** 5.TBIL ***;
if LBTESTCD eq 'TBIL' and .< LBSTNRHI < LBSTRESN then do;
  if (LBDY>1 & LBSTRESN_TBILbl<=LBSTNRHI) or LBDY<=1 then do ;
  if     round(LBSTNRHI,0.00001) < LBSTRESN <= round(1.5*LBSTNRHI,0.00001) then LBTOXGR = '1';
  if round(1.5*LBSTNRHI,0.00001) < LBSTRESN <= round(3*LBSTNRHI,0.00001)   then LBTOXGR = '2';
  if round(3.0*LBSTNRHI,0.00001) < LBSTRESN <= round(10*LBSTNRHI,0.00001)  then LBTOXGR = '3';
  if  round(10*LBSTNRHI,0.00001) < LBSTRESN                 then LBTOXGR = '4';
  end ;
  else if (LBDY>1 & LBSTRESN_TBILbl> LBSTNRHI) then do ;
  if 1.0*LBSTRESN_TBILbl < LBSTRESN <=1.5*LBSTRESN_TBILbl  then LBTOXGR = '1';
  if 1.5*LBSTRESN_TBILbl < LBSTRESN <=3.0*LBSTRESN_TBILbl  then LBTOXGR = '2';
  if 3.0*LBSTRESN_TBILbl < LBSTRESN <= 10*LBSTRESN_TBILbl  then LBTOXGR = '3';
  if  10*LBSTRESN_TBILbl < LBSTRESN                       then LBTOXGR = '4';
  end ;

  if LBTOXGR ne '' then LBTOX='血胆红素增高';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'TBIL' and .<LBSTRESN & LBSTNRHI>. then LBTOXGR = '0';  

*** 6.BUN ***;
*** 7.CA ***;  
/*LBTOXGR/LBTOX applied for Corrected Serum Calcium values for Hypocalcemia using LBSTRESN for Albumin per visit If Serum albumin is <4.0 g/dL. Corrected Calcium (MG/DL) = Calcium (MG/DL) + 0.8*(Albumin (G/DL) - 4);*/
/*Else applied for collected Serum Calcium values.*/
if LBTESTCD eq 'CA' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
  if .< LBSTRESN_corrcal1 < LBSTNRLO then do;
    if 8 <= LBSTRESN_corrcal1 < LBSTNRLO  then LBTOXGR = '1';
    if 7 <= LBSTRESN_corrcal1 < 8         then LBTOXGR = '2';
    if 6 <= LBSTRESN_corrcal1 < 7         then LBTOXGR = '3';
    if      LBSTRESN_corrcal1 < 6         then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低钙血症';
  end;
  
  if .< LBSTNRHI < LBSTRESN_corrcal1 then do;
    if LBSTNRHI < LBSTRESN_corrcal1 <= 11.5 then LBTOXGR = '1';
    if     11.5 < LBSTRESN_corrcal1 <= 12.5 then LBTOXGR = '2';
    if     12.5 < LBSTRESN_corrcal1 <= 13.5 then LBTOXGR = '3';
    if     13.5 < LBSTRESN_corrcal1         then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高钙血症';   
  end;

  if LBTOXGR eq '' & LBSTRESN_corrcal1>. then LBTOXGR = '0'; 
end;
/*LBTOXGR/LBTOX applied for Corrected Serum Calcium values for Hypocalcemia using LBSTRESN for Albumin per visit If Serum albumin is <4.0 g/dL. Corrected Calcium (MG/DL) = Calcium (MG/DL) + 0.8*(Albumin (G/DL) - 4);*/
/*Else applied for collected Serum Calcium values.*/
if LBTESTCD eq 'CA' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
  if .< LBSTRESN_corrcal2 < LBSTNRLO then do;
    if 2.00 <= LBSTRESN_corrcal2 < LBSTNRLO then LBTOXGR = '1';
    if 1.75 <= LBSTRESN_corrcal2 < 2.00     then LBTOXGR = '2';
    if 1.50 <= LBSTRESN_corrcal2 < 1.75     then LBTOXGR = '3';
    if         LBSTRESN_corrcal2 < 1.50     then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低钙血症';
  end;
  
  if .< LBSTNRHI < LBSTRESN_corrcal2 then do;
    if LBSTNRHI < LBSTRESN_corrcal2 <= 2.9 then LBTOXGR = '1';
    if      2.9 < LBSTRESN_corrcal2 <= 3.1 then LBTOXGR = '2';
    if      3.1 < LBSTRESN_corrcal2 <= 3.4 then LBTOXGR = '3';
    if      3.4 < LBSTRESN_corrcal2        then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高钙血症';    
  end;

  if LBTOXGR eq '' & LBSTRESN_corrcal2>. then LBTOXGR = '0'; 
end;

*** 8.CREAT ***;
if LBTESTCD eq 'CREAT' and LBCAT eq 'CHEMISTRY' and LBSTRESN ne . then do;
  if LBSTNRHI ne . and round(1.0*LBSTNRHI,0.0001) < round(LBSTRESN,0.0001) <= round(1.5*LBSTNRHI,0.0001) then LBTOXGR1 = '1'; 
  if LBSTNRHI ne . and round(1.5*LBSTNRHI,0.0001) < round(LBSTRESN,0.0001) <= round(3.0*LBSTNRHI,0.0001) then LBTOXGR1 = '2';
  if LBSTNRHI ne . and round(3.0*LBSTNRHI,0.0001) < round(LBSTRESN,0.0001) <= round(6.0*LBSTNRHI,0.0001) then LBTOXGR1 = '3';
  if LBSTNRHI ne . and round(6.0*LBSTNRHI,0.0001) < round(LBSTRESN,0.0001)                               then LBTOXGR1 = '4';

 *if LBSTRESN_creatbl ne . and round(    LBSTRESN_creatbl,0.0001) < round(LBSTRESN,0.0001) <= round(1.5*LBSTRESN_creatbl,0.0001) then LBTOXGR2 = '1';
  if LBSTRESN_creatbl ne . and round(1.5*LBSTRESN_creatbl,0.0001) < round(LBSTRESN,0.0001) <= round(3.0*LBSTRESN_creatbl,0.0001) then LBTOXGR2 = '2';
  if LBSTRESN_creatbl ne . and round(3.0*LBSTRESN_creatbl,0.0001) < round(LBSTRESN,0.0001)                                       then LBTOXGR2 = '3';
 
       if LBTOXGR1>=LBTOXGR2 then LBTOXGR=LBTOXGR1 ;
  else if LBTOXGR2> LBTOXGR1 then LBTOXGR=LBTOXGR2 ;

  if LBTOXGR ne '' then LBTOX='肌酐增高';
  else LBTOXGR = '0'; 
end;

*** 9.CAION ***; 
if LBTESTCD eq 'CAION' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 1.0 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
    if 0.9 <= LBSTRESN < 1.0      then LBTOXGR = '2';
    if 0.8 <= LBSTRESN < 0.9      then LBTOXGR = '3';
    if        LBSTRESN < 0.8      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低钙血症';
  end;
  
  if LBSTNRHI ne . & LBSTNRHI < LBSTRESN then do;
    if LBSTNRHI < LBSTRESN <= 1.5 then LBTOXGR = '1';
    if      1.5 < LBSTRESN <= 1.6 then LBTOXGR = '2';
    if      1.6 < LBSTRESN <= 1.8 then LBTOXGR = '3';
    if      1.8 < LBSTRESN        then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高钙血症';    
  end;
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;

*** 10.LDH ***; 
if LBTESTCD eq 'LDH' and LBSTRESN ne . then do;
  if LBSTNRHI ne . & LBSTNRHI < LBSTRESN then do;
    LBTOXGR = '1';
    if LBTOXGR ne '' then LBTOX='血乳酸脱氢酶升高';    
  end;
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;

*** 11.MG ***; 
if LBTESTCD eq 'MG' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 1.2 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
    if 0.9 <= LBSTRESN < 1.2      then LBTOXGR = '2';
    if 0.7 <= LBSTRESN < 0.9      then LBTOXGR = '3';
    if        LBSTRESN < 0.7      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低镁血症';
  end;
  
  if LBSTNRHI ne . & LBSTNRHI < LBSTRESN then do;
    if LBSTNRHI < LBSTRESN <= 3 then LBTOXGR = '1';
    if        3 < LBSTRESN <= 8 then LBTOXGR = '3';
    if        8 < LBSTRESN      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高镁血症';      
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

if LBTESTCD eq 'MG' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 0.5 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
    if 0.4 <= LBSTRESN < 0.5      then LBTOXGR = '2';
    if 0.3 <= LBSTRESN < 0.4      then LBTOXGR = '3';
    if        LBSTRESN < 0.3      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低镁血症';
  end;

  if LBSTNRHI ne . & LBSTNRHI < LBSTRESN then do;
    if LBSTNRHI < LBSTRESN <= 1.23 then LBTOXGR = '1';
    if     1.23 < LBSTRESN <= 3.3  then LBTOXGR = '3';
    if     3.3  < LBSTRESN         then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高镁血症';      
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

*** 12.GLUC ***;
if LBTESTCD eq 'GLUC' and upcase(LBSTRESU) eq 'MMOL/L' and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 3.0 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if 2.2 <= LBSTRESN < 3.0       then LBTOXGR = '2';
    if 1.7 <= LBSTRESN < 2.2       then LBTOXGR = '3';
    if        LBSTRESN < 1.7       then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低糖血症';
  end;
  
  if .<LBSTRESN_GLUCBL < LBSTRESN & LBDY>1 & LBSTRESN>LBSTNRHI>. then do;
      LBTOXGR = '1';
      if LBTOXGR ne '' then LBTOX='高血糖症';
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

if LBTESTCD eq 'GLUC' and upcase(LBSTRESU) eq 'MG/DL' and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 55 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if 40 <= LBSTRESN < 55       then LBTOXGR = '2';
    if 30 <= LBSTRESN < 40       then LBTOXGR = '3';
    if       LBSTRESN < 30       then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低糖血症';
  end;
  
  if .<LBSTRESN_GLUCBL < LBSTRESN & LBDY>1 & LBSTRESN>LBSTNRHI>. then do;
      LBTOXGR = '1';
      if LBTOXGR ne '' then LBTOX='高血糖症';
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

*** 13.K ***;  
if LBTESTCD eq 'K' and upcase(LBSTRESU) in ('MEQ/L','MMOL/L') and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 3   <= LBSTRESN <LBSTNRLO  then LBTOXGR = '1';
    if 2.5 <= LBSTRESN < 3        then LBTOXGR = '3';
    if        LBSTRESN < 2.5      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低钾血症';
  end;

  if LBSTNRHI ne . & LBSTNRHI < LBSTRESN then do;
    if LBSTNRHI < LBSTRESN <= 5.5 then LBTOXGR = '1';
    if      5.5 < LBSTRESN <= 6.0 then LBTOXGR = '2';
    if      6.0 < LBSTRESN <= 7.0 then LBTOXGR = '3';
    if      7.0 < LBSTRESN        then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高钾血症';      
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

*** 14.SODIUM ***; 
if LBTESTCD eq 'SODIUM' and upcase(LBSTRESU) in ('MEQ/L','MMOL/L') and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 130 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
    if 120 <= LBSTRESN < 130      then LBTOXGR = '3';
    if        LBSTRESN < 120      then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='低钠血症';
  end;
  if LBSTNRHI ne . & LBSTNRLO=< LBSTRESN then do;
    if LBSTNRHI < LBSTRESN <= 150 then LBTOXGR = '1';
    if      150 < LBSTRESN <= 155 then LBTOXGR = '2';
    if      155 < LBSTRESN <= 160 then LBTOXGR = '3';
    if      160 < LBSTRESN        then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='高钠血症';      
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;


*** 15.UREA ***;
*** 16.APTT ***;  
if LBTESTCD eq 'APTT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . and LBSTNRHI ne . then do;
  if     LBSTNRHI < LBSTRESN <= 1.5*LBSTNRHI then LBTOXGR = '1';
  if 1.5*LBSTNRHI < LBSTRESN <= 2.5*LBSTNRHI then LBTOXGR = '2';
  if 2.5*LBSTNRHI < LBSTRESN                 then LBTOXGR = '3';
  if LBTOXGR ne '' then LBTOX='活化部分凝血活酶时间延长';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'APTT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . & LBSTNRHI>. then LBTOXGR = '0'; 

*** 17.PT ***;    
/*if LBTESTCD eq 'PT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . and LBSTNRHI ne . then do;*/
/*  if     LBSTNRHI < LBSTRESN <= 1.5*LBSTNRHI then LBTOXGR = '1';*/
/*  if 1.5*LBSTNRHI < LBSTRESN <= 2.0*LBSTNRHI then LBTOXGR = '2';*/
/*  if 2.0*LBSTNRHI < LBSTRESN                 then LBTOXGR = '3';*/
/*  if LBTOXGR ne '' then LBTOX='凝血酶原时间增加';*/
/*  if LBTOXGR eq '' then LBTOXGR = '0'; */
/*end;*/
/*else if LBTESTCD eq 'PT' and upcase(LBSTRESU) in ('SEC','S') and LBSTRESN ne . & LBSTNRHI>. then LBTOXGR = '0'; */

*** 18.INR ***;  
if LBTESTCD eq 'INR' and LBSTRESN ne . and LBSTNRHI ne . then do;
/*  if     LBSTNRHI < LBSTRESN <= 1.5*LBSTNRHI then LBTOXGR = '1';*/
/*  if 1.5*LBSTNRHI < LBSTRESN <= 2.5*LBSTNRHI then LBTOXGR = '2';*/
/*  if 2.5*LBSTNRHI < LBSTRESN                 then LBTOXGR = '3';*/
  if 1.2 < LBSTRESN <= 1.5 then LBTOXGR = '1';
  if 1.5 < LBSTRESN <= 2.5 then LBTOXGR = '2';
  if 2.5 < LBSTRESN        then LBTOXGR = '3';

  if LBTOXGR ne '' then LBTOX='INR增高';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'INR' and LBSTRESN ne . & LBSTNRHI>. then LBTOXGR = '0'; 



*** 19.CREATCLR ***;
if LBTESTCD eq 'CREATCLR' and upcase(LBSTRESU) eq 'ML/MIN' and .< LBSTRESN then do;
  if 60 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
  if 30 <= LBSTRESN < 60       then LBTOXGR = '2';
  if 15 <= LBSTRESN < 30       then LBTOXGR = '3';
  if       LBSTRESN < 15       then LBTOXGR = '4';
  if LBTOXGR ne '' then LBTOX='慢性肾脏疾病';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'CREATCLR' and upcase(LBSTRESU) eq 'ML/MIN' and .< LBSTRESN & LBSTNRHI>. then LBTOXGR = '0'; 



*** 20.HGB ***; 
if LBTESTCD eq 'HGB' and upcase(LBSTRESU) eq 'G/L' and .< LBSTRESN  then do;
  if LBSTNRLO ne . & LBSTRESN < LBSTNRLO then do;
    if  100 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if   80 <= LBSTRESN < 100       then LBTOXGR = '2';
    if        LBSTRESN < 80         then LBTOXGR = '3';
    if LBTOXGR ne '' then LBTOX='贫血';
  end;
 
  if LBSTNRHI ne . then do;
    if (LBSTNRHI > LBSTRESN_hgbbl or LBDY<=1) & LBSTNRHI < LBSTRESN then do;
      if      LBSTNRHI < LBSTRESN <= 20 + LBSTNRHI then LBTOXGR='1';
      if  20 + LBSTNRHI < LBSTRESN <= 40 + LBSTNRHI then LBTOXGR='2';
      if  40 + LBSTNRHI < LBSTRESN                 then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';
    end;
    if (LBSTRESN_hgbbl > LBSTNRHI and LBDY>1 ) & LBSTNRHI < LBSTRESN then do;
      if      LBSTRESN_hgbbl < LBSTRESN <= 20 + LBSTRESN_hgbbl then LBTOXGR='1';
      if  20 + LBSTRESN_hgbbl < LBSTRESN <= 40 + LBSTRESN_hgbbl then LBTOXGR='2';
      if  40 + LBSTRESN_hgbbl < LBSTRESN                       then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';      
    end;
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

if LBTESTCD eq 'HGB' and upcase(LBSTRESU) eq 'MMOL/L' and .< LBSTRESN  then do;
  if LBSTNRLO ne . & LBSTRESN < LBSTNRLO then do;
    if  6.2 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if  4.9 <= LBSTRESN < 6.2       then LBTOXGR = '2';
    if         LBSTRESN < 4.9         then LBTOXGR = '3';
    if LBTOXGR ne '' then LBTOX='贫血';
  end;
 
  if LBSTNRHI ne . then do;
    if (LBSTNRHI > LBSTRESN_hgbbl or lbblfl eq 'Y') & LBSTNRHI < LBSTRESN then do;
      if      LBSTNRHI < LBSTRESN  <= 1.2+ LBSTNRHI then LBTOXGR='1';
      if 1.2 + LBSTNRHI < LBSTRESN <= 2.5+ LBSTNRHI then LBTOXGR='2';
      if 2.5 + LBSTNRHI < LBSTRESN                 then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';
    end;
    if (LBSTRESN_hgbbl > LBSTNRHI and lbblfl ne 'Y') & LBSTRESN_hgbbl < LBSTRESN then do;
      if        LBSTRESN_hgbbl < LBSTRESN <= 1.2 + LBSTRESN_hgbbl then LBTOXGR='1';
      if  1.2 + LBSTRESN_hgbbl < LBSTRESN <= 2.5 + LBSTRESN_hgbbl then LBTOXGR='2';
      if  2.5 + LBSTRESN_hgbbl < LBSTRESN                       then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';      
    end;
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;

if LBTESTCD eq 'HGB' and upcase(LBSTRESU) eq 'G/DL' and .< LBSTRESN  then do;
  if LBSTNRLO ne . & LBSTRESN < LBSTNRLO then do;
    if  10 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if   8 <= LBSTRESN < 10       then LBTOXGR = '2';
    if        LBSTRESN < 8         then LBTOXGR = '3';
    if LBTOXGR ne '' then LBTOX='贫血';
  end;
 
  if LBSTNRHI ne . then do;
    if (LBSTNRHI > LBSTRESN_hgbbl or LBDY<=1) & LBSTNRHI < LBSTRESN then do;
      if      LBSTNRHI < LBSTRESN <= 2 + LBSTNRHI then LBTOXGR='1';
      if  2 + LBSTNRHI < LBSTRESN <= 4 + LBSTNRHI then LBTOXGR='2';
      if  4 + LBSTNRHI < LBSTRESN                 then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';
    end;
    if (LBSTRESN_hgbbl > LBSTNRHI and LBDY>1) & LBSTNRHI < LBSTRESN then do;
      if      LBSTRESN_hgbbl < LBSTRESN <= 2 + LBSTRESN_hgbbl then LBTOXGR='1';
      if  2 + LBSTRESN_hgbbl < LBSTRESN <= 4 + LBSTRESN_hgbbl then LBTOXGR='2';
      if  4 + LBSTRESN_hgbbl < LBSTRESN                       then LBTOXGR='3';
      if LBTOXGR ne '' then LBTOX='血红蛋白增高';      
    end;
  end;
  if LBTOXGR eq '' & LBSTNRHI>. then LBTOXGR = '0'; 
end;


*** 21.LYMLE ***; 
if LBTESTCD eq 'LYMLE' and LBSTRESU eq '%' and LBSTRESN ne . and LBSTRESN_wbc ne . then do;
  if LBSTNRLO ne . then do;
    if 0.8 <= ((LBSTRESN/100)*LBSTRESN_wbc) < (LBSTNRLO/100)*LBSTRESN_wbc  then LBTOXGR = '1';
    if 0.5 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 0.8                          then LBTOXGR = '2';
    if 0.2 <= ((LBSTRESN/100)*LBSTRESN_wbc) < 0.5                          then LBTOXGR = '3';
    if        ((LBSTRESN/100)*LBSTRESN_wbc) < 0.2                          then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='淋巴细胞计数降低'; 
  end;

  if LBSTRESN ne . & 4 < ((LBSTRESN/100)*LBSTRESN_wbc) then do;                                      
    if 4 < ((LBSTRESN/100)*LBSTRESN_wbc) <= 20 then LBTOXGR='2';                     
    if 20< ((LBSTRESN/100)*LBSTRESN_wbc)       then LBTOXGR='3';                      
    if LBTOXGR ne '' then LBTOX='淋巴细胞计数增高';    
  end ; 
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;

*** 22.LYM ***;
if LBTESTCD eq 'LYM' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then do;
  *if .< LBSTRESN < LBSTNRLO then do;
    if 0.8 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
    if 0.5 <= LBSTRESN < 0.8       then LBTOXGR = '2';
    if 0.2 <= LBSTRESN < 0.5       then LBTOXGR = '3';
    if        LBSTRESN < 0.2       then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='淋巴细胞计数降低';
  *end;
  
  if LBSTRESN >4 then do;
    if 4 < LBSTRESN <= 20 then LBTOXGR='2'; 
    if 20< LBSTRESN       then LBTOXGR='3'; 
    if LBTOXGR ne '' then LBTOX='淋巴细胞计数增高';    
  end ;
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;


*** 23.MONOLE ***;
*** 24.MONO ***;  
*** 25.NEUTLE ***;
if LBTESTCD eq 'NEUTLE' and LBSTRESU eq '%' and LBSTRESN ne . and LBSTNRLO ne . then do;
  if LBSTRESN_wbc ne . then do;
    if 1.5 <= (LBSTRESN/100)*LBSTRESN_wbc < (LBSTNRLO/100)*LBSTRESN_wbc  then LBTOXGR = '1';
    if 1.0 <= (LBSTRESN/100)*LBSTRESN_wbc < 1.5                          then LBTOXGR = '2';
    if 0.5 <= (LBSTRESN/100)*LBSTRESN_wbc < 1.0                          then LBTOXGR = '3';
    if        (LBSTRESN/100)*LBSTRESN_wbc < 0.5                          then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='中性粒细胞计数降低';
    if LBTOXGR eq '' then LBTOXGR = '0'; 
  end;
end;
else if LBTESTCD eq 'NEUTLE' and LBSTRESU eq '%' and LBSTRESN ne . then LBTOXGR = '0'; 

*** 26.NEUT ***;  
if LBTESTCD eq 'NEUT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . and LBSTNRLO ne . then do;
  if 1.5 <= LBSTRESN < LBSTNRLO  then LBTOXGR = '1';
  if 1.0 <= LBSTRESN < 1.5       then LBTOXGR = '2';
  if 0.5 <= LBSTRESN < 1.0       then LBTOXGR = '3';
  if        LBSTRESN < 0.5       then LBTOXGR = '4';
  if LBTOXGR ne '' then LBTOX='中性粒细胞计数降低';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'NEUT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then LBTOXGR = '0'; 

*** 27.PLAT ***;
if LBTESTCD eq 'PLAT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . and LBSTNRLO ne . then do;
  if  75 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
  if  50 <= LBSTRESN < 75       then LBTOXGR = '2';
  if  25 <= LBSTRESN < 50       then LBTOXGR = '3';
  if        LBSTRESN < 25       then LBTOXGR = '4';
  if LBTOXGR ne '' then LBTOX='血小板计数降低';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
else if LBTESTCD eq 'PLAT' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . & LBSTNRLO>. then LBTOXGR = '0'; 


*** 28.WBC ***; 
if LBTESTCD eq 'WBC' and upcase(LBSTRESU) in ('10*3/MM*3','X10^3/UL','10^9/L','10**3/MM**3') and LBSTRESN ne . then do;
  if LBSTNRLO ne . then do;
    if 3 <= LBSTRESN < LBSTNRLO then LBTOXGR = '1';
    if 2 <= LBSTRESN < 3        then LBTOXGR = '2';
    if 1 <= LBSTRESN < 2        then LBTOXGR = '3';
    if      LBSTRESN < 1        then LBTOXGR = '4';
    if LBTOXGR ne '' then LBTOX='白细胞数降低';
    if LBTOXGR eq '' then LBTOXGR = '0'; 
  end;

  if LBSTRESN > 100 then do; LBTOXGR='3'; LBTOX='白细胞增多'; end;
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;
 
*** 29.PREG ***;     
*** 30.HCG ***;      
*** 31.UPREG ***;    
*** 32.UHGB ***;     
*** 33.UGLUC ***;    
*** 34.UPROT ***;  
if LBTESTCD eq 'UPROT' and LBCAT eq 'URINALYSIS' & LBORRES>'' then do;
  if strip(upcase(LBORRES)) in ('+1','1+','+','POSITIVE') then LBTOXGR = '1';
  if strip(upcase(LBORRES)) in ('+2','2+','++','+3','3+','+++') then LBTOXGR = '2';
  if strip(upcase(LBORRES)) in ('+4','4+','++++') then LBTOXGR = '3';
  if strip(upcase(LBORRES)) in ('0','-','+/-','NEGATIVE','NEG','TRACES','TRACE','ABSENT','NOT DETE') then LBTOXGR = '0';

  if LBTOXGR ne '' then LBTOX='尿蛋白';
 *if LBTOXGR eq '' then LBTOXGR = '0'; 
end;

*** 35.SEDEXAM ***;  
*** 36.PROTCRT ***;  
if LBTESTCD eq 'PROTCRT' and LBCAT eq 'URINALYSIS' and upcase(LBSTRESU) in( 'MG/MG', 'RATIO') and LBSTRESN ne . then do;
  if (LBSTRESN > 0.5) then LBTOXGR = '1';
  if LBTOXGR ne '' then LBTOX='慢性肾脏疾病';
  if LBTOXGR eq '' then LBTOXGR = '0'; 
end;

/*  if LBSTRESN>. & LBSTNRLO>. & LBTESTCD in("ALB" "ALP" "ALT" "AMYLASE" "APTT" "AST" "BILI" "CA" "CHOL" "CK" "CREAT" "CREATCLR" "FIBRINO" "GFR" */
/*    "GGT" "GLUC" "HGB" "INR" "K" "LIPASE" "LYM" "LYMLE" "MG" "NEUT" "NEUTLE" "PHOS" "PLAT" "PROT" "PROTCRT" "PT" "PTT" "TRIG" "SODIUM" "URATE" "WBC") */
/*    & LBTOX='' and LBTOXGR='' then do;   LBTOXGR = '0'; LBTOX='Grade 0';  end;*/

if LBTOXGR = '0' then LBTOX='Grade 0';

if LBTOX='Grade 0' then do ; LBTOXGR = '' ; LBTOX='' ; end ;

run ;

%mend ;
