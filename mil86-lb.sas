PROC DELETE DATA=_ALL_;RUN;

/*LBALL1-LBALL7*/
DATA LBALL1;
    LENGTH LBCAT $100 LBTEST $40 ;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_BD" ;
    LBTEST="实验室数据-血常规";
    LBTESTCD="LBALL1";
    LBCAT="血常规";
RUN;

DATA LBALL2;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_CHEM" ;
    LBTEST="实验室数据-血生化";
    LBTESTCD="LBALL2";
    LBCAT="血生化";
RUN;
            
DATA LBALL3;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND (FORMOID="LB_BL1" OR FORMOID="LB_BL2") ;
    LBTEST="实验室数据-血脂七项";
    LBTESTCD="LBALL3";
    LBCAT="血脂七项";
RUN;

DATA LBALL4;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_UR" ;
    LBTEST="实验室数据-尿常规";
    LBTESTCD="LBALL4";
    LBCAT="尿常规";
RUN;

DATA LBALL5;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_COA" ;
    LBTESTCD="LBALL5";
    LBTEST="实验室数据-凝血功能";
    LBCAT="凝血功能";
RUN;

DATA LBALL6;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_SCR" ;
    LBTEST="实验室数据-血清病毒学";
    LBTESTCD="LBALL6";
    LBCAT="血清病毒学";
RUN;

DATA LBALL7;
    LENGTH LBCAT $100 LBTEST $40;
    SET CDM.LBPERF;
    IF LBPERF="否" AND FORMOID="LB_THY";
    LBTEST="实验室数据-甲状腺功能";
    LBTESTCD="LBALL7";
    LBCAT="甲状腺功能";
RUN;

DATA LBALL1_7;
    SET LBALL1-LBALL7;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES="";LBORNRLO=""; LBORNRHI="";LBNRIND=""; LBORRESU="";
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND LBPERF VISIT;
RUN;


DATA LBPERF_LEFT;
    SET CDM.LBPERF;
    IF  (LBPERF^="否" OR FORMOID^="LB_BD") AND ( LBPERF^="否" OR FORMOID^="LB_CHEM" )  AND
        (LBPERF^="否" OR (FORMOID^="LB_BL1" AND FORMOID^="LB_BL2")) AND (LBPERF^="否" OR FORMOID^="LB_UR") AND
        (LBPERF^="否" OR FORMOID^="LB_COA" ) AND (LBPERF^="否" OR FORMOID^="LB_SCR") AND (LBPERF^="否" OR FORMOID^="LB_THY")
        THEN OUTPUT;
RUN;

DATA LBALL;
    SET LBPERF_LEFT;
    LBTEST=FORMNM;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES ="";LBORRESU="";LBORNRLO=""; LBORNRHI=""; LBNRIND="";
    IF LBPERF="否" THEN OUTPUT;
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT;
 RUN;

/*LBPERF_LEFT为LBPERF去掉LBALL1_7后剩下的观测*/
DATA GM;
    SET CDM.GM;
    length lbcat$100;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBSPID=COMPRESS("GM-"||SUBSTR(RECREP,1,LENGTH(RECREP)));
    LBTEST="基因检测";
    LBORRES=""; LBORRESU=""; LBORNRLO=""; LBORNRHI=""; LBNRIND="";
    lbdtc=GMDAT_RAW;
    lbcat="基因检测";
    IF GMPERF="否" THEN LBperf="未做";
    lbreasnd=GMREASND;
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbdtc lbcat LBSPID LBperf lbREASND ;
RUN;

/*血脂七项*/

PROC IMPORT OUT= SASUSER.LB_BL_EXTERNAL 
            DATAFILE= "C:\PROJECT\MIL86_CT201\BIOSTATISTICS\DATA\EXTERNAL\MIL86-CT201_血脂七项.XLSX" 
            DBMS=EXCEL REPLACE;
     RANGE="SHEET1$A2:W1471"; 
     GETNAMES=NO;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
DATA LB_BL_EXTERNAL;
    RETAIN USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND LBDTC VISTOID LBSPEC LBSPCCND;
    LENGTH LBNRIND $100 LBORRES $200 LBTEST $40 VISIT $100 LBORNRLO $100;
    FORMAT VISIT$100.;
    SET SASUSER.LB_BL_EXTERNAL ;
    length lbcat $100;
    STUDYID=F2;SUBJID=F7;LBTEST=F17;VISTOID= F12;LBDTC1=F13;
    LBDTC=COMPRESS(SUBSTR(LBDTC1,1,10)||"T"||SUBSTR(LBDTC1,11,6));
    LBSPEC=F14;
    LBSPCCND=F15;
        IF LBTEST="低密度脂蛋白胆固醇(LDL-CH)" THEN LBTEST="低密度脂蛋白胆固醇";
        IF LBTEST="高密度脂蛋白胆固醇(HDL-CH)" THEN LBTEST="高密度脂蛋白胆固醇";
        IF LBTEST="脂蛋白(a)" THEN LBTEST="脂蛋白（a）";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES =F19;LBORRESU=F20;LBORNRLO=F22;LBORNRHI=F23;
    lbcat="血脂七项";
    if lborres="" then do LBORNRLO="";LBORNRHI="";end;
    IF LBORRES >LBORNRHI THEN LBNRIND ="高";
    ELSE IF LBORRES <LBORNRLO THEN LBNRIND ="低";
    ELSE  LBNRIND ="正常";

    IF LBORNRHI="" OR LBORNRLO="" THEN LBNRIND =""; 
    DROP F2 F7 F17 F19 F20 F22 F23;
   
