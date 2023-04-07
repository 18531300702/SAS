/*DM lisitng*/

*SV_001;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;
	
proc sort data=cdm.vs1 out=vs1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_hem(rename=(lbdat=lbdat_hem)) out=lb_hem (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_hem);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_che(rename=(lbdat=lbdat_che)) out=lb_che (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_che);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_tn(rename=(lbdat=lbdat_tn)) out=lb_tn (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_tn);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_coa(rename=(lbdat=lbdat_coa)) out=lb_coa (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_coa);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_ft(rename=(lbdat=lbdat_ft)) out=lb_ft (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_ft);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_uri(rename=(lbdat=lbdat_uri)) out=lb_uri (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_uri);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat_pb);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V2(D4)") ;
run;

data sv_001;
	merge sv(in=a) vs1 lb_hem lb_che lb_tn lb_coa lb_ft lb_uri lb_pb;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if VSDAT ne "" then O=input(VSDAT,yymmdd10.);
	if LBDAT_HEM ne "" then P=input(LBDAT_HEM,yymmdd10.);
	if LBDAT_CHE ne "" then Q=input(LBDAT_CHE,yymmdd10.);
	if LBDAT_TN ne "" then R=input(LBDAT_TN,yymmdd10.);
	if LBDAT_COA ne "" then S=input(LBDAT_COA,yymmdd10.);
	if LBDAT_FT ne "" then T=input(LBDAT_FT,yymmdd10.);
	if LBDAT_URI ne "" then U=input(LBDAT_URI,yymmdd10.);
	if LBDAT_PB ne "" then V=input(LBDAT_PB,yymmdd10.);

	if SVDAT ne " " then M=input(SVDAT,yymmdd10.);*SVDAT compared with other DAT;
	N=min(O,P,Q,R,S,T,U,V);
	if M ne N;
	if VSDAT="" and LBDAT_HEM="" and LBDAT_CHE="" and LBDAT_TN="" and
	LBDAT_COA="" and LBDAT_FT="" and LBDAT_URI="" and LBDAT_PB="" then delete;
	if missing(svdat) then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT="腋下体温检查日期" LBDAT_HEM="血常规采样日期" LBDAT_CHE="血生化采样日期" 
	LBDAT_TN="肌钙蛋白采样日期" LBDAT_COA="凝血常规采样日期" LBDAT_FT="甲状腺功能采样日期" LBDAT_URI="尿常规采样日期" LBDAT_PB="PBMC转录组采血采样日期";
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT LBDAT_URI LBDAT_PB;
run;

proc sort data=SV_001;
	by STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT LBDAT_URI LBDAT_PB;
run;

*SV_002;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V3(D7)") ;
run;

proc sort data=cdm.vs1 out=vs1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V3(D7)") ;
run;

proc sort data=cdm.is(rename=(isdat=isdat_is)) out=is (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V3(D7)") ;
run;

proc sort data=cdm.is1(rename=(isdat=isdat_is1)) out=is1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS1);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V3(D7)") ;
run;

proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_PB);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V3(D7)") ;
run;

data sv_002;
	retain STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
	merge sv(in=a) vs1 is is1 lb_pb;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if VSDAT ne "" then O=input(VSDAT,yymmdd10.);
	if ISDAT_IS ne "" then P=input(ISDAT_IS,yymmdd10.);
	if ISDAT_IS1 ne "" then Q=input(ISDAT_IS1,yymmdd10.);
	if LBDAT_PB ne "" then R=input(LBDAT_PB,yymmdd10.);

	if SVDAT ne " " then M=input(SVDAT,yymmdd10.);*SVDAT compared with other DAT;
	N=min(O,P,Q,R);
	if M ne N;
	if VSDAT="" and ISDAT_IS="" and ISDAT_IS1="" and LBDAT_PB="" then delete;
	if missing(svdat) then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT="腋下体温检查日期" ISDAT_IS="体液免疫采血采样日期" ISDAT_IS1="细胞免疫采血采样日期" LBDAT_PB="PBMC转录组采血采样日期";
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;

proc sort data=SV_002;
	by STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;

*If svdat="" then delete;


*SV_003;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V4(D14)") ;
run;

proc sort data=cdm.vs1 out=vs1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V4(D14)") ;
run;

proc sort data=cdm.is(rename=(isdat=isdat_is)) out=is (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V4(D14)") ;
run;

proc sort data=cdm.is1(rename=(isdat=isdat_is1)) out=is1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS1);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V4(D14)") ;
run;

proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_PB);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V4(D14)") ;
run;

data sv_003;
	retain  STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
	merge sv(in=a) vs1 is is1 lb_pb;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if VSDAT ne "" then O=input(VSDAT,yymmdd10.);
	if ISDAT_IS ne "" then P=input(ISDAT_IS,yymmdd10.);
	if ISDAT_IS1 ne "" then Q=input(ISDAT_IS1,yymmdd10.);
	if LBDAT_PB ne "" then R=input(LBDAT_PB,yymmdd10.);

	if SVDAT ne " " then M=input(SVDAT,yymmdd10.);*SVDAT compared with other DAT;
	N=min(O,P,Q,R);
	if M ne N;
	if VSDAT="" and ISDAT_IS="" and ISDAT_IS1="" and LBDAT_PB="" then delete;
	if missing(svdat) then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT="腋下体温检查日期" ISDAT_IS="体液免疫采血采样日期" ISDAT_IS1="细胞免疫采血采样日期" LBDAT_PB="PBMC转录组采血采样日期";
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;

proc sort data=SV_003;
	by STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;


*SV_004;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V5(D28)") ;
run;
proc sort data=cdm.vs1 out=vs1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V5(D28)") ;
run;

proc sort data=cdm.is(rename=(isdat=isdat_is)) out=is (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V5(D28)") ;
run;

proc sort data=cdm.is1(rename=(isdat=isdat_is1)) out=is1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS1);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V5(D28)") ;
run;

proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_PB);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V5(D28)") ;
run;

data sv_004;
	merge sv(in=a) vs1 is is1 lb_pb;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if VSDAT ne "" then O=input(VSDAT,yymmdd10.);
	if ISDAT_IS ne "" then P=input(ISDAT_IS,yymmdd10.);
	if ISDAT_IS1 ne "" then Q=input(ISDAT_IS1,yymmdd10.);
	if LBDAT_PB ne "" then R=input(LBDAT_PB,yymmdd10.);

	if SVDAT ne " " then M=input(SVDAT,yymmdd10.);*SVDAT compared with other DAT;
	N=min(O,P,Q,R);
	if M ne N;
	if VSDAT="" and ISDAT_IS="" and ISDAT_IS1="" and LBDAT_PB="" then delete;
	if missing(svdat) then delete;
	retain STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT="腋下体温检查日期" ISDAT_IS="体液免疫采血采样日期" ISDAT_IS1="细胞免疫采血采样日期" LBDAT_PB="PBMC转录组采血采样日期";
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;

proc sort data=SV_004;
	by STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT VSDAT ISDAT_IS ISDAT_IS1 LBDAT_PB;
run;


*SV_005;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V6(D90)","V7(D180)") ;
run;

