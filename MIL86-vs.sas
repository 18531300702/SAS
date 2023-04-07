PROC DELETE DATA=WORK._ALL_; RUN;

/*使用转置来写*/
/*PROC SORT DATA=CDM.VS2 OUT=VS2;*/
/*    BY SUBJID VISIT VSTPT VSDAT VSTIM;*/
/*    WHERE SUBJSTA^="筛选失败";*/
/*RUN;*/
/*PROC TRANSPOSE DATA=VS2 OUT=VS_TMP_01;*/
/*     BY SUBJID VISIT VSTPT VSDAT VSTIM;*/
/*     VAR VSORRES1 VSORRES2 VSORRES3 VSORRES4 VSORRES5 ;*/
/*RUN;*/
/**/
/*PROC TRANSPOSE DATA=VS2 OUT=VS_TMP_02;*/
/*     BY SUBJID VISIT VSTPT VSDAT VSTIM;*/
/*     VAR VSORRES1_UNIT VSORRES2_UNIT VSORRES3_UNIT VSORRES4_UNIT VSORRES5_UNIT ;*/
/*RUN;*/
/**/
/*PROC SQL NOPRINT;*/
/*    CREATE TABLE VS_TMP_02_01 AS*/
/*        SELECT A.*,B.COL1 AS UNIT*/
/*            FROM VS_TMP_01 AS A LEFT JOIN VS_TMP_02 AS B*/
/*                ON A.SUBJID=B.SUBJID AND A.VISIT=B.VISIT AND A.VSTPT=B.VSTPT AND A.VSDAT=B.VSDAT AND A.VSTIM=B.VSTIM;*/
/*QUIT;*/

data vs1;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs1;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    
    if VSTEST="收缩压" then VSTESTCD="SYSBP";
    if VSTEST="舒张压" then VSTESTCD="DIABP" ;
    if VSTEST="体温" then VSTESTCD="TEMP";
    if VSTEST="脉搏" then VSTESTCD="PULSE"; 
    if VSTEST="呼吸" then VSTESTCD="RESP"; 
    if VSTEST="身高" then VSTESTCD="HEIGHT";
    if VSTEST="体重" then VSTESTCD="WEIGHT";
    if VSTEST="体重指数" then VSTESTCD="BMI";   
    if VSTEST="生命体征" then VSTESTCD="VSALL";

    VSSTRESC=VSORRES_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    if VSORRES ^="" then  output;
    keep STUDYID USUBJID VSTEST VSTESTCD VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  SUBJID VISIT ;
run;
proc sort data=vs1 out=vs1_sort;
    by SUBJID  VISIT ;
run;
proc sort data=cdm.VSPERF out=VSPERF_sort;
    by SUBJID  VISIT ;
run;

/*为了计算VSDTC和VSREASND */
data vs1_new;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    merge vs1_sort(in=a) VSPERF_sort;
    by subjid visit;
    if a;
    VSDTC=VSDAT_RAW;

    keep STUDYID USUBJID VSTEST VSTESTCD VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND SUBJID VISIT VSDTC;
run;

data vs2_res1;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs2;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));*有问题;
    VSORRES=VSORRES1;
    VSORRESU=VSORRES1_UNIT;
    VSSTRESC=VSORRES1_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="收缩压" ;
    VSTPTNUM=VSTPT_STD;

    /*VSDTC*/
    if not missing(VSTIM_RAW) then VSDTC=strip(VSDAT_RAW)||"T"||strip(VSTIM_RAW);
    else VSDTC=strip(VSDAT_RAW);

    if VSTEST="收缩压" then VSTESTCD="SYSBP";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC VISIT VSTPT VSTPTNUM;
    if VSORRES ^="" then  output;
run;


data vs2_res2;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs2;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=VSORRES2;
    VSORRESU=VSORRES2_UNIT;
    VSSTRESC=VSORRES2_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="舒张压" ;
    if VSTEST="舒张压" then VSTESTCD="DIABP" ;
    VSTPTNUM=VSTPT_STD;
    /*VSDTC*/
    if not missing(VSTIM_RAW) then VSDTC=strip(VSDAT_RAW)||"T"||strip(VSTIM_RAW);
    else VSDTC=strip(VSDAT_RAW);
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC visit VSTPT VSTPTNUM;
    if VSORRES ^="" then  output;
run;



data vs2_res3;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs2;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=VSORRES3;
    VSORRESU=VSORRES3_UNIT;
    VSSTRESC=VSORRES3_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="体温" ;
    VSTPTNUM=VSTPT_STD;
    if VSTEST="体温" then VSTESTCD="TEMP";
        /*VSDTC*/
    if not missing(VSTIM_RAW) then VSDTC=strip(VSDAT_RAW)||"T"||strip(VSTIM_RAW);
    else VSDTC=strip(VSDAT_RAW);
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC visit VSTPT VSTPTNUM;
    if VSORRES ^="" then  output;