/*    VISIT 和VISITOID的对应*/
    IF      VISTOID="V1"  THEN VISIT= "筛选导入期（D-42~D-1）";
    ELSE IF VISTOID="V2"  THEN VISIT=  "治疗期（D0）";
    ELSE IF VISTOID="V3" THEN VISIT= "治疗期第2周（D14）";
    ELSE IF VISTOID="V4" THEN VISIT=  "治疗期第4周（D28）" ;
    ELSE IF VISTOID="V5" THEN VISIT= "治疗期第8周（D56）";
    ELSE IF VISTOID="V6" THEN VISIT= "治疗期第12周（D84）" ;
    ELSE IF VISTOID="V7"  THEN VISIT="治疗期第16周（D112）";
    ELSE IF VISTOID="V8"  THEN VISIT= "治疗期第20周（D140）" ;
    ELSE IF VISTOID="V9"  THEN VISIT= "治疗期第24周（D168）";
    ELSE VISIT=VISTOID;
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND LBDTC VISIT LBSPEC LBSPCCND LBDTC lbcat ;

RUN;


DATA LB_BL_RAW;
    LENGTH LBNRIND $100 LBORRES $200 LBTEST $40 VISTOID $100 LBORNRLO $100;
    FORMAT LBNRIND $100. VISTOID $100.;
    SET CDM.LB_BL(DROP=LBORRES);
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBSPCCND="";  LBSPEC="";
    if LBORRES_RAW="不适用" then LBNAM="";
    LBORRES=LBORRES_RAW; 

    IF LBNRIND="0" THEN LBNRIND ="正常";
    IF LBNRIND="1" OR  LBNRIND="3" THEN LBNRIND="高";
    IF LBNRIND="2" OR  LBNRIND="4" THEN LBNRIND="低";

    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT LBNAM LBSPEC LBSPCCND lbclsig lbclsigtxt;
RUN;
PROC SORT DATA=LB_BL_RAW ; *882个观测;
    BY USUBJID VISIT lbtest;
RUN;
PROC SORT DATA= LB_BL_EXTERNAL out=LB_BL_EXTERNAL_sorted ; *1470个观测;
    BY USUBJID VISIT lbtest ;
RUN;

DATA LB_BL;*这一步是为了获得所有的血脂七项的数据  LB_BL_EXTERNAL和LB_BL_RAW中有重复的数据;
    MERGE LB_BL_EXTERNAL_sorted(in=a rename=(lborres=lborres_1 LBORNRLO =LBORNRLO_1 )) LB_BL_RAW(in=b rename=(lborres=lborres_2 LBORNRLO =LBORNRLO_2 ));
    BY USUBJID VISIT lbtest  ;
    LBDAT=SUBSTR(LBDTC,1,10);
    if lborres_2^="" and lborres_2^="不适用" then lborres=lborres_2;
    else lborres=lborres_1;

    if LBORNRLO_1^="" then LBORNRLO=LBORNRLO_1;
    else LBORNRLO=LBORNRLO_2;

    if (usubjid="MIL86-CT201-06028" and visit="治疗期（D0）" ) then do; LBSPEC="血清"; LBSPCCND="无肉眼可见异常";end;

    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT LBNAM LBSPEC LBSPCCND LBDAT lbdtc lbclsig lbclsigtxt;
RUN;

/*DATA LB_BL_1;*这一步是为了获得所有的血脂七项的数据  LB_BL_EXTERNAL和LB_BL_RAW中有重复的数据;*/
/*    MERGE LB_BL_EXTERNAL_sorted(in=a drop= lborres lborresu  LBORNRLO LBORNRHI lbnrind lbspec lbspccnd) LB_BL_RAW;*/
/*    BY USUBJID VISIT lbtest;*/
/*    LBDAT=SUBSTR(LBDTC,1,10);*/
/*    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT LBNAM LBSPEC LBSPCCND LBDAT lbdtc;*/
/*RUN;*/


PROC SORT DATA= LB_BL;
    BY USUBJID VISIT LBDAT;
RUN;

DATA LBPERF(RENAME=(LBDTC=LBDAT));
    LENGTH LBCAT LBREASND $200  ;
    RETAIN USUBJID VISIT  LBCAT  LBPERF LBREASND LBDTC;
    SET CDM.LBPERF;
    LBCAT=FORMNM;
    LBDTC=LBDAT_RAW;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    if lbcat="血脂七项（给药前）" then lbcat="血脂七项";
    if lbcat="甲状腺功能检查" then lbcat="甲状腺功能";
    if lbcat="血清病毒学筛查" then lbcat="血清病毒学";

    IF VISIT="提前退出访视" THEN VISIT ="提前退出";
    IF LBPERF^="不适用" AND (LBCAT="血脂七项" )  THEN OUTPUT;
    KEEP USUBJID VISIT  LBCAT  LBPERF LBREASND LBDTC VISIT;