proc sort data=cdm.is out=is (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("V6(D90)","V7(D180)") ;
run;

data SV_005;
	merge sv(in=a) is;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if ISDAT ne "" then P=input(ISDAT,yymmdd10.);
	if SVDAT ne " " then M=input(SVDAT,yymmdd10.);*SVDAT compared with other DAT;
	if P ne M;
	if SVDAT="" and ISDAT=""  then delete;
	if missing(svdat) then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期"  ISDAT="体液免疫采血采样日期";
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT ISDAT;
run;


*SV_006;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.is(rename=(isdat=isdat_is)) out=is (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.is1(rename=(isdat=isdat_is1)) out=is1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq ISDAT_IS1);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.vs_hw(rename=(vsdat=vsdat_hw)) out=vs_hw (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT_HW);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.vs(rename=(vsdat=vsdat_vs)) out=vs (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT_VS);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.vs1(rename=(vsdat=vsdat_vs1)) out=vs1 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq VSDAT_VS1);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.pe out=pe (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq PEDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.lb_uri(rename=(lbdat=lbdat_uri)) out=lb_uri (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_URI);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.lb_hem(rename=(lbdat=lbdat_hem)) out=lb_hem (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_HEM);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.lb_che(rename=(lbdat=lbdat_che)) out=lb_che (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_CHE);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.lb_tn(rename=(lbdat=lbdat_tn)) out=lb_tn (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_TN);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.lb_coa(rename=(lbdat=lbdat_coa)) out=lb_coa (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_COA);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.lb_ft(rename=(lbdat=lbdat_ft)) out=lb_ft (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_FT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.lb_pg(rename=(lbdat=lbdat_pg)) out=lb_pg (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_PG);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.lb_hla(rename=(lbdat=lbdat_hla)) out=lb_hla (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_HLA);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq LBDAT_PB);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.mb out=mb01 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq MBDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.eg out=eg (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq EGDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.mo_bu(rename=(modat=modat_bu)) out=mo_bu (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq MODAT_BU);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
proc sort data=cdm.mo_ches(rename=(modat=modat_ches)) out=mo_ches (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq MODAT_CHES);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;

proc sort data=cdm.OT out=ot (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq OTDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视") ;
run;
data sv_006;
	merge sv(in=a) VS_HW VS VS1 PE LB_URI LB_HEM LB_CHE LB_TN LB_COA LB_FT MB01 LB_PG EG MO_BU
	MO_CHES IS IS1 LB_HLA LB_PB OT;
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	if a;
	if SVDAT ne "" then P=input(SVDAT,yymmdd10.);

	if VSDAT_HW ne "" then E=input(VSDAT_HW,yymmdd10.);
	if VSDAT_VS ne "" then 	F=input(VSDAT_VS,yymmdd10.);
	if VSDAT_VS1 ne "" then G=input(VSDAT_VS1,yymmdd10.);
	if LBDAT_URI ne "" then H=input(LBDAT_URI,yymmdd10.);
	if LBDAT_HEM ne "" then I=input(LBDAT_HEM,yymmdd10.);
	if LBDAT_CHE ne "" then J=input(LBDAT_CHE,yymmdd10.);
	if LBDAT_TN ne "" then K=input(LBDAT_TN,yymmdd10.);
	if LBDAT_COA ne "" then L=input(LBDAT_COA,yymmdd10.);
	if LBDAT_FT ne "" then M=input(LBDAT_FT,yymmdd10.);
	if MBDAT ne "" then N=input(MBDAT,yymmdd10.);
	if LBDAT_PG ne "" then O=input(LBDAT_PG,yymmdd10.);
	if EGDAT ne "" then P=input(EGDAT,yymmdd10.);
	if MODAT_BU ne "" then Q=input(MODAT_BU,yymmdd10.);
	if MODAT_CHES ne "" then R=input(MODAT_CHES,yymmdd10.);
	if ISDAT_IS ne "" then S=input(ISDAT_IS,yymmdd10.);
	if ISDAT_IS1 ne "" then T=input(ISDAT_IS1,yymmdd10.);
	if LBDAT_HLA ne "" then U=input(LBDAT_HLA,yymmdd10.);
	if LBDAT_PB ne "" then V=input(LBDAT_PB,yymmdd10.);
	if OTDAT ne "" then W=input(OTDAT,yymmdd10.);
	
	Z=min(E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W);
	if P ne Z;
	if nmiss(E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W)=19 then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT_HW="身高体重检查日期"
	VSDAT_VS="生命体征检查日期" VSDAT_VS1="腋下体温检查日期" PEDAT="体格检查检查日期" LBDAT_URI="尿常规采样日期" LBDAT_HEM="血常规采样日期"
	LBDAT_CHE="血生化采样日期" LBDAT_TN="肌钙蛋白采样日期" LBDAT_COA="凝血常规采样日期" LBDAT_FT="甲状腺功能采样日期" MBDAT="传染病检查采样日期"
	LBDAT_PG="血妊娠试验采样日期" EGDAT="12导联心电图检查日期" MODAT_BU="B 超检查检查日期" MODAT_CHES="正位胸片检查日期" ISDAT_IS="体液免疫采血"
	ISDAT_IS1="细胞免疫采血" LBDAT_HLA="HLA测序" LBDAT_PB="PBMC转录组采血" OTDAT="其他检查采样/检查日期";
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq SVDAT VSDAT_HW
	VSDAT_VS VSDAT_VS1 PEDAT LBDAT_URI LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT MBDAT LBDAT_PG EGDAT MODAT_BU MODAT_CHES ISDAT_IS ISDAT_IS1 LBDAT_HLA LBDAT_PB OTDAT;
run;

proc sort data=SV_006;
	by STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq SVDAT VSDAT_HW
	VSDAT_VS VSDAT_VS1 PEDAT LBDAT_URI LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT MBDAT LBDAT_PG EGDAT MODAT_BU MODAT_CHES ISDAT_IS ISDAT_IS1 LBDAT_HLA LBDAT_PB OTDAT;
run;


*SV_007;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq SVDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
run;

proc sort data=cdm.vs_hw(rename=(vsdat=vsdat_hw)) out=vs_hw(keep=Subject_id vsdat_hw);
	by subject_id;
run;

proc sort data=cdm.vs(rename=(vsdat=vsdat_vs)) out=vs(keep=Subject_id vsdat_vs);
	by subject_id;
run;
proc sort data=cdm.vs1(rename=(vsdat=vsdat_vs1)) out=vs1(keep=Subject_id vsdat_vs1);
	by subject_id;
run;
proc sort data=cdm.pe out=pe(keep=Subject_id pedat);
	by subject_id;
run;
proc sort data=cdm.lb_uri(rename=(lbdat=lbdat_uri)) out=lb_uri(keep=Subject_id lbdat_uri);
	by subject_id;
run;
proc sort data=cdm.lb_hem(rename=(lbdat=lbdat_hem)) out=lb_hem(keep=Subject_id lbdat_hem);
	by subject_id;
run;
proc sort data=cdm.lb_che(rename=(lbdat=lbdat_che)) out=lb_che(keep=Subject_id lbdat_che);
	by subject_id;
run;
proc sort data=cdm.lb_tn(rename=(lbdat=lbdat_tn)) out=lb_tn(keep=Subject_id lbdat_tn);
	by subject_id;
run;
proc sort data=cdm.lb_coa(rename=(lbdat=lbdat_coa))  out=lb_coa(keep=Subject_id lbdat_coa);
	by subject_id;
run;
proc sort data=cdm.lb_ft(rename=(lbdat=lbdat_ft)) out=lb_ft(keep=Subject_id lbdat_ft);
	by subject_id;
run;
proc sort data=cdm.mb out=mb01(keep=Subject_id mbdat);
	by subject_id;
run;
proc sort data=cdm.lb_pg(rename=(lbdat=lbdat_pg)) out=lb_pg(keep=Subject_id lbdat_pg);
	by subject_id;
run;
proc sort data=cdm.eg out=eg(keep=Subject_id egdat);
	by subject_id;
run;
proc sort data=cdm.mo_bu(rename=(modat=modat_bu)) out=mo_bu(keep=Subject_id modat_bu);
	by subject_id;
run;
proc sort data=cdm.mo_ches(rename=(modat=modat_ches)) out=mo_ches(keep=Subject_id modat_ches);
	by subject_id;
run;
proc sort data=cdm.is(rename=(isdat=isdat_is)) out=is(keep=Subject_id isdat_is);
	by subject_id;
run;
proc sort data=cdm.is1(rename=(isdat=isdat_is1)) out=is1(keep=Subject_id isdat_is1);
	by subject_id;
run;
proc sort data=cdm.lb_hla(rename=(lbdat=lbdat_hla)) out=lb_hla(keep=Subject_id lbdat_hla);
	by subject_id;
run;
proc sort data=cdm.lb_pb(rename=(lbdat=lbdat_pb)) out=lb_pb(keep=Subject_id lbdat_pb);
	by subject_id;
run;
proc sort data=cdm.ot out=ot(keep=Subject_id otdat);
	by subject_id;
run;
data sv_007;
	merge sv(in=a) VS_HW VS VS1 PE LB_URI LB_HEM LB_CHE LB_TN LB_COA LB_FT MB01
	LB_PG EG MO_BU MO_CHES IS IS1 LB_HLA LB_PB OT;
	by subject_id;
	if visit_name="计划外访视" then output;
run;



*SV_008;

proc sort data=cdm.DS out=ds (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq DSSTDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;
	where Visit_Name in ("计划外访视");
run;
data sv_008;
	merge sv_007 DS;
	by subject_id;
	if a;
	if SVDAT ne "" then P=input(SVDAT,yymmdd10.);
	if VSDAT_HW ne "" then E=input(VSDAT_HW,yymmdd10.);
	if VSDAT_VS ne "" then 	F=input(VSDAT_VS,yymmdd10.);
	if VSDAT_VS1 ne "" then G=input(VSDAT_VS1,yymmdd10.);
	if LBDAT_URI ne "" then H=input(LBDAT_URI,yymmdd10.);
	if LBDAT_HEM ne "" then I=input(LBDAT_HEM,yymmdd10.);
	if LBDAT_CHE ne "" then J=input(LBDAT_CHE,yymmdd10.);
	if LBDAT_TN ne "" then K=input(LBDAT_TN,yymmdd10.);
	if LBDAT_COA ne "" then L=input(LBDAT_COA,yymmdd10.);
	if LBDAT_FT ne "" then M=input(LBDAT_FT,yymmdd10.);
	if MBDAT ne "" then N=input(MBDAT,yymmdd10.);
	if LBDAT_PG ne "" then O=input(LBDAT_PG,yymmdd10.);
	if EGDAT ne "" then P=input(EGDAT,yymmdd10.);
	if MODAT_BU ne "" then Q=input(MODAT_BU,yymmdd10.);
	if MODAT_CHES ne "" then R=input(MODAT_CHES,yymmdd10.);
	if ISDAT_IS ne "" then S=input(ISDAT_IS,yymmdd10.);
	if ISDAT_IS1 ne "" then T=input(ISDAT_IS1,yymmdd10.);
	if LBDAT_HLA ne "" then U=input(LBDAT_HLA,yymmdd10.);
	if LBDAT_PB ne "" then V=input(LBDAT_PB,yymmdd10.);
	if OTDAT ne "" then W=input(OTDAT,yymmdd10.);
	if DSSTDAT ne "" then A=input(DSSTDAT,yymmdd10.);
	
	Z=min(E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W);
	if P ne Z;
	if nmiss(P,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W)=19 then delete;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" VSDAT_HW="身高体重检查日期"
	VSDAT_VS="生命体征检查日期" VSDAT_VS1="腋下体温检查日期" PEDAT="体格检查检查日期" LBDAT_URI="尿常规采样日期" LBDAT_HEM="血常规采样日期"
	LBDAT_CHE="血生化采样日期" LBDAT_TN="肌钙蛋白采样日期" LBDAT_COA="凝血常规采样日期" LBDAT_FT="甲状腺功能采样日期" MBDAT="传染病检查采样日期"
	LBDAT_PG="血妊娠试验采样日期" EGDAT="12导联心电图检查日期" MODAT_BU="B 超检查检查日期" MODAT_CHES="正位胸片检查日期" ISDAT_IS="体液免疫采血"
	ISDAT_IS1="细胞免疫采血" LBDAT_HLA="HLA测序" LBDAT_PB="PBMC转录组采血" OTDAT="其他检查采样/检查日期";
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq SVDAT VSDAT_HW
	VSDAT_VS VSDAT_VS1 PEDAT LBDAT_URI LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT MBDAT LBDAT_PG EGDAT MODAT_BU MODAT_CHES ISDAT_IS ISDAT_IS1 LBDAT_HLA LBDAT_PB OTDAT;
run;

proc sort data=SV_008;
	by STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq SVDAT VSDAT_HW
	VSDAT_VS VSDAT_VS1 PEDAT LBDAT_URI LBDAT_HEM LBDAT_CHE LBDAT_TN LBDAT_COA
	LBDAT_FT MBDAT LBDAT_PG EGDAT MODAT_BU MODAT_CHES ISDAT_IS ISDAT_IS1 LBDAT_HLA LBDAT_PB OTDAT;
run;

*SV_RAND_001;
proc sort data=cdm.rand out=rand01 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq RANDDAT);
	by studyid Site_No Subject_id Visit_No Visit_Name ;
	where Visit_Name in ("计划外访视");
run;
data sv_rand_001;
	merge sv(in=a) rand01;
	by studyid Site_No Subject_id Visit_No Visit_Name;
	if a;
	if SVDAT ne "" then P=input(SVDAT,yymmdd10.);
	if RANDDAT ne "" then Q=input(RANDDAT,yymmdd10.);
	if P < Q;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" SVDAT="访视日期" randdat="随机日期";
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq SVDAT RANDDAT;
run;

*VS_VS1_001;*人工核查;


*CM1_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq);
	by studyid Site_No Subject_id Visit_No Visit_Name ;
run;
proc sort data=cdm.cm1 out=cm1(keep=STUDYID Site_No Subject_id Visit_No Visit_Name  CMSPID CMTRT CMREASN CMROUTE CMROUTEO CMDOSE CMLOC CMLOCO CMSTDAT);
	by studyid Site_No Subject_id Visit_No;
run;
data cm1_001_1;
	merge sv cm1(in=a);
	by studyid Site_No Subject_id Visit_No;
	if a;
	if missing(cmtrt) then delete;
run;

proc sort nodupkey data=cm1_001_1 out=cm1_001_2;
	by studyid Site_No Subject_id Visit_No;
run;

proc sort nodupkey dupout=cm1_001 data=cm1_001_1 out=cm1_001_2;
	by cmtrt cmstdat;
run;
proc sort nodupkey dupout=cm1_002 data=cm1_001_1 out=cm1_001_2;
	by cmtrt cmdose;
run;

	
*CM2_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id);
	by studyid Site_No Subject_id Visit_No;
run;

proc sort data=cdm.cm2 out=cm2(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMMANUF CMTRT CMROUTE_dec CMROUTEO CMDOSE CMSTDAT);
	by studyid Site_No Subject_id Visit_No;
run;

proc sort data=cdm.ic out=ic(keep=STUDYID Site_No Subject_id DSSTDAT);
	by studyid Site_No Subject_id Visit_No ;
run;

proc sort data=cdm.ie out=ie(keep=STUDYID Site_No Subject_id ieyn IEYN_dec DSDECOD1 IEINCLCD);
	by studyid Site_No Subject_id Visit_No ;
run;

data cm2_001;
	merge  cm2(in=a) ic ie;
	by studyid Site_No Subject_id;
	if a;
	dif=input(cmstdat,yymmdd10.)-input(dsstdat,yymmdd10.);
	if dif<180 and dif>0 then do;
		if ieyn="2" then flag="1";
		else if ieyn="1" and dsdecod1=1 and ieinclcd ne 2 then flag="2";
	end;
	keep studyid Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMMANUF CMTRT
	CMROUTE_dec CMROUTEO CMDOSE CMSTDAT DSSTDAT IEYN_dec DSDECOD1 IEINCLCD FLAG;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号" CMSPID="序列号" CMMANUF="生产厂家" CMTRT="疫苗名称" CMROUTE_DEC="接种途径" CMROUTEO="其他，请说明" 
	CMDOSE="接种剂量" CMSTDAT="接种日期" DSSTDAT="知情同意签署日期" IEYN_DEC="是否入选" DSDECOD1="未入选原因" 
	IEINCLCD="请填写具体的入选标准编号" FLAG="Flag";
	if not missing(flag) then output;
	drop ieyn;
run;


*CM2_002;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id );
	by studyid Site_No Subject_id Visit_No Visit_Name;