run;
data vs2_res4;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs2;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=VSORRES4;
    VSORRESU=VSORRES4_UNIT;
    VSSTRESC=VSORRES4_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="脉搏";
    VSTPTNUM=VSTPT_STD;
    if VSTEST="脉搏" then VSTESTCD="PULSE";
       /*VSDTC*/
    if not missing(VSTIM_RAW) then VSDTC=strip(VSDAT_RAW)||"T"||strip(VSTIM_RAW);
    else VSDTC=strip(VSDAT_RAW); 
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC visit VSTPT VSTPTNUM;
    if VSORRES ^="" then  output;
run;

data vs2_res5;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.vs2;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=VSORRES5;
    VSORRESU=VSORRES5_UNIT;
    VSSTRESC=VSORRES5_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="呼吸";
    if VSTEST="呼吸" then VSTESTCD="RESP"; 
    VSTPTNUM=VSTPT_STD;
        /*VSDTC*/
    if not missing(VSTIM_RAW) then VSDTC=strip(VSDAT_RAW)||"T"||strip(VSTIM_RAW);
    else VSDTC=strip(VSDAT_RAW);
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC visit VSTPT VSTPTNUM;
    if VSORRES ^="" then  output;
run;

data vs2; /*每个res有874条*/
    set vs2_res1-vs2_res5;
/*    if VSORRES ="" then  output;*/
run;

data weight;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.we;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=WEIGHT;
    VSORRESU=WEIGHT_UNIT;
    VSSTRESC=WEIGHT_RAW;;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="体重";
    if VSTEST="体重" then VSTESTCD="WEIGHT";
    VSDTC=WEDAT_RAW;
    VSREASND=WEREASND;
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU VSREASND VSDTC  VISIT;
    if VSORRES ^="" then  output;
run;

data dm_height;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.dm;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=height;
    VSORRESU=height_UNIT;
    VSSTRESC=height_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="身高";
    if VSTEST="身高" then VSTESTCD="HEIGHT";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU   VISIT;
    if VSORRES ^="" then  output;
run;

data dm_weight;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40;
    set cdm.dm;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=WEIGHT;
    VSORRESU=WEIGHT_UNIT;
    VSSTRESC=WEIGHT_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="体重";
    if VSTEST="体重" then VSTESTCD="WEIGHT";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VISIT;
    if VSORRES ^="" then  output;
run;

data dm_bmi;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40 ;
    set cdm.dm;
    STUDYID = "MIL86-CT201";
    DOMAIN = "VS";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
    VSORRES=BMI;
    VSORRESU=BMI_UNIT;
    VSSTRESC=BMI_RAW;
    VSSTRESN=VSORRES;
    VSSTRESU=VSORRESU;
    VSTEST="体重指数";
    if VSTEST="体重指数" then VSTESTCD="BMI";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VISIT;
    if VSORRES ^="" then  output;
run;

data height_weight_bmi;
    set dm_bmi dm_weight dm_height;
run;
proc sort data= height_weight_bmi;
    by USUBJID VISIT ;
run;

/*为了计算VSDTC*/
data sv;
    set cdm.SV;
    STUDYID = "MIL86-CT201";
    USUBJID=strip(strip(studyid)||"-"||substr(subjid,2,5));
run;

proc sort data= sv;
    by USUBJID VISIT ;
run;
data hwb;
    merge height_weight_bmi(in=a) sv(drop= studyid);
    by USUBJID VISIT;
    if a;
    VSDTC=VISDAT_RAW;
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VISIT VSDTC;
run;
data all;
    length  VSORRESU $20 VSSTRESC $200 VSTESTCD $8 vstest $40 visit $40 VSDTC $20;
    retain  studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT;
    set vs1_new vs2 weight hwb;

    if VSORRES ="" then  VSSTAT="未做";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT VSREASND VSDTC visit VSTPT VSTPTNUM;
run;

proc sort data=all;
    by USUBJID VISIT VSDTC;
run;

/*为了计算 VSBLFL */
data dm;
    set sdtm.dm;
/*    keep usubjid rfstdtc;*/
run;

proc sort data =dm;
    by usubjid;
run;

/*VSBLFL*/
data vs_01;
    merge all(in=a) dm(drop=studyid);
    by usubjid ;
    if  rfstdtc ^="" & vsdtc ^="" & vsdtc<=rfstdtc then fl=1;
    if a;  
    vsdtc_=substr(vsdtc,1,10);
run; 


proc sort data=vs_01;
    by usubjid  vstestcd fl vsdtc_;
run;