RUN;
PROC SORT DATA= LBPERF;
    BY USUBJID VISIT LBDAT;
RUN;

DATA LB_BL_01;
    MERGE LB_BL(IN=B) LBPERF(IN=A);
    BY USUBJID VISIT LBDAT ;
    IF  A AND B;
RUN;

DATA LB_BL_02;
    MERGE LB_BL(WHERE=(LBDAT="") IN=B) LBPERF(IN=A);
    BY USUBJID VISIT ;
    IF  B;
RUN;

DATA LB_BL_TOTAL;
    SET LB_BL_01 LB_BL_02;
/*   keep lbclsig lbclsigtxt usubjid;*/
RUN;




/*PROC SQL ;*/
/*    CREATE TABLE LB_BL AS*/
/*        SELECT A.*, B.LBNRIND,B.LBSPEC,B.LBSPCCND */
/*            FROM LB_BL_EXTERNAL(DROP=LBNRIND ) AS A LEFT JOIN LB_BL_RAW AS B */
/*                ON A.USUBJID=B.USUBJID AND A.VISTOID=B.VISTOID*/
/*                    ORDER BY USUBJID, VISTOID;*/
/*QUIT;*/

%MACRO MACRO2(DATASET);
    DATA &DATASET;
        LENGTH  LBORRES $200  LBTEST $40 LBNRIND $100 LBORNRLO $100;
        FORMAT LBNRIND $100.;
        SET CDM.&DATASET(DROP=LBORRES);
        STUDYID="MIL86-CT201";
        USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
        LBORRES=LBORRES_RAW;
        if lborres="" then do LBORNRLO="";LBORNRHI="";end;
/*LBNRIND*/
        FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1);
        IF       FLAG=1 AND LBORRES ^="" AND LBORNRHI^="" AND INPUT(LBORRES,BEST.) >INPUT(LBORNRHI,BEST.) THEN LBNRIND ="高";
        ELSE IF  FLAG=1 AND LBORRES ^="" AND LBORNRLO^="" AND INPUT(LBORRES,BEST.) <INPUT(LBORNRLO,BEST.) THEN LBNRIND ="低";
        ELSE IF  FLAG=1 THEN  LBNRIND ="正常";


        IF LBORRES^="不适用" THEN OUTPUT;
        KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbnam lbclsig lbclsigtxt;
    RUN;
%MEND;

%MACRO2(LB_THY);
%MACRO2(LB_CRP);
%MACRO2(LB_BD);
%MACRO2(LB_COA)


DATA LB_HBV;
 LENGTH  LBORRES $200  LBTEST $40 LBNRIND $100 LBORNRLO $100;
        FORMAT LBNRIND $100.;
        SET CDM.LB_HBV(DROP=LBORRES);
        STUDYID="MIL86-CT201";
        USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
        LBORRES=LBORRES_RAW;
        if lborres="" then do LBORNRLO="";LBORNRHI="";end;
/*LBNRIND*/
                                             FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1);
        IF       FLAG=1 AND LBORRES ^="" AND LBORNRHI^="" AND INPUT(LBORRES,BEST.) >INPUT(LBORNRHI,BEST.) THEN LBNRIND ="高";
        ELSE IF  FLAG=1 AND LBORRES ^="" AND LBORNRLO^="" AND INPUT(LBORRES,BEST.) <INPUT(LBORNRLO,BEST.) THEN LBNRIND ="低";
        ELSE IF  FLAG=1 THEN  LBNRIND ="正常";

        IF LBORRES^="不适用" THEN OUTPUT;
        KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbnam lbclsig lbclsigtxt;
RUN;
    


DATA LB_CHEM;
        LENGTH  LBORRES $200   LBTEST $40 LBNRIND $100 LBORNRLO $100 ;
        FORMAT LBNRIND $100.;
        SET CDM.LB_CHEM(drop=lborres);
        STUDYID="MIL86-CT201";
        USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
        lborres=lborres_raw;
        if lborres="" then do LBORNRLO="";LBORNRHI="";end;
/*LBNRIND*/
        FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1) ;
        IF       FLAG=1 AND LBORRES ^="" AND LBORNRHI^="" AND INPUT(LBORRES,BEST.) >INPUT(LBORNRHI,BEST.) THEN LBNRIND ="高";
        ELSE IF  FLAG=1 AND LBORRES ^="" AND LBORNRLO^="" AND INPUT(LBORRES,BEST.) <INPUT(LBORNRLO,BEST.) THEN LBNRIND ="低";
        ELSE IF  FLAG=1 THEN  LBNRIND ="正常";


        IF  LBTEST="肌酐清除率" AND LBORRES ="" THEN DELETE;
        IF  LBORRES_RAW^="不适用" THEN OUTPUT;
        KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbnam lbclsig lbclsigtxt;
RUN;