run;
proc sort data=cdm.cm2 out=cm2(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMMANUF CMTRT CMROUTE CMROUTEO CMDOSE CMSTDAT);
	by studyid Site_No Subject_id Visit_No;
run;
data cm2_002_1;
	set cm2;
	by subject_id ;
	cmstdat_lag=lag(cmstdat);
	if first.subject_id then do;
	cmstdat_lag="";
	end;

	cmdose_lag=lag(cmdose);
	if first.subject_id then do;
	cmdose_lag="";
	end;
	
/*	if cmdose=cmdose_lag then delete;*/
/*	if cmstdat=cmstdat_lag and  not missing(CMSTDAT)  then output;*/
	if missing(cmtrt) then delete;
	retain studyid Site_No Subject_id Visit_No Visit_Name Form_Seq
	CMSPID CMMANUF CMTRT CMROUTE CMROUTEO CMDOSE CMSTDAT;
	keep studyid Site_No Subject_id Visit_No Visit_Name Form_Seq
	CMSPID CMMANUF CMTRT CMROUTE CMROUTEO CMDOSE CMSTDAT;
run;

proc sort nouniquekey data=cm2_002_1 out=cm2_002;
	by Subject_id cmstdat;
run;


*CM_001;

/*proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id );*/
/*	by studyid Site_No Subject_id Visit_No Visit_Name Form_Seq;*/
/*run;*/

proc sort data=cdm.cm(rename=(cmstdat=cmstdat01)) out=cm(keep=studyid Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT CMROUTE CMROUTEO CMDOSE CMDOSEU CMDOSEUO CMDOSFRQ CMDSFRQO CMSTDAT01 CMONGO CMENDAT);
	by Subject_id ;
run;

data cm_01;
	set cm;
	by Subject_id ;
	if index(cmstdat01,"UK")=0 then cmstdat=cmstdat01;
	else if 1>=index(cmstdat01,"UK")>0 then cmstdat=substr(cmstdat01,1,7);
	else if index(cmstdat01,"UK")>1 then cmstdat=substr(cmstdat01,1,4);	

	cmtrt_lag=lag(cmtrt);
	cmstdat_lag=lag(cmstdat);
	cmendat_lag=lag(cmendat);
	if cmtrt=cmtrt_lag and not missing(cmendat) then do;
		if cmstdat_lag <= cmstdat<= cmendat_lag then flag="1";
		else if cmstdat_lag <=cmendat then flag="2";
	end;
	if missing(cmendat) then flag="3";
	if missing(cmtrt) then delete;
	drop CMSTDAT01 cmtrt_lag cmstdat_lag cmendat_lag flag;
run;

proc sort nouniquekey data=cm_01 out=cm_001 ;
	by  subject_id cmtrt cmstdat;
run;



*CM_AE_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id );
	by Subject_id ;
run;
proc sort data=cdm.cm(rename=(cmstdat=cmstdat01)) out=cm(keep=Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT cmstdat01 CMONGO CMENDAT CMAENO);
	by Subject_id;
	where not missing(cmaeno) ;
run;
data cm01;
	set cm;
	cmterm1=scan(scan(cmaeno,1,","),2,"_");
	cmterm2=scan(scan(cmaeno,2,","),2,"_");
	aespid=scan(scan(cmaeno,1,","),1,"_");
	proc sort;
	by  Subject_id aespid;
run;

proc sort data=cdm.ae(rename=(aestdat=aestdat01)) out=ae(keep=Subject_id AESPID AETERM1 AETERM2 AETERM AESTDAT01 AEONGO AEENDAT AEACNCM AEACNCM_DEC);
	by Subject_id aespid;
	where AEACNCM_DEC="药物治疗" ;
run;

data cm_ae_001;*使用序列号来进行对比;
	retain  Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT cmstdat CMONGO CMENDAT
	CMAENO AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNCM AEACNCM_DEC FLAG;
	merge cm01(in=a) ae;
	by Subject_id aespid;
	if a;
	if index(cmstdat01,"UK")=0 then cmstdat=cmstdat01;
	else if 1>=index(cmstdat01,"UK")>0 then cmstdat=substr(cmstdat01,1,7);
	else if index(cmstdat01,"UK")>1 then cmstdat=substr(cmstdat01,1,4);

	if index(AESTDAT01,"UK")=0 then AESTDAT=AESTDAT01;
	else if 1>=index(AESTDAT01,"UK")>0 then AESTDAT=substr(AESTDAT01,1,7);
	else if index(AESTDAT01,"UK")>1 then AESTDAT=substr(AESTDAT01,1,4);
	
	if missing(aestdat) then flag="1";
	else if not missing(aestdat) and missing(cmspid) then flag="2";
	else if not missing(aespid) and AEACNCM_DEC ne "药物治疗" then flag="3";
	else if not missing(aespid) and (input(cmstdat,yymmdd10.) lt input(aestdat,yymmdd10.)) then flag="4";
	else if not missing(aespid) and not missing(aeendat) then do;
	if input(cmstdat,yymmdd10.) gt input(aeendat,yymmdd10.) then flag="5";
	end;
	if missing(aespid) then delete;
	if missing(flag) then delete;
	if missing(AEACNCM) then delete;
	if cmstdat=aestdat then delete;
	if cmstdat=aeendat then delete;
	if aestdat <= cmstdat <= aeendat then delete;
	if missing(aeendat) then delete;
	keep  Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT cmstdat CMONGO CMENDAT
	CMAENO AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNCM  AEACNCM_DEC FLAG;
	
	label Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号"  CMSPID="序列号" CMTRT="药物名称" cmstdat="开始日期" CMONGO="是否仍在使用"
	CMENDAT="结束日期" CMAENO="不良事件编号" AESPID="序列号" AETERM1="局部征集性不良事件名称" AETERM2="全身征集性不良事件名称" AETERM="非征集性不良事件名称"
	AESTDAT="开始日期" AEONGO="不良事件是否仍在继续" AEENDAT="结束日期" AEACNCM="对此不良事件采取的措施" AEACNCM_DEC="对此不良事件采取的措施 解码" FLAG="Flag";
run;
proc sort data=cm_ae_001;
	by subject_id visit_no visit_name cmspid cmtrt cmstdat aestdat;
run;


*CM_MH_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id);
	by Subject_id ;
run;
proc sort data=cdm.cm(rename=(cmstdat=cmstdat01)) out=cm(keep=Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT cmstdat01 CMONGO CMENDAT CMMHNO);
	by Subject_id;
	where not missing(cmmhno) ;
run;
data cm01;
	set cm;
	cmterm=scan(cmmhno,2,"_");
run;

proc sort data=cdm.mh(rename=(mhstdat=mhstdat01)) out=mh(keep=Subject_id MHSPID MHTERM mhstdat01 MHONGO MHENDAT);
	by Subject_id;
run;

data cm_mh_001;
	merge sv cm01(in=a) mh;
	by Subject_id;
	if a;
	if index(cmstdat01,"UK")=0 then cmstdat=cmstdat01;
	else if 1>=index(cmstdat01,"UK")>0 then cmstdat=substr(cmstdat01,1,7);
	else if index(cmstdat01,"UK")>1 then cmstdat=substr(cmstdat01,1,4);

	if index(mhstdat01,"UK")=0 then mhstdat=mhstdat01;
	else if 1>=index(mhstdat01,"UK")>0 then mhstdat=substr(mhstdat01,1,7);
	else if index(mhstdat01,"UK")>1 then mhstdat=substr(mhstdat01,1,4);

    if mhspid="" then flag="1";
	else if mhspid ne cmspid then flag="2" ;
	else if mhspid=cmspid and cmstdat<mhstdat  then flag="3";
	else if mhspid=cmspid and not missing(mhendat) then do;
	if cmstdat>mhendat then flag="4";
	end;
	if not missing(flag) then output;
	retain STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMMHNO MHSPID MHTERM MHSTDAT MHONGO MHENDAT FLAG;
	keep STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMMHNO MHSPID MHTERM MHSTDAT MHONGO MHENDAT FLAG;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" 
	Form_Seq="表单序号"  CMSPID="序列号"  CMTRT="药物名称"  CMSTDAT="开始日期"  CMONGO="是否仍在使用"  CMENDAT="结束日期" 
	CMMHNO="既往/合并疾病编号"  MHSPID="编号" MHTERM="疾病名称"  MHSTDAT="开始日期"  MHONGO="目前是否存在"  MHENDAT="结束日期" FLAG="Flag";
run;

*PRN_CM_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id Visit_Name);
	by Subject_id Visit_Name;
run;
proc sort data=cdm.prn_cm(rename=(prstdat=prstdat01)) out=prn_cm(keep=Subject_id Visit_No Visit_Name PRSPID PRTRT PRSTDAT01 PRONGO PRENDAT);
	by Subject_id prstdat01;
run;
data prn_cm_01;
	merge sv prn_cm(in=a);
	by subject_id Visit_Name;
	if index(prstdat01,"UK")=0 then prstdat=prstdat01;
	else if 1>=index(prstdat01,"UK")>0 then prstdat=substr(prstdat01,1,7);
	else if index(prstdat01,"UK")>1 then prstdat=substr(prstdat01,1,4);
	if not missing(prspid) and not missing(prtrt) then output;
run;

proc sort nouniquekey data=prn_cm_01 out=prn_cm_02;
	by Subject_id prtrt;
run;

proc sql;
	create table prn_cm_001 as
	select distinct STUDYID,Site_No,Subject_id,Visit_No,Visit_Name,PRSPID,PRTRT,PRSTDAT01,PRONGO,PRENDAT
	from prn_cm_02;
run;


/*data prn_cm_001;*/
/*	set prn_cm_02;*/
/*	if prspid ^="1" then output;*/
/*run;*/


*PRN_CM_AE_001; *uncompleted;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id );
	by Subject_id ;
run;
proc sort data=cdm.prn_cm out=prn_cm(keep=Subject_id Visit_No Visit_Name Form_Seq PRSPID PRTRT PRINDC PRAENO PRMHNO PRSTDAT PRONGO PRENDAT);
	by Subject_id ;
	where praeno ne "";
run;

proc sort data=cdm.ae out=ae(keep=Subject_id AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNPR);
	by Subject_id ;
run;

data prn_cm_01;
	set prn_cm;
	prterm1=scan(scan(praeno,1,","),2,"_");
	prterm2=scan(scan(praeno,2,","),2,"_");
	prnspid1=scan(scan(praeno,1,","),1,"_");
	prnspid2=scan(scan(praeno,2,","),1,"_");
run;


data prn_cm_ae_001;
	merge sv prn_cm_01(in=a) ae;
	by Subject_id ;
	if a;
	if aespid="" then flag="1";
	else if aespid ^="" and not missing(prmhno)and ((aeterm1 ne prterm1) or (aeterm2 ne prterm2)) then flag="2";
	else if aespid=prspid and aeacnpr ne "3" then flag="3";
	else if aespid=prspid and PRSTDAT<AESTDAT then flag="4";
	else if aespid=prspid and not missing(AEENDAT) then do;
	if PRSTDAT>AEENDAT then flag="5";
	end;
	if not missing(flag) and not missing(PRMHNO) then output;
run;

proc sort data=prn_cm_ae_001 nodupkey;
	by subject_id AETERM1 AETERM2 AETERM AESTDAT;
run;

*prn_cm_mh_001;

/*proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id);*/
/*	by Subject_id;*/
/*run;*/
proc sort data=cdm.prn_cm out=prn_cm(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq PRSPID PRTRT PRINDC PRMHNO PRSTDAT PRONGO PRENDAT);
	by Subject_id;
	where prmhno ne "";