data vs_02;
    set vs_01;
        by usubjid  vstestcd fl vsdtc_;
    if last.fl and fl=1 then vsblfl="Y";
    if vsdtc ^=""and rfstdtc^="" then vsdy =input(scan(vsdtc,1,'T'),yymmdd10.)-input(rfstdtc,yymmdd10.)+(input(scan(vsdtc,1,'T'),yymmdd10.)>=input(rfstdtc,yymmdd10.));
    IF visit="提前退出访视" then visit="提前退出";
    keep studyid usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT VSREASND VSDTC VISIT VSBLFL VSDY VSTPT VSTPTNUM ;
run;
proc sort data= vs_02;
    by visit;
run;
/*VISITNUM*/
proc sort data=SDTM.TV out=tv;
    by  visit;
run;   

data vs_03;
    merge vs_02(in=a) TV(drop=studyid);
    by  visit;
    if a;
    DOMAIN = "VS";
    if  VSTESTCD="TEMP" then VSORRESU= "C"; 
    if  VSTESTCD="BMI" then VSORRESU= "kg/m2"; 
    VSSTRESU=VSORRESU;
    keep studyid DOMAIN usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT VSREASND VSDTC VISIT VSBLFL VISITNUM VSDY VSTPT VSTPTNUM;
run;

proc sort data=vs_03;
    by  usubjid;
run;  
/*EPOCH*/
data se;
    set sdtm.se;
    by usubjid;
    if last.usubjid then las_fl=1;
run;

proc sort data=se ;
    by usubjid las_fl;
run;

/*PROC SQL;*/
/*    CREATE TABLE vs_04 AS*/
/*        SELECT A.*,B.EPOCH,SESTDTC,SEENDTC,las_fl*/
/*            FROM vs_03 AS A LEFT JOIN SE AS B*/
/*               ON A.USUBJID=B.USUBJID;*/
/*QUIT;*/
/*proc sort data=vs_04; */
/*    by usubjid las_fl; */
/*run;*/

/*data vs_05;*/
/*    set vs_04;*/
/*    if epoch = "筛选期" & scan(vsdtc,1,'T') <scan(SEENDTC,1,'T') then flag = "Y";*/
/*    if epoch = "治疗期" & scan(SESTDTC,1,'T')<=scan(vsdtc,1,'T')<=scan(SEENDTC,1,'T') then flag = "Y";*/
/*    IF flag = "Y" THEN OUTPUT;*/
/*    */
/*    keep usubjid  VSDTC epoch;*/
/*run;*/


proc sql noprint;
  create table vs_04 as
   select  distinct a.USUBJID, a.VSDTC, b.epoch, b.SESTDTC, B.SEENDTC
     from vs_03 as a, se as b
       where a.usubjid=b.usubjid and sestdtc<=scan(vsdtc,1,'T')<=seendtc;
quit; 

proc sort data=vs_04;
    by  USUBJID  VSDTC epoch ;
run;

data vs_05;
   set vs_04;
   by  USUBJID  VSDTC epoch ;
   if first.vsdtc;
run;
 proc sort data=vs_03;
     by USUBJID  VSDTC;
run;

data vs_06;
    merge vs_03 vs_05;
    by USUBJID  VSDTC;
run;



proc sort data=vs_06;
    by  USUBJID  VSTESTCD  VISITNUM VSTPTNUM VSDTC ;
run;

data vs_06;
    retain studyid DOMAIN usubjid vsseq vstestcd vstest  VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT VSREASND VSBLFL VISITNUM VISIT epoch VSDTC   VSDY VSTPT VSTPTNUM  ;
    set vs_06 ;
        by  USUBJID VSTESTCD VISITNUM VSTPTNUM VSDTC  ;
    if first.USUBJID  then vsseq=0;
        vsseq+1;
    keep studyid DOMAIN usubjid vstest vstestcd VSORRES VSORRESU VSSTRESC VSSTRESN VSSTRESU  VSSTAT VSREASND VSBLFL VISITNUM VSDTC VISIT   VSDY VSTPT VSTPTNUM epoch vsseq;
/*    if visit="提前退出访视" then output;*/
run;

***************************测试用**************************;
data test_vs01 ;
    set vs_06(firstobs=3   obs=3 );
run;
data test_vs02 ;
    set sdtm.vs(firstobs=19 obs=19 );
run;

data test_vs_06;
    set vs_06(where=(usubjid="MIL86-CT201-01001"));
run;

data test_sdtm ;
    set sdtm.vs(where=(usubjid="MIL86-CT201-01001"));
run;
*************************************************************;


proc compare data=sdtm.vs compare=vs_06 crit=0.00001;
run;


data vs;
    set sdtm.vs;
    if VISIT ="提前退出" then  output;
        if VSORRES ="" then  output;
run;
proc sort data=vs;
    by vstest;
run;