DATA LB_UR1;
    LENGTH  LBORRES lborreso LBAENO lbclsig lborreso lbrel LBAENO LBMHNO $200   LBTEST $40 LBNRIND $100 LBORNRLO $100;
    FORMAT LBNRIND $100.;
    SET CDM.LB_UR1(DROP=LBORRES LBREL);
         LBORRES=LBORRES_RAW;
/*       lborres已定义为字符型和数值型，是为什么啊? 是因为数据集里面原来就有lborres 而他是数值型的，你又把他赋值成了字符型的，所以会报错，*/
/*       应该先将原来的lborres drop 掉*/
        STUDYID="MIL86-CT201";
        USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));

        if (lbtest="透明管型" or lbtest="病理管型") and LBORRES_raw ^="" and LBORRES_RAW^="不适用" then lborres=lborres_raw;
        if (lbtest="透明管型" or lbtest="病理管型") and (LBORRES_raw =""  or  LBORRES_RAW="不适用" ) then lborres=lborres1;
        if lborres="未做" then do; lborres="";lbperf="未做";end;
        if lborres="" then do LBORNRLO="";LBORNRHI="";lbperf="未做";end;
/*LBNRIND*/
        FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1);
        IF       FLAG=1 AND LBORRES ^="" AND LBORNRHI^="" AND INPUT(LBORRES,BEST.) >INPUT(LBORNRHI,BEST.) THEN LBNRIND ="高";
        ELSE IF  FLAG=1 AND LBORRES ^="" AND LBORNRLO^="" AND INPUT(LBORRES,BEST.) <INPUT(LBORNRLO,BEST.) THEN LBNRIND ="低";
        ELSE IF  FLAG=1 THEN  LBNRIND ="正常";
        IF LBORNRLO="" AND  LBORNRHI="" THEN LBNRIND="";
        lbclsig=lbclsigc;
        lborreso=lbresoth;
/*        lbrel*/
        if lbrel_raw="1" then lbrel="Y" ;
        if lbrel_raw="0" then lbrel="N"; 

        IF LBTEST="尿白细胞" THEN LBTEST="尿白细胞计数";
        KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbperf lbnam lbclsig lborreso lbrel LBMHNO LBAENO;
RUN;



/*LB_HCG*/
DATA LB_HCG;
    SET CDM.LB_HCG(drop=lbdat);
    length lbcat LBREASND $200 ;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES=LBORRES2;
    LBTEST="血妊娠";
    LBORRESU=""; LBORNRLO=""; LBORNRHI="";LBNRIND="";
    LBDTC=lbdat_raw;
    lbcat="血妊娠";
    IF LBORRES^="不适用" THEN OUTPUT;
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbcat LBREASND LBPERF LBDTC ;
RUN;
DATA UNS;
    SET CDM.UNS;
    length lbclsig lbdesc LBAENO  lbmhno $200;
    format lbclsig lbdesc LBAENO lbmhno $200.;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES=UNSORRES;
    LBTEST=UNSTEST;
    LBORRESU=UNSORRESU;
    LBORNRLO=""; LBORNRHI="";LBNRIND="";

    lbclsig=UNSCLSIG;
    lbdesc=UNSSPEC;
    lbrel=rel_raw;
    LBMHNO=MHNO;
    LBAENO=AENO;
/*        lbrel*/
        if lbrel_raw="1" then lbrel="Y" ;
        if lbrel_raw="0" then lbrel="N"; 

    IF LBORRES^="不适用" THEN OUTPUT;
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbclsig lbdesc lbrel LBAENO LBMHNO;
RUN;

DATA LB_SCR;
    SET CDM.LB_SCR;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBORRES=LBORRESD;
    LBTEST=LBTEST_BP;
    LBORNRLO=""; LBORNRHI="";LBNRIND=""; LBORRESU="";
    lbclsig=LBCLSIG1;
    IF LBORRES^="不适用" THEN OUTPUT;
    
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbclsig lbdesc;
RUN;

DATA LB_UR;
    LENGTH LBNRIND $ 100 LBORRES lborreso lbclsig lborreso lbrel LBAENO LBMHNO $200 LBORNRLO  $100;
    FORMAT LBNRIND $ 100.;
    SET CDM.LB_UR(rename=(LBORRES=LBORRES_ )drop=lbrel);

    IF LBTEST="比重"  THEN LBORRES=LBORRES_RAW;
    ELSE LBORRES=LBORRES1;
    
    if LBORRES_RAW^="" and LBORRES_RAW^="不适用" then LBORRES= LBORRES_RAW;

    if lborres_raw="未做" then lborres="";
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    if lborres="" then do LBORNRLO="";LBORNRHI="";end;
/*LBNRIND*/
        FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1);
        IF       FLAG=1 AND LBORRES ^="" AND LBORNRHI^="" AND INPUT(LBORRES,BEST.) >INPUT(LBORNRHI,BEST.) THEN LBNRIND ="高";
        ELSE IF  FLAG=1 AND LBORRES ^="" AND LBORNRLO^="" AND INPUT(LBORRES,BEST.) <INPUT(LBORNRLO,BEST.) THEN LBNRIND ="低";
        ELSE IF  FLAG=1 THEN  LBNRIND ="正常";
    if LBORNRLO="" and LBORNRHI="" then LBNRIND ="";
    LBORRESU="";
    IF LBTEST="葡萄糖" THEN LBTEST="尿葡萄糖";
    lbclsig=lbclsigc;
    lborreso=lbresoth;
    /*        lbrel*/
        if lbrel_raw="1" then lbrel="Y" ;
        if lbrel_raw="0" then lbrel="N"; 
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbnam lbclsig lborreso lbrel LBAENO LBMHNO;
/*    keep lbresoth;*/
RUN;