run;

proc sort data=cdm.mh out=mh(keep=subject_id Visit_No Visit_Name Form_Seq mhspid mhterm mhstdat mhongo mhendat);
	by subject_id;
run;

data prn_cm_mh_001;
	merge prn_cm(in=a) mh;
	by subject_id;
	if a;
	if mhterm="" then flag="1";
	else if mhterm ^="" then do ;
	if  prspid ne mhspid then flag="2";
	else if   prstdat le mhstdat then flag="3";
	else if not missing(mhendat) and prstdat ge mhendat then flag="4";
	end;
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq PRSPID PRTRT PRINDC PRMHNO PRSTDAT PRONGO PRENDAT MHSPID MHTERM MHSTDAT MHONGO MHENDAT FLAG;
	retain STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq PRSPID PRTRT PRINDC PRMHNO PRSTDAT PRONGO PRENDAT MHSPID MHTERM MHSTDAT MHONGO MHENDAT FLAG;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称" Form_Seq="表单序号" 
	PRSPID="序列号" PRTRT="非药物治疗名称" PRINDC="治疗原因" PRMHNO="既往/合并疾病编号" PRSTDAT="开始日期" PRONGO="是否仍持续" PRENDAT="结束日期" MHSPID="编号"
	MHTERM="疾病名称" MHSTDAT="开始日期" MHONGO="目前是否存在" MHENDAT="结束日期" FLAG="Flag";
run;



*rand_001;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No);
	by studyid Site_No Subject_id Visit_No;
run;
proc sort data=cdm.rand out=rand01 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq randdat randid);
	by studyid Site_No Subject_id Visit_No randdat;
run;

data rand_01;
	merge sv rand01(in=a);
	by  STUDYID Site_No Subject_id Visit_No;
	if a;
run;

proc sort nouniquekey data=rand_01 out=rand_02;
	by randid;
run;*there is no duplicated data,so we dont give flag 1;

data rand_03;
	set rand_01;
	if substr(randid,1,1)^="X" then output;
	else if substr(randid,1,1)="X" and (2255<input(substr(randid,2,4),4.) or input(substr(randid,2,4),4.)<2001) then output;
run;

data rand_04;
	set rand_01;
	by subject_id;
	randid_n=input(substr(randid,2,4),best.);
	randid_lag=lag(randid_n);
	if first.subject_id then do;
	randid_lag="";
	end;
	if randid_n < randid_lag then output;
	drop randid_lag;
run;
data rand_001;
	set rand_02(in=c) rand_03(in=a) rand_04(in=b);
	if a then flag="2";
	else if b then flag="3";
	else if c then flag="1";
	retain STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq randdat randid flag;
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq randdat randid flag; 
	if missing(randid) then delete;
run;


*rand_002;
proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id Visit_No);
	by studyid Site_No Subject_id Visit_No;
run;
proc sort data=cdm.rand out=rand01 (keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq randdat randid dsgroup dsgroup_dec randyn1);
	by studyid Site_No Subject_id Visit_No randdat;
run;

data rand_01;
	merge sv rand01(in=a);
	by  STUDYID Site_No Subject_id Visit_No;
	if a;
run;

proc freq data=rand_01;
	tables dsgroup;
run;*Here we can see the number of samples is 85, then we dont give flag as 1;

data rand_02;
	set rand_01;
	proc sort;
	by dsgroup_dec ;
run;
data rand_002;
	set rand_02;
	retain rank;
	by dsgroup_dec;
	if first.dsgroup_dec then rank=0;
	rank=rank+1;
	if rank < 20 then do;
	if randid="N" then output;
	end;
run;
	
*vs_vs1_lb_pg_001;
proc sort data=cdm.sv out=sv (keep= Site_No Subject_id VISIT_NO);
	by studyid Site_No Subject_id Visit_No;
run;
proc sort data=cdm.vs(rename=(vsdat=vsdat_vs)) out=vs(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq vsdat_vs VSORRES_PULSE VSORRES_SYSBP VSORRES_DIABP);
	by Subject_id;
	where visit_name in ("筛选期","V1(D0)") ;
run;
proc sort data=cdm.vs1(rename=(vsdat=vsdat_vs1)) out=vs1(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq vsdat_vs1 VSORRES_TEMP);
	by Subject_id;
	where visit_name in ("筛选期","V1(D0)") ;
run;
proc sort data=cdm.lb_pg out=lb_pg(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq lbdat LBORRES);
	by Subject_id;
	where visit_name in ("筛选期","V1(D0)") ;
run;
/**/
/*data vs_01;*/
/*	set vs;*/
/*	by subject_id;*/
/*	if not missing(vsdat_vs) then do;*/
/*	vsdat_vs_lag=lag(vsdat_vs);*/
/*	if first.subject_id then call missing(vsdat_vs_lag);*/
/*	if vsdat_vs=vsdat_vs_lag then output;*/
/*	end;*/
/*run;*/
/**/
/*data vs1_01;*/
/*	set vs1;*/
/*	by subject_id;*/
/*	if not missing(vsdat_vs1) then do;*/
/*	vsdat_vs1_lag=lag(vsdat_vs1);*/
/*	if first.subject_id then call missing(vsdat_vs1_lag);*/
/*	if vsdat_vs1=vsdat_vs1_lag then output;*/
/*	end;*/
/*run;*/
/**/
/*data lb_pg_01;*/
/*	set lb_pg;*/
/*	by subject_id;*/
/*	if not missing(lbdat) then do;*/
/*	lbdat_lag=lag(lbdat);*/
/*	if first.subject_id then call missing(lbdat_lag);*/
/*	if lbdat=lbdat_lag then output;*/
/*	end;*/
/*run;*/


data vs_vs1_lb_pg_01;
	set vs(in=a) vs1(in=b) lb_pg(in=c);
	retain STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq vsdat_vs  VSORRES_PULSE VSORRES_SYSBP VSORRES_DIABP vsdat_vs1 VSORRES_TEMP lbdat LBORRES;
	keep STUDYID Site_No  Subject_id Visit_No Visit_Name Form_Seq vsdat_vs  VSORRES_PULSE VSORRES_SYSBP VSORRES_DIABP vsdat_vs1 VSORRES_TEMP lbdat LBORRES;
	label STUDYID="项目ID" Site_No="中心编号" Subject_id="筛选号"
	Visit_No="访视编号" Visit_Name="访视名称" Form_Seq="表单序号" vsdat_vs="生命体征检查日期" vsdat_vs1="腋下体温检查日期" lbdat="血妊娠试验采样日期";
run;
*修改自动填充;
proc sort nouniquekey data=vs_vs1_lb_pg_01 out=vs_vs1_lb_pg_02;
	by STUDYID  Subject_id vsdat_vs vsdat_vs1 lbdat VSORRES_PULSE VSORRES_SYSBP VSORRES_DIABP VSORRES_TEMP LBORRES;
run;

data vs_vs1_lb_pg_001;
	set vs_vs1_lb_pg_02;
	if not missing(lbdat) or not missing(vsdat_vs) or not missing(vsdat_vs1) then output;
run;


*Merge 数据集出现重复;


/**AE_001;*/;

/*proc sort data=cdm.sv out=sv (keep=STUDYID Site_No Subject_id);*/
/*	by Subject_id ;*/
/*run;*/

proc sort data=cdm.ae out=ae (keep=STUDYID Site_No Subject_id Visit_No Visit_Name AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT);
	by Subject_id aestdat;
	where not missing(aeterm) or not missing(aeterm1) or not missing(aeterm2);
	where not missing(aeendat);
run;
/*proc sort nouniquekey data=ae out=ae_01;*/
/*	by subject_id ;*/
/*run;*/

data ae_02;
	set ae;
	by subject_id;
	subject_id_lag=lag(subject_id);
	if subject_id_lag=subject_id then do;
	aeterm_lag=lag(aeterm);
	aeterm1_lag=lag(aeterm1);
	aeterm2_lag=lag(aeterm2);
	aeendat_lag=lag(aeendat);
	aestdat_lag=lag(aestdat);
	if first.subject_id then call missing(aestdat_lag);
	if first.subject_id then call missing(aeendat_lag);

	if aeterm=aeterm_lag or aeterm1=aeterm1_lag or aeterm2=aeterm2_lag then do;
	if  aestdat <= aeendat_lag then flag="1";
	else if aestdat_lag <= aeendat then flag="2";;
	end;
	end;
	if not missing(flag) then output;
run;

data ae_001;
	set ae_02;
	if AETERM2="新发或加重的肌肉痛" then delete;
	retain STUDYID Site_No Subject_Id Visit_No Visit_Name  AESPID AETERM1 AETERM2 AETERM  AESTDAT AEONGO AEENDAT;
	keep  STUDYID Site_No Subject_Id Visit_No Visit_Name AESPID AETERM1 AETERM2 AETERM  AESTDAT AEONGO AEENDAT;
run;



/*proc sort data=ae_001 nouniquekey;*/
/*	by subject_id aespid AESTDAT ;*/
/*run;*/

/**AE_002;*/;

proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id Visit_No Visit_Name Form_Seq) ;
	by Subject_id;
run;

proc sort data=cdm.ae out=ae (keep=Subject_id AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNCM);
	by Subject_id aestdat;
	where aeacncm="2";
run;

proc sort data=cdm.cm out=cm(keep=Subject_id CMINDC CMAENO CMSTDAT CMONGO CMENDAT);
	by Subject_id;
run;

data ae_002;
	merge sv ae(in=a) cm;
	by Subject_id;
	if a;
	if missing(cmindc) then flag="1";
	else if not missing(cmindc) and not missing(aespid) then flag="2";
	else if not missing(aespid) and not missing(aeendat) then do;
	if cmstdat <aestdat then flag="3";
	else if cmstdat >aeendat then flag="3";
	end;
	if not missing(flag) then output;
run;

*AE_003;

proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id) ;
	by Subject_id;
run;

proc sort data=cdm.ae out=ae (keep=Subject_id  Visit_No Visit_Name Form_Seq AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNCM);
	by Subject_id aestdat;
	where aeacncm="3";
run;
proc sort data=cdm.prn_cm out=prn_cm(keep=subject_id prindc praeno prstdat prongo prendat);
	by Subject_id;
run;
data ae_003;
	merge sv ae(in=a) prn_cm;
	by Subject_id;
	if a;
	if missing(prindc) then flag="1";
	else if not missing(prindc) and not missing(aespid) then flag="2";
	else if not missing(aespid) and not missing(aeendat) then do;
	if prstdat <aestdat then flag="3";
	else if prstdat >aeendat then flag="3";
	end;
	if not missing(flag) then output;
run;

*AE_004;

proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id) ;
	by Subject_id;
run;

proc sort data=cdm.ae out=ae(keep=Subject_id  Visit_No Visit_Name Form_Seq AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNND_DEC);
	by Subject_id aespid;
	where AEACNND_DEC="未治疗";
run;

proc sort data=cdm.cm out=cm(keep=Subject_id CMINDC_DEC CMAENO CMSTDAT CMONGO CMENDAT);
	by Subject_id;
	where not missing(cmaeno);
run;
data cm_01;
	length aespid $60.;
	set cm;
	aespid=scan(scan(cmaeno,1,","),1,"_");
	proc sort ;
	by subject_id aespid;
run;

data ae_004;
	merge  ae(in=a) cm_01;
	by subject_id aespid;
	if a;
	if not missing(aeterm1) then flag="1";
	else if not missing(aeterm2) then flag="2";
	else if not missing(aeterm) then flag="3";
	if not missing(CMAENO) then output;
run;
proc sort data=ae_004 nodupkey;
	by subject_id aespid AESTDAT ;
run;