DATA TOTAL ;
    LENGTH  LBORRES LBTEST USUBJID lbnam lbclsig lbclsigtxt lbdesc LBAENO lbmhno $200;;
    SET LB_BL_TOTAL LB_BD LB_HBV  LB_HCG  LB_THY UNS GM LB_SCR  LB_COA LB_UR1  LB_UR  LB_CRP LB_CHEM  LBALL LBALL1_7;
    IF LBTEST="肌钙蛋白I" THEN LBTEST="肌钙蛋白Ⅰ";
    IF LBTEST="白细胞" THEN LBTEST="尿白细胞";
    IF LBTEST="尿红细胞" THEN LBTEST="尿红细胞计数";
    IF LBTEST="钠 " THEN LBTEST="钠";
    IF LBORRES="" THEN DO ;LBORNRLO="" ;LBORNRHI="";END;
    if lbclsigtxt^="" then LBDESC=lbclsigtxt;
/*    if usubjid="MIL86-CT201-03003" and  LBDESC^="";*/
    if lbrel="0" then lbrel="N"; 
    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND VISIT lbspid lbnam LBSPEC LBSPCCND lbclsig  LBDESC LBREL LBORRESO LBAENO LBMHNO;
RUN;

PROC SORT DATA= TOTAL;
    BY  LBTEST;
RUN;

/*SDTM TERMINOLOGY INFO: LBTESTCD*/
PROC IMPORT OUT= SASUSER.TERMINOLOGY 
            DATAFILE= "C:\PROJECT\MIL86_CT201\BIOSTATISTICS\DOCUMENTATION\SPECIFICATIONS\SDTM\MIL86-CT201_LB.XLS" 
            DBMS=EXCEL REPLACE;
     RANGE="SDTM TERMINOLOGY INFO$C1:E93"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
PROC SORT DATA= SASUSER.TERMINOLOGY NODUPKEY;
    BY   SDTM_LBTEST;
RUN;
/*IN ORDER TO CREATE LBTESTCD LBCAT*/
DATA TOTAL_01 ;
    LENGTH USUBJID $40  ;
    MERGE  TOTAL(IN=A) SASUSER.TERMINOLOGY(RENAME=(SDTM_LBTEST=LBTEST SDTM_LBTESTCD=LBTESTCD SDTM_LBCAT=LBCAT));
    BY  LBTEST;
    IF A;
    IF VISIT="提前退出访视" THEN VISIT= "提前退出";
/*    KEEP USUBJID LBTEST LBORRES LBORRESU LBORNRLO LBORNRHI LBNRIND LBTESTCD LBCAT VISIT;*/
    IF LBTEST^="" THEN OUTPUT;
RUN;
PROC SORT DATA= TOTAL_01;
    BY VISIT;
RUN;

/*IN ORDER TO CREATE VISITNUM LBDTC 计划外*/
DATA SV;
    LENGTH USUBJID $40 SVSTDTC $20;
    SET SDTM.SV(RENAME=(SVSTDTC=LBDTC));
    FL=FIND(VISIT,"计划外");
    IF  FL^=0 THEN OUTPUT;
    KEEP VISIT  VISITNUM LBDTC USUBJID ;
RUN;
PROC SORT DATA= SV NODUP;
    BY USUBJID LBDTC ;
RUN;

DATA UNSCHEDULED;
     LENGTH USUBJID $40  LBDTC $20;
     SET TOTAL_01(WHERE=( SUBSTR(VISIT,1,15)="计划外访视"));
     LBDTC=SUBSTR(VISIT,16,26);
     LBDTC1=COMPRESS(LBDTC,"0123456789-",'K');
     DROP VISIT LBDTC;RENAME LBDTC1=LBDTC;
RUN;
PROC SORT DATA= UNSCHEDULED;
    BY USUBJID LBDTC;
RUN;

DATA UNSCHEDULED_NEW;
    MERGE UNSCHEDULED(IN=A)  SV( IN=B)  ;
    BY  USUBJID LBDTC;
    IF A ;
RUN;

/*PROC SQL ;*/
/*    CREATE TABLE UNSCHEDULED_01 AS*/
/*        SELECT A.*, B.VISITNUM,B.VISIT*/
/*            FROM UNSCHEDULED AS A LEFT JOIN SV AS B */
/*                ON A.USUBJID=B.USUBJID AND A.LBDTC=B.LBDTC*/
/*                    ORDER BY USUBJID ,LBDTC;*/
/*QUIT;*/

/*IN ORDER TO CREATE VISITNUM LBDTC 计划内*/
DATA TV;
    SET SDTM.TV;
    KEEP  VISIT VISITNUM;
RUN;
PROC SORT DATA= TV NODUPKEY;
    BY VISIT VISITNUM;
RUN;
DATA SCHEDULED;
    SET TOTAL_01(WHERE=(SUBSTR(VISIT,1,15)^="计划外访视"));
RUN;
DATA SCHEDULED_NEW;
    LENGTH USUBJID $40  ;
    MERGE SCHEDULED(IN=A) TV;
    BY VISIT;
    IF A;
RUN;

/*LBDTC */
/*CDM.LBTIM 血脂七项（给药前） LBTIM*/
/*CDM.LBPERF LBDAT */
/*LB_BL_EXTERNAL LBDTC*/

DATA LBPERF;
    SET CDM.LBPERF ;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBcat=FORMNM;
    if lbcat="血脂七项（给药前）" then lbcat="血脂七项";
    if lbcat="甲状腺功能检查" then lbcat="甲状腺功能";
    if lbcat="血清病毒学筛查" then lbcat="血清病毒学";
    rename LBDAT_RAW=lbdtc;
    KEEP USUBJID LBcat VISIT  LBDAT_RAW LBPERF lbreasnd;
RUN;
data lbperf_total;
    length lbdtc visit lbdtc usubjid lbcat lborres lbtest lborresu lborres lbtest lbnrind lbornrhi lbornrlo lbreasnd $200; 
    format lbdtc $20.;
    set lbperf lb_hcg gm  lb_bl_external ;
    if visit="提前退出访视" then visit ="提前退出";
    KEEP USUBJID LBcat VISIT  LBDTC LBPERF lbreasnd;
run;
data lbtim;  
    set cdm.lbtim;
    STUDYID="MIL86-CT201";
    USUBJID=STRIP(STRIP(STUDYID)||"-"||SUBSTR(SUBJID,2,5));
    LBCAT=FORMNM; 
    if lbcat="血脂七项（给药前）" then lbcat="血脂七项";
    keep usubjid lbtim_raw visit lbcat;
run;
proc sort data=LBtim ;
    by USUBJID lbcat VISIT ;
run;

PROC SORT DATA=LBPERF_total ;
    BY USUBJID LBCAT VISIT lbdtc;
RUN;

data lbperf_total;
    set lbperf_total;
    by USUBJID lbcat VISIT lbdtc;
    if last.visit;
run;

PROC SORT DATA=SCHEDULED_NEW;
    BY USUBJID LBCAT VISIT ;
RUN;

data SCHEDULED_NEW_01;*to get LBDTC ;
    length lbdtc usubjid lbcat visit $200 ;
    format lbdtc $200.;
    merge  SCHEDULED_NEW(in=a )  lbperf_total lbtim;
    by usubjid lbcat visit;
    if a;
    FL=FIND(lbdtc,"T");
    if not missing(lbtim_raw) and FL=0 then  lbdtc1=strip(lbdtc)||"T"||strip(lbtim_raw);
    else LBDTC1=strip(lbdtc);
    DROP LBDTC lbtim_raw;
    RENAME LBDTC1=LBDTC;
/*    keep lbperf;*/
run;


DATA TOTAL_02;
    length LBORNRLO $200;
    SET SCHEDULED_NEW_01 UNSCHEDULED_NEW;
/*匹配的时候发现有时候一模一样的东西 但是又告诉你匹配不上 一般用这个处理一下变量*/
    LBORRES=tranwrd(LBORRES,'0A'X,'') ;
    LBORRES=tranwrd(LBORRES,'0D'X,'') ;
    LBORRES = TRANSLATE(LBORRES, '' , '09'x, '', '0D'x, '', '0A'x);
    LBORRES=strip(compbl(LBORRES)) ;

    if lborres="未做" then lborres="";
    if lborres="" then do LBORNRLO="";LBORNRHI="";lborresu="";end;
    if LBORNRLO="" and LBORNRHI="" then LBNRIND ="";
    drop fl;
    *处理单位;
    if lborresu="秒" or lborresu="Sec" then lborresu="s";
    if lborresu="-" then lborresu="";
    if lborresu="/HP" or lborresu="HPF" then lborresu="/HPF";
    if lborresu="/LP" then lborresu="/LPF ";
if lborresu="ug/dl" then lborresu="ug/dL";
if lborresu="IU/ml" then lborresu="IU/mL";
if lborresu="ng/ml" then lborresu="ng/mL";
if lborresu="pg/ml" then lborresu="pg/mL";
if lborresu="ng/dl" then lborresu="ng/dL";

RUN;

/*SDTM TERMINOLOGY INFO:Standard_Unit*/
PROC IMPORT OUT= SASUSER.Standard_Unit
            DATAFILE= "C:\PROJECT\MIL86_CT201\BIOSTATISTICS\DOCUMENTATION\SPECIFICATIONS\SDTM\MIL86-CT201_LB.XLS" 
            DBMS=EXCEL REPLACE;
     RANGE="Standard_Unit$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