*AE_005;
proc sort data=cdm.sv out=sv(keep=studyid Subject_id) ;
	by Subject_id;
run;

proc sort data=cdm.ae out=ae(keep=Subject_id visit_name AESPID AETERM1 AETERM2 AETERM AESTDAT AEONGO AEENDAT AEACNND_DEC);
	by Subject_id aespid;
	where AEACNND_DEC="未治疗";
run;

proc sort data=cdm.prn_cm out=prn_cm(keep=Subject_id prindc_dec praeno prstdat prongo prendat);
	by Subject_id;
	where not missing(praeno);
run;

data prn_cm_01;
	length aespid $60.;
	set prn_cm;
	aespid=scan(scan(praeno,1,","),1,"_");
	proc sort ;
	by subject_id aespid;
run;

data ae_005;
	merge ae(in=a) prn_cm_01;
	by subject_id aespid;
	if a;
	if not missing(aeterm1) then flag="1";
	else if not missing(aeterm2) then flag="2";
	else if not missing(aeterm) then flag="3";
	if not missing(praeno) then output;
run;
proc sort data=ae_005 nodupkey;
	by subject_id aespid ;
run;


*AE_06; 
proc sort data=cdm.sv out=sv(keep=Subject_id ) ;
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ae out=ae(keep=studyid site_no Visit_No Visit_Name subject_id aespid aeterm1 aeterm2 aeterm aestdat aeongo aeendat aerel aerel_dec);
	by studyid Site_No Subject_id;
/*	where aerel="1";*/
run;
data ae_06;
	merge sv ae(in=a);
	by subject_id;
	if a;
run;

proc freq data=ae_06 order=freq;
	tables aerel*aeterm1 ;
run;
proc freq data=ae_06 order=freq;
	tables aerel*aeterm2 ;
run;
proc freq data=ae_06 order=freq;
	tables aerel*aeterm ;
run;

data ae_07;
	set ae_06;
	if not missing(aeterm2) and aerel="2" then output;
	else if aeterm="咳嗽" and aerel="1" then output;
run;

proc sort data=ae_07 out=ae_006 nodupkey;
	by subject_id aespid aestdat;
run;




*AE_007;
/*proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id  ) ;*/
/*	by studyid Site_No Subject_id;*/
/*run;*/
proc sort data=cdm.ae out=ae(keep=studyid site_no subject_id Visit_No Visit_Name aespid aeterm1 aeterm2 aeterm aesi);
	by studyid Site_No Subject_id;
run;

data ae_007;
	set ae;
	by subject_id;
	if aesi="Y" then output;
run;

*AE_008;
proc sort data=cdm.sv out=sv(keep= Subject_id ) ;
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ae out=ae(keep=studyid site_no subject_id  Visit_No Visit_Name aespid aeterm1 aeterm2 aeterm aetoxgr);
	by studyid Site_No Subject_id;
run;

data ae_008;
	merge sv ae(in=a);
	by subject_id;
	if a;
run;
proc sort data=ae_008 nodupkey;
	by subject_id visit_name aespid;
run;


*AE_DS_001;

/*proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id  ) ;*/
/*	by studyid Site_No Subject_id;*/
/*run;*/
proc sort data=cdm.ds out=ds(keep=studyid site_no  subject_id Visit_No Visit_Name dsyn dsyn_dec dsstdat dsdecod_dec dsdecodo);
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ae out=ae(keep=studyid site_no subject_id Visit_No Visit_Name aespid aeterm1 aeterm2 aestdat aeongo aeendat aeser aedis);
	by studyid Site_No Subject_id;
	where aedis="Y";
run;

data ae_ds_001;
	merge ds ae(in=a);
	by studyid Site_No Subject_id;
	if a;
	if dsyn="2" then do;
		if not missing(dsdecod_dec) then flag="2";
		else if not missing(dsdecodo) then flag="3";
		else if dsstdat < aestdat or not missing(aeendat) and dsstdat>aeendat then flag="4";
	end;
	if dsyn="1" then flag="1";
	if not missing(flag) then output;
	drop dsyn;
	retain studyid site_no subject_id visit_no visit_name aespid aeterm1 aeterm2 aestdat aeongo aeendat aeser aedis dsyn_dec dsstdat dsdecod_dec dsdecodo;
run;

*AE_DS_002;
proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id ) ;
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ds out=ds(keep=studyid site_no subject_id Visit_No Visit_Name dsyn dsstdat dsdecod dsdecod_dec dsdecodo);
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ae out=ae(keep=studyid site_no subject_id aespid aeterm1 aeterm2 aeterm aestdat aeongo aeendat aeser aedis aerel aerel_dec);
	by studyid Site_No Subject_id;
run;

data ae_ds_002;
	merge ds ae(in=a);
	by studyid Site_No Subject_id;
	if a;
	if dsdecod=6 and aeser="N" then flag="1";
	else if dsdecod=6 and aeser="Y" and aedis="Y" and aerel="2" then flag="2";
	if not missing(flag) then output;
	drop dsdecod aerel;
	retain studyid Site_No Subject_id Visit_No Visit_Name  dsyn dsstdat dsdecod_dec dsdecodo aespid aeterm1 aeterm2 aeterm aestdat aeongo aeendat aeser aedis aerel_dec;
run;

*AE_EX_001;
proc sort data=cdm.sv out=sv(keep=studyid Site_No Subject_id ) ;
	by studyid Site_No Subject_id;
run;
proc sort data=cdm.ds out=ds(keep=studyid site_no subject_id dsyn dsstdat dsdecod);
	by studyid Site_No Subject_id;
run;

proc sort data=cdm.ae out=ae(keep=Form_seq studyid site_no Visit_No Visit_Name subject_id aespid aeterm1 aeterm2 aestdat aeongo aeendat aeser aedis aerel);
	by studyid Site_No Subject_id;
run;

proc sort data=cdm.ex out=ex(keep=studyid site_no subject_id exstdat);
	by studyid Site_No Subject_id;
	where visit_name="V1(D0)";
run;

data ae_ex_001;
	retain studyid site_no subject_id visit_no visit_name Form_seq
	DSYN DSSTDAT DSDECOD AESPID AETERM1 AETERM2 AESTDAT AEONGO AEENDAT AESER AEDIS AEREL EXSTDAT;
	merge sv ds ae(in=a) ex;
	by studyid Site_No Subject_id;
	if not missing(aeterm) and (input(aestdat,yymmdd10.)-input(exstdat,yymmdd10.))>14 then output;
	if a;
	keep studyid site_no subject_id visit_name visit_no Form_seq
	DSYN DSSTDAT DSDECOD AESPID AETERM1 AETERM2 AESTDAT AEONGO AEENDAT AESER AEDIS AEREL EXSTDAT;
run;
proc sort data=ae_ex_001 nodupkey;
	by studyid Site_No Subject_id;
run;

*调整列排序;

*LB_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id) ;
	by studyid Site_No Subject_id;
	where visit_name="筛选期";