proc sort data=SASUSER.Standard_Unit ;
    by lbtestcd lborresu;
run;
proc sort data=total_02 ;
    by lbtestcd lborresu;
run;

data unit_standard;*to get LBSTRESU factor;
    length LBSTRESC lborresu $200;
    merge  total_02(in=a  ) SASUSER.Standard_Unit(in=b keep=LBTESTCD LBORRESU LBSTRESU FACTOR);
    by lbtestcd lborresu;
    if a;
    FLAG=IFN ((INPUT(COMPRESS(LBORRES), ?? 8.) EQ .), 0, 1);
    IF FLAG=1 AND LBORRES ^="" then lborresn=input(LBORRES,best.);*这步不能直接进行运算，因为里面含有大于号或者小于号这种，不能直接转化成数值型;
/*    计算factor*/
    if FLAG=1 AND LBORRES ^="" and lborresu="" then factor=1;
    if lbtestcd="TSH" then do factor=1; end;
    if lbtestcd="INR" then do factor=1; end;

    LBSTRESN=LBORRESN*FACTOR;
    LBSTNRLO=LBORNRLO*factor;
    LBSTNRHI=LBORNRHI*factor;
    if LBSTRESN ^=""  then LBSTRESC=PUT(LBSTRESN,BEST.);
    ELSE LBSTRESC=LBORRES;

/*    处理LBSTRESC*/ 
/**方法1;这种方法不太对*/
/*    IF LBORRES ^="" then  last1=substr(LBSTRESC,length(LBSTRESC),1);*/
/*    IF LBORRES ^="" and length(LBSTRESC)>1 then  last2=substr(LBSTRESC,length(LBSTRESC)-1,1);*/
/*    if last1="0" and last2^="." and length(LBSTRESC)>1 then LBSTRESC=substr(LBSTRESC,1,length(LBSTRESC)-1);*/
/*    if last1="0" and last2="."  and length(LBSTRESC)>1 then LBSTRESC=substr(LBSTRESC,1,length(LBSTRESC)-2);*/
/*    drop last1 last2 ;*/
*方法2：;
 
      if indexc(LBSTRESC,"×","+","-","*","^")=0   then do;
        aa=input(compress(LBSTRESC,'.','kd'),best.);* 'kd'是保留数字的意思;
        aa1=compress(LBSTRESC,'.','d');
        LBSTRESC=cats(aa1,aa);
      end;

      LBSTRESC=strip(compbl(LBSTRESC));
/*      LBORRES=tranwrd(LBORRES,'0A'X,'') ;*/
/*      LBORRES=tranwrd(LBORRES,'0D'X,'') ;*/
      LBORRES = TRANSLATE(LBORRES, '' , '09'x, '', '0D'x, '', '0A'x);
      LBORRES=strip(compbl(LBORRES)) ;
      STUDYID="MIL86-CT201";
      DOMAIN = "LB";
      drop aa aa1;
      if (lbperf="否" or lbperf="未做") then lbstat="未做";
run;

data lbstat;
    set lb_ur1;
    keep lbtest visit lbperf usubjid;
run;
proc sort data= unit_standard;
    by usubjid visit lbtest   ;
run;
proc sort data= lbstat;
   by usubjid visit lbtest   ;
run;

data total_03;
   length usubjid visit $200 ;
   merge unit_standard(in=a rename=(lbstat=lbstat_1)) lbstat(rename=(lbperf=lbstat_2) in=b);
   by usubjid visit lbtest;
   if a ;
   if lbstat_1^="" then lbstat=lbstat_1;
   else lbstat=lbstat_2;
   if (lbtest^="基因检测" and lborres="" )then lbstat="未做";
   LBreasnd=strip(compbl(LBreasnd));
run;
*如果两个数据集不想被覆盖就rename，然后保留想要的部分;

/*to create lbblfl and lbblfl*/
data dm;
    set sdtm.dm;
    keep usubjid rfstdtc;
run;

proc sort data =dm;
    by usubjid;
run;

/*lbBLFL*/
data total_04;
    merge total_03(in=a) dm;
    by usubjid;
    if  rfstdtc^="" & lbdtc^="" & lbdtc<=rfstdtc then fl=1;
    if a;  
    lbdtc_=substr(lbdtc,1,10);
run; 
proc sort data=total_04;
    by usubjid LBCAT LBTESTCD   fl lbdtc_;
run;

data total_05;
    set total_04;
        by usubjid  LBCAT LBTESTCD   fl lbdtc_;
    if last.fl and fl=1 and lborres^="" then lbblfl="Y";
    if lbdtc ^="" and rfstdtc^="" then lbdy =input(scan(lbdtc,1,'T'),yymmdd10.)-input(rfstdtc,yymmdd10.)+(input(scan(lbdtc,1,'T'),yymmdd10.)>=input(rfstdtc,yymmdd10.));