run;
proc sort data=cdm.pe out=pe(keep=subject_id visit_no visit_name peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (peres_1="3" or peres_2="3" or peres_3="3" or peres_4="3" or peres_5="3" or peres_6="3" or peres_7="3" );
run;
proc sort data=cdm.rand out=rand01(keep=subject_id visit_no visit_name randyn_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期";
run;
proc sort data=cdm.ie out=ie(keep=subject_id visit_no visit_name IEYN_DEC);
	by studyid Site_No Subject_id;
	where visit_name="筛选期";
run;
proc sort data=cdm.mh out=mh(keep=subject_id visit_no visit_name MHSPID MHTERM MHSTDAT MHONGO MHENDAT);
	by studyid Site_No Subject_id;
	where visit_name="筛选期";
run;
data lb_pe_01;
	merge sv pe;
	by subject_id ;
	if not missing(peres_1 ) or not missing(peres_2 ) or not missing(peres_3 ) 
	or not missing(peres_4 ) or not missing(peres_5 ) or 
	not missing(peres_6 ) or not missing(peres_7 )  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7;
run;
proc sort data=lb_pe_01;
	by subject_id visit_name;
run;

proc transpose data=lb_pe_01 out=lb_pe_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_pe_001;
	merge lb_pe_02(in=a) mh rand01 ie;
	by subject_id;
	if a;
run;


proc sort data=cdm.lb_hem out=lb_hem(keep=subject_id visit_no visit_name lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (lbclsig_wbc="3" or lbclsig_rbc="3" or lbclsig_hgb="3" or lbclsig_plat="3" or lbclsig_lym="3" or lbclsig_neut="3");
run;
data lb_hem_01;
	merge sv lb_hem;
	by subject_id visit_no visit_name;
	if not missing(lbclsig_wbc_dec ) or not missing(lbclsig_rbc_dec ) or not missing(lbclsig_hgb_dec ) 
	or not missing(lbclsig_plat_dec ) or not missing(lbclsig_lym_dec ) or 
	not missing(lbclsig_neut_dec )  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	  lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec;
run;
proc sort data=lb_hem_01;
	by subject_id visit_name;
run;

proc transpose data=lb_hem_01 out=lb_hem_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_hem_001;
	merge lb_hem_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
run;

proc sort data=cdm.lb_che out=lb_che(keep=subject_id visit_no visit_name lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (lbclsig_alt="3" or lbclsig_gluc="3" or lbclsig_creat="3" or lbclsig_ast="3" or lbclsig_bili="3");
run;
data lb_che_01;
	merge sv lb_che;
	by subject_id visit_no visit_name;
	if not missing(lbclsig_alt_dec ) or not missing(lbclsig_ast_dec ) or not missing(lbclsig_bili_dec) or not missing(lbclsig_gluc_dec ) or not missing( lbclsig_creat_dec)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec;
run;
proc sort data=lb_che_01;
	by subject_id visit_name;
run;

proc transpose data=lb_che_01 out=lb_che_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_che_001;
	merge lb_che_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
run;

proc sort data=cdm.lb_uri out=lb_uri(keep=subject_id visit_no visit_name lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (lbclsig_uwbc="3" or lbclsig_urbc="3" or lbclsig_uprot="3");
run;
data lb_uri_01;
	merge sv lb_uri;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_uwbc_dec ) or not missing( lbclsig_urbc_dec) 
	or not missing(lbclsig_uprot_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec;
run;
proc sort data=lb_uri_01;
	by subject_id visit_name;
run;

proc transpose data=lb_uri_01 out=lb_uri_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_uri_001;
	merge lb_uri_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
run;

proc sort data=cdm.lb_tn out=lb_tn(keep=subject_id visit_no visit_name lbclsig_troponin_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and lbclsig_troponin="3";
run;
data lb_tn_01;
	merge sv lb_tn;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_troponin_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_troponin_dec;
run;
proc sort data=lb_tn_01;
	by subject_id visit_name;
run;

proc transpose data=lb_tn_01 out=lb_tn_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_tn_001;
	merge lb_tn_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.lb_coa out=lb_coa(keep=subject_id visit_no visit_name lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (lbclsig_pt="3" or lbclsig_aptt="3" or lbclsig_tt="3" or lbclsig_inr="3" or lbclsig_fibrino="3" or lbclsig_ddimer="3");
run;
data lb_coa_01;
	merge sv lb_coa;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_pt_dec)  or not missing(lbclsig_aptt_dec) or not missing(lbclsig_tt_dec)
	or not missing(lbclsig_inr_dec) or not missing(lbclsig_fibrino_dec) or not missing(lbclsig_ddimer_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec;
run;
proc sort data=lb_coa_01;
	by subject_id visit_name;
run;

proc transpose data=lb_coa_01 out=lb_coa_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_coa_001;
	merge lb_coa_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;


proc sort data=cdm.lb_ft out=lb_ft(keep=subject_id visit_no visit_name lbclsig_t3fr lbclsig_t3fr_dec lbclsig_tsh lbclsig_tsh_dec lbclsig_t4fr lbclsig_t4fr_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and (lbclsig_t3fr="3" or lbclsig_tsh="3" or lbclsig_t4fr="3");
run;
data lb_ft_01;
	merge sv lb_ft(in=a);
	by subject_id ;
	if a;
	if  not missing(lbclsig_t3fr)  or not missing(lbclsig_tsh) or not missing(lbclsig_t4fr) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_t3fr lbclsig_tsh lbclsig_t4fr;
run;
proc sort data=lb_ft_01;
	by subject_id visit_name;
run;

proc transpose data=lb_ft_01 out=lb_ft_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_ft_001;
	merge lb_ft_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.eg out=eg(keep=subject_id visit_no visit_name egclsig egclsig_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and egclsig="3";
run;
data eg_01;
	merge sv eg;
	by subject_id;
	if  not missing(egclsig)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	egclsig;
run;
proc sort data=eg_01;
	by subject_id visit_name;
run;

proc transpose data=eg_01 out=eg_02;
	by  subject_id visit_name;
	var _all_;
run; 
data eg_001;
	merge eg_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.mo_bu(rename=(moclsig=moclsig_bu moclsig_dec=moclsig_bu_dec)) out=mo_bu(keep=subject_id visit_no visit_name moclsig_bu moclsig_bu_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and moclsig_bu="3";
run;
data mo_bu_01;
	merge sv mo_bu;
	by subject_id ;
	if  not missing(moclsig_bu)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	moclsig_bu;
run;
proc sort data=mo_bu_01;
	by subject_id visit_name;
run;

proc transpose data=mo_bu_01 out=mo_bu_02;
	by  subject_id visit_name;
	var _all_;
run; 
data mo_bu_001;
	merge mo_bu_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.mo_ches(rename=(moclsig=moclsig_ches moclsig_dec=moclsig_ches_dec)) out=mo_ches(keep=subject_id visit_no visit_name moclsig_ches moclsig_ches_dec);
	by studyid Site_No Subject_id;
	where visit_name="筛选期" and moclsig_ches="3" ;
run;
data mo_ches_01;
	merge sv mo_ches;
	by subject_id ;
	if  not missing(moclsig_ches)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	moclsig_ches;
run;
proc sort data=mo_ches_01;
	by subject_id visit_name;
run;

proc transpose data=mo_ches_01 out=mo_ches_02;
	by  subject_id visit_name;
	var _all_;
run; 
data mo_ches_001;
	merge mo_ches_02(in=a) mh rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;
/*data lb_01;*/
/*	merge sv lb_hem lb_che lb_uri lb_ft eg mo_bu mo_ches mh pe lb_tn lb_coa rand01;*/
/*	by subject_id visit_no visit_name;*/
/*	if not missing(lbclsig_wbc_dec ) or not missing(lbclsig_rbc_dec ) or not missing(lbclsig_hgb_dec ) */
/*	or not missing(lbclsig_plat_dec ) or not missing(lbclsig_lym_dec ) or */
/*	not missing(lbclsig_neut_dec ) or not missing(lbclsig_gluc_dec ) or not missing( lbclsig_creat_dec) or not missing(lbclsig_alt_dec )*/
/*	or not missing(lbclsig_ast_dec ) or not missing(lbclsig_bili_dec) or not missing(lbclsig_uwbc_dec ) or not missing( lbclsig_urbc_dec) */
/*	or not missing(lbclsig_uprot_dec) or not missing(lbclsig_troponin_dec) or not missing(MOCLSIG_BU_DEC)*/
/*	or not missing(EGCLSIG_DEC) or not missing(MOCLSIG_CHES_DEC) then output;*/
/*	retain studyid site_no subject_id randyn_dec visit_no visit_name */
/*	 peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7*/
/*	 lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec*/
/*	 lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec*/
/*	 lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec*/
/*	 lbclsig_troponin_dec*/
/*	 lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec*/
/*	 lbclsig_t3fr_dec lbclsig_tsh_dec lbclsig_t4fr_dec*/
/*	 egclsig_dec*/
/*	 moclsig_bu_dec*/
/*	 moclsig_ches_dec*/
/*	 MHSPID MHTERM MHSTDAT MHONGO MHENDAT;*/
/*run;*/
/* */
/*proc sort data=lb_01;*/
/*	by studyid site_no subject_id visit_no visit_name;*/
/*run;*/
/**/
/*proc transpose data=lb_01 out=lb_001;*/
/*	by studyid site_no subject_id visit_no visit_name;*/
/*	var _all_;*/
/*run; */
/*      */

*Lb_002;

proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id visit_no visit_name) ;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期";
run;
proc sort data=cdm.ae out=ae(keep=Subject_id visit_no visit_name aespid aeterm1 aeterm2 aeterm aestdat aeongo aeendat);
	by studyid Site_No Subject_id;
	where visit_name^="筛选期";
run;
proc sort data=cdm.rand out=rand01(keep=subject_id visit_no visit_name randyn_dec);
	by studyid Site_No Subject_id;
	where visit_name^="筛选期";
run;
proc sort data=cdm.ie out=ie(keep=subject_id visit_no visit_name IEYN_DEC);
	by studyid Site_No Subject_id;
	where visit_name^="筛选期";
run;
proc sort data=cdm.pe out=pe(keep=subject_id visit_no visit_name peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and (peres_1="3" or peres_2="3" or peres_3="3" or peres_4="3" or peres_5="3" or peres_6="3" or peres_7="3") ;
run;
data lb_pe_01;
	merge sv pe(in=a) rand01;
	if a;
	by subject_id visit_no visit_name;
	if not missing(peres_1 ) or not missing(peres_2 ) or not missing(peres_3 ) 
	or not missing(peres_4 ) or not missing(peres_5 ) or 
	not missing(peres_6 ) or not missing(peres_7 )  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7;
run;
proc sort data=lb_pe_01;
	by subject_id visit_no visit_name;
run;

proc transpose data=lb_pe_01 out=lb_pe_02;
	by  subject_id visit_no visit_name;
	var _all_;
run; 
data lb_pe_002;
	merge lb_pe_02(in=a) ae rand01 ie;
	by subject_id visit_no visit_name;
	if a;
	if missing(subject_id) then delete;
run;


proc sort data=cdm.lb_hem out=lb_hem(keep=subject_id Visit_No Visit_Name lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and (lbclsig_wbc="3" or lbclsig_rbc="3" or lbclsig_hgb="3" or lbclsig_plat="3" or lbclsig_lym="3" or lbclsig_neut="3" );
run;

data lb_hem_01;
	merge sv lb_hem;
	by subject_id visit_no visit_name;
	if not missing(lbclsig_wbc_dec ) or not missing(lbclsig_rbc_dec ) or not missing(lbclsig_hgb_dec ) 
	or not missing(lbclsig_plat_dec ) or not missing(lbclsig_lym_dec ) or 
	not missing(lbclsig_neut_dec )  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	  lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec;
run;
proc sort data=lb_hem_01;
	by subject_id visit_name;
run;

proc transpose data=lb_hem_01 out=lb_hem_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_hem_002;
	merge lb_hem_02(in=a) ae rand01 ie;
	by subject_id;
	if a;
run;

proc sort data=cdm.lb_che out=lb_che(keep=subject_id visit_no visit_name lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec) nodupkey;
	by studyid Site_No Subject_id visit_name;
	where visit_name^="筛选期" and (lbclsig_gluc="3" or lbclsig_creat="3" or lbclsig_alt="3" or lbclsig_ast="3" or lbclsig_bili="3") ;
run;
data lb_che_01;
	merge sv lb_che rand01;
	by subject_id visit_no visit_name;
	if not missing(lbclsig_alt_dec ) or not missing(lbclsig_ast_dec ) or not missing(lbclsig_bili_dec) or not missing(lbclsig_gluc_dec ) or not missing( lbclsig_creat_dec)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec;
run;
proc sort data=lb_che_01;
	by subject_id visit_name;
run;

proc transpose data=lb_che_01 out=lb_che_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_che_002;
	merge lb_che_02(in=a) ae  ie;
	by subject_id;
	if a;
run;




proc sort data=cdm.lb_uri out=lb_uri(keep=subject_id visit_no visit_name lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and (lbclsig_uwbc="3" or lbclsig_urbc="3" or lbclsig_uprot="3");
run;
data lb_uri_01;
	merge sv lb_uri;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_uwbc_dec ) or not missing( lbclsig_urbc_dec) 
	or not missing(lbclsig_uprot_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec;
run;
proc sort data=lb_uri_01;
	by subject_id visit_name;
run;

proc transpose data=lb_uri_01 out=lb_uri_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_uri_002;
	merge lb_uri_02(in=a) ae rand01 ie;
	by subject_id ;
	if a;
run;


proc sort data=cdm.lb_tn out=lb_tn(keep=subject_id visit_no visit_name lbclsig_troponin_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and lbclsig_troponin="3";
run;
data lb_tn_01;
	merge sv lb_tn;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_troponin_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_troponin_dec;
run;
proc sort data=lb_tn_01;
	by subject_id visit_name;
run;

proc transpose data=lb_tn_01 out=lb_tn_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_tn_002;
	merge lb_tn_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.lb_coa out=lb_coa(keep=subject_id visit_no visit_name lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and (lbclsig_pt="3" or lbclsig_aptt="3" or lbclsig_tt="3" or lbclsig_inr="3" or lbclsig_fibrino="3" or lbclsig_ddimer="3" );
run;
data lb_coa_01;
	merge sv lb_coa;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_pt_dec)  or not missing(lbclsig_aptt_dec) or not missing(lbclsig_tt_dec)
	or not missing(lbclsig_inr_dec) or not missing(lbclsig_fibrino_dec) or not missing(lbclsig_ddimer_dec) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	 lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec;
run;
proc sort data=lb_coa_01;
	by subject_id visit_name;
run;

proc transpose data=lb_coa_01 out=lb_coa_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_coa_002;
	merge lb_coa_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;


proc sort data=cdm.lb_ft out=lb_ft(keep=subject_id visit_no visit_name lbclsig_t3fr_dec lbclsig_tsh_dec lbclsig_t4fr_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and (lbclsig_t3fr="3" or lbclsig_tsh="3" or lbclsig_t4fr="3");
run;
data lb_ft_01;
	merge sv lb_ft;
	by subject_id visit_no visit_name;
	if  not missing(lbclsig_t3fr)  or not missing(lbclsig_tsh) or not missing(lbclsig_t4fr) then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	lbclsig_t3fr lbclsig_tsh lbclsig_t4fr;
run;
proc sort data=lb_ft_01;
	by subject_id visit_name;
run;

proc transpose data=lb_ft_01 out=lb_ft_02;
	by  subject_id visit_name;
	var _all_;
run; 
data lb_ft_002;
	merge lb_ft_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.eg out=eg(keep=subject_id visit_no visit_name egclsig_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and egclsig="3";
run;
data eg_01;
	merge sv eg;
	by subject_id visit_no visit_name;
	if  not missing(egclsig)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	egclsig;
run;
proc sort data=eg_01;
	by subject_id visit_name;
run;

proc transpose data=eg_01 out=eg_02;
	by  subject_id visit_name;
	var _all_;
run; 
data eg_002;
	merge eg_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.mo_bu(rename=(moclsig=moclsig_bu  moclsig_dec=moclsig_bu_dec)) out=mo_bu(keep=subject_id visit_no visit_name moclsig_bu_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and moclsig_bu="3";
run;
data mo_bu_01;
	merge sv mo_bu;
	by subject_id visit_no visit_name;
	if  not missing(moclsig_bu)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	moclsig_bu;
run;
proc sort data=mo_bu_01;
	by subject_id visit_name;
run;

proc transpose data=mo_bu_01 out=mo_bu_02;
	by  subject_id visit_name;
	var _all_;
run; 
data mo_bu_002;
	merge mo_bu_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

proc sort data=cdm.mo_ches(rename=(moclsig=moclsig_ches moclsig_dec=moclsig_ches_dec)) out=mo_ches(keep=subject_id visit_no visit_name moclsig_ches_dec) nodupkey;
	by studyid Site_No Subject_id;
	where visit_name^="筛选期" and moclsig_ches="3" ;
run;
data mo_ches_01;
	merge sv mo_ches;
	by subject_id visit_no visit_name;
	if  not missing(moclsig_ches)  then output;
	retain studyid site_no subject_id randyn_dec visit_no visit_name 
	moclsig_ches;
run;
proc sort data=mo_ches_01;
	by subject_id visit_name;
run;

proc transpose data=mo_ches_01 out=mo_ches_02;
	by  subject_id visit_name;
	var _all_;
run; 
data mo_ches_002;
	merge mo_ches_02(in=a) ae rand01 ie;
	by subject_id visit_name;
	if a;
	if missing(subject_id) then delete;
run;

/**/
/*data lb_002_1;*/
/*	merge sv pe lb_hem lb_che lb_uri lb_tn lb_coa lb_ft eg mo_bu mo_ches ae(in=a);*/
/*	by subject_id;*/
/*	if a;*/
/*	if not missing(lbclsig_wbc_dec ) or not missing(lbclsig_rbc_dec ) or not missing(lbclsig_hgb_dec ) */
/*	or not missing(lbclsig_plat_dec ) or not missing(lbclsig_lym_dec ) or */
/*	not missing(lbclsig_neut_dec ) or not missing(lbclsig_gluc_dec ) or not missing( lbclsig_creat_dec) or not missing(lbclsig_alt_dec )*/
/*	or not missing(lbclsig_ast_dec ) or not missing(lbclsig_bili_dec) or not missing(lbclsig_uwbc_dec ) or not missing( lbclsig_urbc_dec) */
/*	or not missing(lbclsig_uprot_dec) or not missing(lbclsig_troponin_dec) or not missing(lbclsig_t4fr_dec) then output;*/
/*	retain studyid site_no subject_id visit_no visit_name form_seq*/
/*	 peres_1 peres_2 peres_3 peres_4 peres_5 peres_6 peres_7*/
/*	 lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec*/
/*	 lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec*/
/*	 lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec*/
/*	 lbclsig_troponin_dec*/
/*	 lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec*/
/*	 lbclsig_t3fr_dec lbclsig_tsh_dec lbclsig_t4fr_dec*/
/*	 egclsig_dec*/
/*	 moclsig_bu_dec*/
/*	 moclsig_ches_dec*/
/*	 aespid aeterm1 aeterm2 aeterm aestdat aeongo aeendat;*/
/*run;*/
/**/
/*proc sort data=lb_002_1 ;*/
/*	by subject_id aestdat aeendat LBCLSIG_ALT_DEC;*/
/*run;*/
/**/
/*proc sql noprint;*/
/*	create table lb_002_2 as */
/*	select distinct studyid ,site_no, subject_id ,visit_no ,visit_name ,form_seq,*/
/*	 peres_1, peres_2 ,peres_3 ,peres_4, peres_5, peres_6 ,peres_7,*/
/*	 lbclsig_wbc_dec ,lbclsig_rbc_dec, lbclsig_hgb_dec, lbclsig_plat_dec ,lbclsig_lym_dec,  lbclsig_neut_dec,*/
/*	 lbclsig_gluc_dec ,lbclsig_creat_dec ,lbclsig_alt_dec, lbclsig_ast_dec ,lbclsig_bili_dec,*/
/*	 lbclsig_uwbc_dec, lbclsig_urbc_dec ,lbclsig_uprot_dec,*/
/*	 lbclsig_troponin_dec,*/
/*	 lbclsig_pt_dec, lbclsig_aptt_dec, lbclsig_tt_dec ,lbclsig_inr_dec ,lbclsig_fibrino_dec, lbclsig_ddimer_dec,*/
/*	 lbclsig_t3fr_dec, lbclsig_tsh_dec ,lbclsig_t4fr_dec,*/
/*	 egclsig_dec,*/
/*	 moclsig_bu_dec,*/
/*	 moclsig_ches_dec,*/
/*	 aespid ,aeterm1 ,aeterm2 ,aeterm ,aestdat ,aeongo ,aeendat*/
/*	from lb_002_1;*/
/*quit;*/
/**/
/*proc sort data=lb_002_2;*/
/*	by studyid site_no subject_id visit_no visit_name aestdat;*/
/*run;*/
/**/
/*proc transpose data=lb_002_2 out=lb_002;*/
/*	by studyid site_no subject_id visit_no visit_name aestdat;*/
/*	var _all_;*/
/*run; */

*lb_003;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id) ;
	by studyid Site_No Subject_id ;
run;
proc sort data=cdm.lb_hem out=lb_hem_01;
	by Subject_id lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec lbdat LBNAM_DEC;
run;
proc transpose data=lb_hem_01 out=lb_hem_02;
	by Subject_id lbclsig_wbc_dec lbclsig_rbc_dec lbclsig_hgb_dec lbclsig_plat_dec lbclsig_lym_dec  lbclsig_neut_dec lbdat LBNAM_DEC;
	var visit_name;
run;

data lb_hem;
	set lb_hem_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;

proc sort data=cdm.lb_che out=lb_che_01;
	by Subject_id lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec lbdat LBNAM_DEC;
run;
proc transpose data=lb_che_01 out=lb_che_02;
	by Subject_id  lbclsig_gluc_dec lbclsig_creat_dec lbclsig_alt_dec lbclsig_ast_dec lbclsig_bili_dec lbdat LBNAM_DEC;
	var visit_name;
run;
data lb_che;
	set lb_che_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;

proc sort data=cdm.lb_uri out=lb_uri_01;
	by Subject_id lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec lbdat LBNAM_DEC ;
run;
proc transpose data=lb_uri_01 out=lb_uri_02;
	by Subject_id lbclsig_uwbc_dec lbclsig_urbc_dec lbclsig_uprot_dec lbdat LBNAM_DEC;
	var visit_name;
run;
data lb_uri;
	set lb_uri_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;

proc sort data=cdm.lb_tn out=lb_tn_01;
	by Subject_id lbclsig_troponin_dec lbdat LBNAM_DEC;
run;
proc transpose data=lb_tn_01 out=lb_tn_02;
	by Subject_id lbclsig_troponin_dec lbdat LBNAM_DEC;
	var visit_name;
run;
data lb_tn;
	set lb_tn_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;	 

proc sort data=cdm.lb_coa out=lb_coa_01;
	by Subject_id lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec lbdat LBNAM_DEC ;
run;
proc transpose data=lb_coa_01 out=lb_coa_02;
	by Subject_id lbclsig_pt_dec lbclsig_aptt_dec lbclsig_tt_dec lbclsig_inr_dec lbclsig_fibrino_dec lbclsig_ddimer_dec lbdat LBNAM_DEC ;
	var visit_name;
run;
data lb_coa;
	set lb_coa_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;	 
proc sort data=cdm.lb_ft out=lb_ft_01;
	by Subject_id lbclsig_t3fr_dec lbclsig_tsh_dec lbclsig_t4fr_dec lbdat LBNAM_DEC;
run;
proc transpose data=lb_ft_01 out=lb_ft_02;
	by Subject_id  lbclsig_t3fr_dec lbclsig_tsh_dec lbclsig_t4fr_dec lbdat LBNAM_DEC ; 
	var visit_name;
run;
data lb_ft;
	set lb_ft_02;
	if lbnam_dec^="" and lbnam_dec ne "蚌埠医学院第二附属医院 - 01" then output;
run;

data lb_003;
	set  lb_hem lb_che lb_uri lb_tn lb_coa lb_ft;
	by Subject_id ;
run;
/*proc sort data=lb_03;*/
/*	by subject_id;*/
/*run;*/
/**/
/*proc transpose data=lb_03 out=lb_003;*/
/*	by subject_id;*/
/*	var _all_;*/
/*run; */


*lb_004;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id) ;
	by Subject_id visit_no visit_name;
run;
proc sort data=cdm.lb_hem out=lb_hem;
	by studyid Site_No Subject_id;
	where not missing(lborres_wbc) or not missing(lborres_rbc) or not missing(lborres_hgb) or not missing(lborres_plat) or not missing(lborres_lym) or not missing(lborres_neut);
run;
data lb_hem_01;
	set lb_hem;
	if missing(lborresu_wbc) or missing(lborresu_rbc) or missing(lborresu_hgb) or missing(lborresu_plat) or missing(lborresu_lym) or missing(lborresu_neut) then output;
run;
proc sort data=cdm.lb_che out=lb_che;
	by studyid Site_No Subject_id;
	where not missing(lborres_gluc) or not missing(lborres_creat) or not missing(lborres_alt) or not missing(lborres_ast) or not missing(lborres_bili) ;
run;
data lb_che_01;
	set lb_che;
	if missing(lborresu_gluc) or missing(lborresu_creat) or missing(lborresu_alt) or missing(lborresu_ast) or missing(lborresu_bili) then output;
run;

proc sort data=cdm.lb_uri out=lb_uri;
	by studyid Site_No Subject_id;
	where not missing(lborres_uwbc) or not missing(lborres_urbc) or not missing(lborres_uprot);
run;
data lb_uri_01;
	set lb_uri;
	if missing(lborresu_uwbc) or missing(lborresu_urbc) or missing(lborresu_uprot) then output;
run;

proc sort data=cdm.lb_tn out=lb_tn;
	by studyid Site_No Subject_id;
	where not missing(lborres_troponin);
run;
data lb_tn_01;
	set lb_tn;
	if missing(lborresu_troponin)  then output;
run;

proc sort data=cdm.lb_coa out=lb_coa;
	by studyid Site_No Subject_id;
	where not missing(lborres_pt) or not missing(lborres_aptt) or not missing(lborres_tt) or not missing(lborres_inr) or not missing(lborres_fibrino) or not missing(lborres_ddimer);
run;
data lb_coa_01;
	set lb_coa;
	if missing(lborresu_pt) or missing(lborresu_aptt) or missing(lborresu_tt) or missing(lborresu_inr) or missing(lborresu_fibrino) or missing(lborresu_ddimer)
	or  missing(lbornrlo_pt) or missing(lbornrlo_aptt) or missing(lbornrlo_tt) or missing(lbornrlo_inr) or missing(lbornrlo_fibrino) or missing(lbornrlo_ddimer)
	or  missing(lbornrhi_pt) or missing(lbornrhi_aptt) or missing(lbornrhi_tt) or missing(lbornrhi_inr) or missing(lbornrhi_fibrino) or missing(lbornrhi_ddimer)
	then output;
run;

proc sort data=cdm.lb_ft out=lb_ft;
	by studyid Site_No Subject_id;
	where not missing(lborres_t3fr) or not missing(lborres_tsh) or not missing(lborres_t4fr);
run;
data lb_ft_01;
	set lb_ft;
	if missing(lborresu_t3fr) or missing(lborresu_tsh) or missing(lborresu_t4fr)
	or missing(lbornrlo_tsh) or missing(lbornrlo_t3fr) or missing(lbornrlo_t4fr)
	or missing(lbornrhi_tsh) or missing(lbornrhi_t3fr) or missing(lbornrhi_t4fr)
	then output;
run;

data lb_04;
	merge lb_hem_01(in=a) lb_che_01(in=b) lb_uri_01(in=c) lb_ft_01(in=d) lb_coa_01(in=e) lb_tn_01(in=f);
	by subject_id visit_no visit_name;
	drop form_seq submit_date update_date form_status form_status_dec lbperf lbperf_dec lbreasnd lbreasnd_dec lbreando;
	if a then flag="1";
	else if b then flag="2";
	else if c then flag="3";
	else if d then flag="4";
	else if e then flag="5";
	else if f then flag="6";
run;

proc sort data=lb_04;
	by studyid site_no subject_id visit_no visit_name;
run;
data lb_hem_05;
	set lb_04;
	keep studyid Site_No Subject_id visit_no visit_name lborresu_wbc lborresu_rbc lborresu_hgb lborresu_plat lborresu_lym lborresu_neut
	lbtest_wbc lbtest_rbc lbtest_hgb lbtest_plat lbtest_lym lbtest_neut 
	lborres_wbc lborres_rbc lborres_hgb lborres_plat lborres_lym lborres_neut 
	lbornrlo_wbc lbornrlo_rbc lbornrlo_hgb lbornrlo_plat lbornrlo_lym lbornrlo_neut 
	lbornrhi_wbc lbornrhi_rbc lbornrhi_hgb lbornrhi_plat lbornrhi_lym lbornrhi_neut 
	flag;
run;
proc transpose data=lb_hem_05 out=lb_hem_004;
	by studyid site_no subject_id visit_no visit_name;
	where flag="1";
	var _all_;
run;

proc transpose data=lb_04 out=lb_05;
	by studyid site_no subject_id visit_no visit_name;
	where flag="2";
	var _all_;
run;
data lb_che_004;
	set lb_05;
	if not missing(subject_id) then output;
run;
proc transpose data=lb_04 out=lb_uri_05;
	by studyid site_no subject_id visit_no visit_name;
	where flag="3";
	var _all_;
run;
data lb_uri_004;
	set lb_uri_05;
	if not missing(subject_id) then output;
run;
proc transpose data=lb_04 out=lb_ft_05;
	by studyid site_no subject_id visit_no visit_name;
	where flag="4";
	var _all_;
run;
data lb_ft_004;
	set lb_ft_05;
	if not missing(subject_id) then output;
run;
proc transpose data=lb_04 out=lb_coa_05;
	by studyid site_no subject_id visit_no visit_name;
	where flag="5";
	var _all_;
run;
data lb_coa_004;
	set lb_coa_05;
	if not missing(subject_id) then output;
run;
proc transpose data=lb_04 out=lb_tn_05;
	by studyid site_no subject_id visit_no visit_name;
	where flag="6";
	var _all_;
run;
data lb_tn_004;
	set lb_tn_05;
	if not missing(subject_id) then output;
run;

*LB_005;

*LB_006;

*DS_001;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq svdat) ;
	by Site_No Subject_id Visit_No;
run;
proc sort data=cdm.ds out=ds(keep=studyid Site_No subject_id visit_no dsstdat);
	by Site_No Subject_id Visit_No;
run;
data ds_001;
	merge sv ds(in=a);
	by Site_No Subject_id Visit_No;
	if a;
	if dsstdat < max(svdat);
run;

*DS_002;
proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq) ;
	by Site_No Subject_id Visit_No;
run;
proc sort data=cdm.sv_next out=sv_next(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq svnext) ;
	by Site_No Subject_id Visit_No;
	where visit_name="V6(D90)";
run; 
proc sort data=cdm.ds out=ds(keep=studyid Site_No subject_id visit_no dsyn);
	by Site_No Subject_id Visit_No;
run;

data ds_002;
	merge sv sv_next(in=a) ds(in=b);
	by Site_No Subject_id Visit_No;
	if a or b;
	if dsyn=1 and svnext="否" then output;
	else if dsyn=2 and svnext="是" then output;
run;
*ALL_001;
/*proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id Visit_No Visit_Name Form_Seq) ;*/
/*	by Site_No Subject_id Visit_No;*/
/*run;*/


*MH_001;

/*proc sort data=cdm.sv out=sv(keep=STUDYID Site_No Subject_id visit_name) ;*/
/*	by Site_No Subject_id Visit_Name ;*/
/*run;*/

proc sort data=cdm.mh(rename=(mhstdat=mhstdat01)) out=mh(keep=STUDYID Site_No Subject_id  Visit_No Visit_Name Form_Seq MHSPID MHTERM MHSTDAT01 MHONGO MHENDAT);
	by Site_No Subject_id Visit_No mhstdat01;
	where not missing(mhterm);
run;

data mh_01;
	retain STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq mhspid mhterm mhstdat mhongo mhendat; 
	set mh;
	by  Subject_id visit_name;
/*	if a;*/
	if index(mhstdat01,"UK")=0 then mhstdat=mhstdat01;
	else if 1>=index(mhstdat01,"UK")>0 then mhstdat=substr(mhstdat01,1,8);
	else if index(mhstdat01,"UK")>1 then mhstdat=substr(mhstdat01,1,4);	
	mhterm_lag=lag(mhterm);
	mhstdat_lag=lag(mhstdat);
	mhendat_lag=lag(mhendat);
	if first.subject_id then do;
	mhterm_lag="";
	mhstdat_lag="";
	mhendat_lag="";
	end;

	if mhterm=mhterm_lag then do;
	if mhstdat <= mhstdat_lag <=mhendat_lag then output;
	if mhstdat <= mhendat_lag<=mhendat then output;
	if mhendat="" or mhendat_lag="" then output;
	end;
	
	if missing(mhstdat) then delete;
	keep STUDYID Site_No Subject_Id Visit_No Visit_Name Form_Seq mhspid mhterm mhstdat mhongo mhendat;
	label STUDYID="项目ID" Site_No="中心编号" Subject_Id="筛选号" Visit_No="访视编号" Visit_Name="访视名称"
	Form_Seq="表单序号" mhspid="编号" mhterm="疾病名称" mhstdat="开始日期" mhongo="目前是否存在" mhendat="结束日期";
run;

proc sort data=mh_01 out=mh_001 nouniquekey;
	by Subject_id mhterm;
run;


/*proc sql noprint;*/
/*	create table mh_001 as */
/*	select distinct STUDYID,Site_No ,Subject_Id ,Visit_No ,Visit_Name,*/
/*	Form_Seq ,mhspid ,mhterm ,mhstdat, mhongo ,mhendat*/
/*	from mh_01;*/
/*quit;*/



proc sql noprint ; 
  select compress(put(datepart(CRDATE),yymmdd10.),'-') into :extdate from sashelp.vtable 
    where LIBNAME='CDM' & MEMNAME='DM';
quit ;
%put &extdate. ;	



ods escapechar='*';*定义触发字符;
%let bold_style=~S={font_size=8pt}~;
filename fbout "&root.Output\MM_Listing_&extdate..xlsx";

*embedded_titles="on"：加入标题  index='yes',添加索引？？？ ;
ods excel file=fbout style=HTMLBLUECML options(embedded_titles="on" index='yes' /*contents="yes"*/ );


%macro listing (data= ,sheet=);
*autofilter='all'：设置筛选下拉菜单,frozen_headers="on"冻结首行，center_vertical是否垂直居中显示，center_horizontal水平居中显示;
ods excel options(sheet_name="&sheet" autofilter="all" frozen_headers="on" center_vertical= 'off' center_horizontal= 'off');
ods proclabel= "&sheet";*替换标签;
title1 j=l "&sheet" ;
title2 j=l  link="#'索引'!A1" height=2 underlin=3 "返回索引"  ;*link="#'索引'!A1",链接到索引;

proc report data=&data nowd;
    columns _all_ ;
  run;
%mend;



%listing(data=AE_001 ,sheet=AE_001);
%listing(data=AE_002 ,sheet=AE_002);
%listing(data=AE_003 ,sheet=AE_003);
%listing(data=AE_004 ,sheet=AE_004);
%listing(data=AE_005 ,sheet=AE_005);
%listing(data=AE_006 ,sheet=AE_006);
%listing(data=AE_007 ,sheet=AE_007);
%listing(data=AE_008 ,sheet=AE_008);

%listing(data=AE_DS_001 ,sheet=AE_DS_001);
%listing(data=AE_DS_002 ,sheet=AE_DS_002);

%listing(data=AE_EX_001 ,sheet=AE_EX_001);

%listing(data=CM_001 ,sheet=CM_001);
/*%listing(data=ALL_001 ,sheet=ALL_001);*/

%listing(data=CM_AE_001 ,sheet=CM_AE_001);
%listing(data=CM_MH_001 ,sheet=CM_MH_001);

%listing(data=CM1_001 ,sheet=CM1_001);
%listing(data=CM2_001 ,sheet=CM2_001);
%listing(data=CM2_002 ,sheet=CM2_002);

%listing(data=DS_001 ,sheet=DS_001);
%listing(data=DS_002 ,sheet=DS_002);

/*%listing(data=LB_001,sheet=LB_001);*/
/*%listing(data=LB_002,sheet=LB_002);*/
%listing(data=lb_pe_001,sheet=lb_pe_001);
%listing(data=lb_hem_001,sheet=lb_hem_001);
%listing(data=lb_che_001,sheet=lb_che_001);
%listing(data=lb_uri_001,sheet=lb_uri_001);
%listing(data=lb_tn_001,sheet=lb_tn_001);
%listing(data=lb_coa_001,sheet=lb_coa_001);
%listing(data=lb_ft_001,sheet=lb_ft_001);
%listing(data=eg_001,sheet=eg_001);
%listing(data=mo_bu_001,sheet=mo_bu_001);
%listing(data=mo_ches_001,sheet=mo_ches_001);

%listing(data=lb_pe_002,sheet=lb_pe_002);
%listing(data=lb_hem_002,sheet=lb_hem_002);
%listing(data=lb_che_002,sheet=lb_che_002);
%listing(data=lb_uri_002,sheet=lb_uri_002);
%listing(data=lb_tn_002,sheet=lb_tn_002);
%listing(data=lb_coa_002,sheet=lb_coa_002);
%listing(data=lb_ft_002,sheet=lb_ft_002);
%listing(data=eg_002,sheet=eg_002);
%listing(data=mo_bu_002,sheet=mo_bu_002);
%listing(data=mo_ches_002,sheet=mo_ches_002);

/*%listing(data=LB_003,sheet=LB_003);*/
/*%listing(data=LB_003,sheet=LB_003);*/
/*%listing(data=LB_004,sheet=LB_004);*/
%listing(data=LB_hem_004,sheet=LB_hem_004);
%listing(data=LB_che_004,sheet=LB_che_004);
%listing(data=LB_uri_004,sheet=LB_uri_004);
%listing(data=LB_ft_004,sheet=LB_ft_004);
%listing(data=LB_coa_004,sheet=LB_coa_004);
%listing(data=LB_tn_004,sheet=LB_tn_004);

%listing(data=LB_005,sheet=LB_005);
%listing(data=LB_006,sheet=LB_006);


%listing(data=MH_001,sheet=MH_001);

%listing(data=PRN_CM_001,sheet=PRN_CM_001);
%listing(data=PRN_CM_AE_001,sheet=PRN_CM_AE_001);
%listing(data=PRN_CM_MH_001,sheet=PRN_CM_MH_001);

%listing(data=RAND_001,sheet=RAND_001);
%listing(data=RAND_002,sheet=RAND_002);

%listing(data=SV_001,sheet=SV_001);
%listing(data=SV_002,sheet=SV_002);
%listing(data=SV_003,sheet=SV_003);
%listing(data=SV_004,sheet=SV_004);
%listing(data=SV_005,sheet=SV_005);
%listing(data=SV_006,sheet=SV_006);
%listing(data=SV_007,sheet=SV_007);
%listing(data=SV_008,sheet=SV_008);

%listing(data=SV_RAND_001,sheet=SV_RAND_001);

/*%listing(data=VS_VS1_001,sheet=VS_VS1_001);*/
%listing(data=VS_VS1_LB_PG_001,sheet=VS_VS1_LB_PG_001);
ods excel close;















	