/*    keep lbblfl usubjid  lbtestcd fl lbdtc_ rfstdtc LBCAT VISITNUM;*/
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
proc sql noprint;
  create table lb_04 as
   select  distinct a.USUBJID, a.lbDTC, b.epoch, b.SESTDTC, B.SEENDTC
     from total_05 as a, se as b
       where a.usubjid=b.usubjid and sestdtc<=scan(lbdtc,1,'T')<=seendtc;
quit; 
proc sort data=lb_04;
    by  USUBJID  lbDTC epoch ;
run;
data lb_05;
   set lb_04;
   by  USUBJID  lbDTC epoch ;
   if first.lbdtc;
run;
 proc sort data=total_05;
     by USUBJID lbDTC;
run;
data final;
    merge total_05 lb_05;
    by USUBJID lbDTC;
run;

%include 'C:\Project\MIL86_CT201\Biostatistics\QC\Macros\Dryrun1\gmtrimvarlen.sas';
%GmTrimVarLen(dataIn=final, excludeVars=,splitChar=@);

%include 'C:\Project\MIL86_CT201\Biostatistics\QC\Macros\Dryrun1\qc_ctcae.sas';
%QC_CTCAE;
PROC SORT DATA=final ;
   BY USUBJID LBCAT LBTESTCD VISITNUM LBDTC LBORRES;
RUN;
data final_;
    length lbtox $200;
    set final;
        BY USUBJID LBCAT LBTESTCD VISITNUM LBDTC LBORRES;
    if first.USUBJID  then lbseq=0;
        lbseq+1;
run;
data final_sdtm;
    set final_;
        keep  studyid DOMAIN USUBJID lbspid LBTESTCD LBTEST LBCAT LBORRES LBORRESU LBORNRLO LBORNRHI  LBSTRESC LBSTRESN LBSTRESU LBSTNRLO LBSTNRHI  LBNRIND LBSTAT 
    lbreasnd VISITnum VISIT lbdtc lbnam lbblfl lbdy epoch LBSEQ LBSPEC LBSPCCND lbtox lbtoxgr;
    run;

PROC COMPARE DATA=SDTM.LB COMPARE=final_sdtm CRIT=0.00001;
RUN;
********************************************SUPPLB******************************;
%MACRO MACRO1(DATASET);
data &DATASET;
    length lbclsig  qlabel qnam qval $200;
    format lbclsig  qlabel qnam qval $200.;
    set final_;
    studyid="MIL86-CT201";
    rdomain="LB";
    IDVAR="LBSEQ"; 
    idvarval=compress(PUT(LBSEQ,BEST.));

        if compress(lbclsig)="1" then lbclsig="正常";
        if compress(lbclsig)="2" then lbclsig="异常无临床意义";
        if compress(lbclsig)="3" then lbclsig="异常有临床意义";
        if compress(lbclsig)="4" then lbclsig="未查";
    qval=&DATASET;
    qnam="&DATASET";
/*    qlabel*/
    if qnam="LBCLSIG"  then qlabel="有无临床意义";
    if qnam="LBDESC"   then qlabel="异常描述";
    if qnam="LBORRESO" then qlabel="其他定性结果";
    if qnam="LBREL"    then qlabel="与原发疾病相关";
    if qnam="LBMHNO"   then qlabel="相关病史编号";
    if qnam="LBAENO"   then qlabel="相关不良事件编号";

    qorig="CRF";
    qeval="研究者";

    idvar="LBSEQ";
    if &DATASET=""   then delete;
    if "&DATASET"="LBDESC" and LBCLSIG^="异常有临床意义" then delete;
    keep studyid rdomain usubjid  IDVAR idvarval qnam qlabel qval qorig qeval;
run;
%MEND;
/*PROC DELETE DATA=_ALL_;RUN;*/
%MACRO1(LBCLSIG);
%MACRO1(LBDESC);
%MACRO1(LBORRESO);
%MACRO1(LBREL);
%MACRO1(LBMHNO);
%MACRO1(LBAENO);



DATA SUPP;
    SET LBCLSIG LBDESC LBORRESO LBREL LBMHNO LBAENO;
/*    QVAL=strip(compbl(QVAL));*/
/*    QVAL=tranwrd(QVAL,'0A'X,'');*/
/*    QVAL=tranwrd(QVAL,'0D'X,'');*/
    QVAL=translate(QVAL, '' , '09'x, '', '0D'x, '', '0A'x);
    qval=strip(qval);
run;
proc sort data=SUPP sortseq=linguistic(ALTERNATE_HANDLING=SHIFTED );
    by STUDYID RDOMAIN USUBJID IDVAR IDVARVAL QNAM;
run;
data temp;
    set sdtm.supplb;
/*    where usubjid="MIL86-CT201-01001";*/
run;

proc compare data=sdtm.supplb compare=SUPP crit=0.00001;
run; 


***************************测试用**************************;
DATA TEST_01 ;
    SET SUPP(FIRSTOBS=25508  OBS= 25508 );
RUN;

DATA TEST_02 ;
   SET sdtm.supplb(FIRSTOBS=25508  OBS= 25508 );
RUN;
DATA TEST_03 ;
   SET temp(FIRSTOBS=63 OBS=65);
/*   if    then output;*/
RUN;

*************************************************************;
