/*******************************************************************************
THIS DO FILE INLCUDES THE CODE FOR THE ANALYSES REPORTED IN:
ELIAS-LACETERA-MACIS "Paying for Kidneys? A Randomized Survey and Choice Experiment",
American Economic Review
********************************************************************************/

clear

set more 1
cap log close
cap ssc install semean
log using $Log_final/data_analysis_final.log, replace text

global Data_orig   		"Data_orig"
global Data_final   	"Data_final"
global Log_final    	"Log_final"
global Do_final    		"Do_final"
global Tables_final   	"Tables_final"
global Figures_final	"Figures_final"

use $Data_final/ELM_dataset_final.dta, clear 

/* DESCRIPTIVE STATISTICS AND RANDOMIZATION CHECKS*/

*there are five observations for each individual (corresponding to each of teh five hypothesized kidney supply levels
*the dummy variable "one" is used for analyses with one observation per individual

*Table 1
tab cond_16 if one==1

*Table 2
tab1 female agecat* race education married children inlabforce employed unemployed income

*APPENDIX: Table B1
reg female dcond16_2-dcond16_16 if one==1
outreg2 using $Tables_final/TableB1_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace

foreach y in slib scon elib econ atheist college income_high volunteer knowtransplant {
reg `y' dcond16_2-dcond16_16 if one==1
outreg2 using $Tables_final/TableB1_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
}

/* SUPPORT FOR THE VARIOUS SYSTEMS*/

/* FAVOR BY LEVEL AND SYSTEM */ 

bys cond_8: tabstat favor, s(mean semean) by(level)
bys cond_8: tabstat mfavor sefavor, s(mean) by(level)


* Figure 2: support rates by system and supply gain

sort cond_8 level
twoway (connected mfavor level if cond_8==1, msymbol(circle) msize(medium) mcolor(gs8) lwidth(medthick)  lcolor(gs8) lpattern(solid))/*
*/(connected mfavor level if cond_8==2,  msymbol(square) msize(medium) mcolor(gs8)  lwidth(medthick) lcolor(gs8) lpattern(solid))/*
*/(connected mfavor level if cond_8==3,  msymbol(circle)  msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(connected mfavor level if cond_8==4, msymbol(square) msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(connected mfavor level if cond_8==5, msymbol(circle) msize(medium) mcolor(gs8)  lwidth(medthick) lcolor(gs8) lpattern(dash))/*
*/(connected mfavor level if cond_8==6, msymbol(square)  msize(medium) mcolor(gs8) lwidth(medthick) lcolor(gs8) lpattern(dash))/*
*/(connected mfavor level if cond_8==7, msymbol(circle) msize(medium) mcolor(black)  lwidth(medthick) lcolor(black) lpattern(dash))/*
*/(connected mfavor level if cond_8==8, msymbol(square)  msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(dash)),/*
*/ ytitle(Support (percent)) ylabel(, noticks nogrid)  ylabel(40(10)90)/*
*/ xtitle(Transplant increases) xlabel(, noticks nogrid valuelabel)/*
*/ legend(row(4) order(1 "$30K, cash, agency pays" 2 "$100K, cash, agency pays" 3 "$30K, cash, recipient pays" 4 "$100K, cash, recipient pays" /*
*/ 5 "$30K, noncash, agency pays" 6 "$100K, noncash, agency pays" 7 "$30K, noncash, recipient pays" 8 "$100K, noncash, recipient pays") /*
*/ region(lcolor(white)) size(small)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/Figure2_final.tif, width(1200) replace


*APPENDIX: Figure B1

tab cond_8 if type==2&one==1
table cond_8 level if type==2, c(mean favor)

tab cond_8 if type==4&one==1
table cond_8 level if type==4, c(mean favor)

sort cond_8 type level

foreach t in 2 4 {
twoway (connected mfavor_type level if cond_8==1 & type==`t', msymbol(circle) msize(medium) mcolor(gs8) lwidth(medthick)  lcolor(gs8) lpattern(solid))/*
*/(connected mfavor_type level if cond_8==2 & type==`t',  msymbol(square) msize(medium) mcolor(gs8)  lwidth(medthick) lcolor(gs8) lpattern(solid))/*
*/(connected mfavor_type level if cond_8==3 & type==`t',  msymbol(circle)  msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(connected mfavor_type level if cond_8==4 & type==`t', msymbol(square) msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(connected mfavor_type level if cond_8==5 & type==`t', msymbol(circle) msize(medium) mcolor(gs8)  lwidth(medthick) lcolor(gs8) lpattern(dash))/*
*/(connected mfavor_type level if cond_8==6 & type==`t', msymbol(square)  msize(medium) mcolor(gs8) lwidth(medthick) lcolor(gs8) lpattern(dash))/*
*/(connected mfavor_type level if cond_8==7 & type==`t', msymbol(circle) msize(medium) mcolor(black)  lwidth(medthick) lcolor(black) lpattern(dash))/*
*/(connected mfavor_type level if cond_8==8 & type==`t', msymbol(square)  msize(medium) mcolor(black) lwidth(medthick) lcolor(black) lpattern(dash)),/*
*/ ytitle(Support (percent)) ylabel(, noticks nogrid)  ylabel(0(20)100)/*
*/ xtitle(Transplant increases) xlabel(, noticks nogrid valuelabel)/*
*/ legend(row(4) order(1 "$30K, cash, agency pays" 2 "$100K, cash, agency pays" 3 "$30K, cash, recipient pays" 4 "$100K, cash, recipient pays" /*
*/ 5 "$30K, noncash, agency pays" 6 "$100K, noncash, agency pays" 7 "$30K, noncash, recipient pays" 8 "$100K, noncash, recipient pays") /*
*/ region(lcolor(white)) size(small)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureB1-`t'_final.tif, width(1200) replace
}


*APPENDIX: Figure C1-1, left panel; Figure C2-1, left panel
sort cond_8 level
twoway (line mfavor level if cond_8==1,  lwidth(medthick)  lcolor(gs8) lpattern(dash))/*
*/ (rcap cih_mfavor cil_mfavor level if cond_8==1,  lwidth(medthick)  lcolor(gs8)) /*
*/(line mfavor level if cond_8==3,  lwidth(medthick) lcolor(black) lpattern(solid))/*
*/ (rcap cih_mfavor cil_mfavor level if cond_8==3,  lwidth(medthick)  lcolor(black)), /*
*/ ytitle(Support (percent)) ylabel(, noticks nogrid)  ylabel(40(10)90)/*
*/ xtitle(Transplant increases) xlabel(, noticks nogrid valuelabel)/*
*/ legend(row(1) order(1 "$30K, cash, agency pays" 3 "$30K, cash, recipient pays") /*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureC1-1_C2-1_left_final.tif, width(1200) replace


*****control variables for regressions*******

*socio-demographics
global controls2 = "agecat2-agecat3 female dumrace1 dumrace2 dumrace3 dumrace5 married children atheist nonchrist college employed retired income_high slib scon elib econ volunteer dumreg2-dumreg5 knowtransplant receivedself receivedrel"            

*moral foundations
global controls4 = "deont pleasure_high freedom_high tradition_high compassion_high giving_high pragmatism_high"            


/* REGRESSIONS OF SUPPORT ON TRANSPLANTS AND FEATURES OF SYSTEMS*/

*Table 3
reg favor percent c_8_2-c_8_8 , cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high, cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent c_8_2-c_8_8 c_8_2_p-c_8_8_p, cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent c_8_2-c_8_8 c_8_2_p-c_8_8_p $controls2, cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash cash_p pvt pvt_p high high_p, cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash cash_p pvt pvt_p high high_p $controls2, cluster(responseid)
outreg2 using $Tables_final/Table3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append


*APPENDIX: Table B3
reg favor dlevel2-dlevel5, cluster(responseid)
outreg2 using $Tables_final/TableB3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor dlevel2-dlevel5 cash pvt high, cluster(responseid)
outreg2 using $Tables_final/TableB3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor dlevel2-dlevel5 c_8_2-c_8_8, cluster(responseid)
outreg2 using $Tables_final/TableB3_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append


/* TYPES */

*overall
tab type_2 if one==1
tab type_2 cond_8 if one==1, col

*APPENDIX: Table B4
*by system
tabstat tt1 tt2 tt3 tt4 tt5 if one==1, s(mean semean)
tabstat tt_m tt_se if one==1, s(mean) by(type_2)

tabstat tt1 tt2 tt3 tt4 tt5 if one==1, s(mean semean) by(pvt)
bys pvt: tabstat tt_m_pvt tt_se_pvt if one==1, s(mean) by(type_2)

*FIGURE 3 (A AND B)
*A
twoway (bar tt_m type_2, sort  fcolor(gs8) lcolor(gs8) barwidth(.4) )/*
*/(rcap  tt_cih tt_cil type_2, sort  lwidth(thin) lcolor(black) lwidth(medthick)), /*
*/ ytitle(Percent)   ylabel(0(10)50, noticks nogrid)/*
*/ xtitle("") xscale(range(0.5 5.5))/*
*/ xlabel(1(1)5, noticks nogrid valuelabel labsize(small))/*
*/ legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
graph export $Figures_final/Figure3A_type_100_ci_final.tif, width(1200) replace

*B
clonevar ttt=type_2
replace ttt = cond(pvt == 0, ttt - 0.2, ttt + 0.2)

twoway (bar tt_m_pvt ttt if pvt==0, sort  fcolor(gs4) lcolor(gs4) barwidth(.35))/*
*/(rcap  tt_cih_pvt tt_cil_pvt ttt if pvt==0, sort  lwidth(thin) lcolor(black) lwidth(medthick)) /*
*/ (bar tt_m_pvt ttt if pvt==1, sort  fcolor(gs12) lcolor(gs12) barwidth(.35))/*
*/(rcap  tt_cih_pvt tt_cil_pvt ttt if pvt==1, sort  lwidth(thin) lcolor(black) lwidth(medthick)), /*
*/ ytitle(Percent)   ylabel(0(10)50, noticks nogrid)/*
*/ xtitle("") xscale(range(0.5 5.5))/*
*/ xlabel(1(1)5, noticks nogrid valuelabel labsize(small))/*
*/ legend(on order(1 "Public agency pays" 3 "Recipient pays"  ) cols(2) region(lcolor(white))) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
graph export $Figures_final/Figure3B_type_100_ci_pvt_final.tif, width(1200) replace


*APPENDIX: Figure B2 (distribution of types according to presence of absence of morality module)
tab type withmorality, col chi2
tabstat tt1 tt2 tt3 tt4 tt5 if one==1, s(mean semean) by(withmorality)
bys withmorality: tabstat tt_m_wm tt_se_wm if one==1, s(mean) by(type_2)


clonevar tttt=type_2
replace tttt = cond(withmorality == 0, tttt - 0.2, tttt + 0.2)

twoway (bar tt_m_wm tttt if withmorality==0, sort  fcolor(gs4) lcolor(gs4) barwidth(.35))/*
*/(rcap  tt_cih_wm tt_cil_wm tttt if withmorality==0, sort  lwidth(thin) lcolor(black) lwidth(medthick)) /*
*/ (bar tt_m_wm tttt if withmorality==1, sort  fcolor(gs12) lcolor(gs12) barwidth(.35))/*
*/(rcap  tt_cih_wm tt_cil_wm tttt if withmorality==1, sort  lwidth(thin) lcolor(black) lwidth(medthick)), /*
*/ ytitle(Percent)   ylabel(0(10)50, noticks nogrid)/*
*/ xtitle("") xscale(range(0.5 5.5))/*
*/ xlabel(1(1)5, noticks nogrid valuelabel labsize(small))/*
*/ legend(on order(1 "No Ethics module" 3 "Ethics module"  ) cols(2) region(lcolor(white))) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
graph export $Figures_final/FigureB2_type_100_ci_wm_final.tif, width(1200) replace


/* MORALITY-REPUGNANCE */

*CORRELATE MORALITY FEATURES

*APPENDIX: Table B2 
corr exploit autonomy influence fairdonors fairpatient dignity /*
*/ exploit_cs autonomy_cs influence_cs fairdonors_cs fairpatient_cs dignity_cs if one==1

/* DISTRIBUTIONS */

tab1 exploit exploit_cs autonomy autonomy_cs influence influence_cs fairdonors fairdonors_cs /*
*/  fairpatient fairpatient_cs dignity dignity_cs

*FIGURE 4
foreach var in exploit autonomy influence fairdonors fairpatient dignity {
twoway (histogram `var'_cs, bin(7) percent recast(connected) lwidth(medthick) msize(medium)  mcolor(gs8) lcolor(gs8) lpattern(dash))/*
*/(histogram `var', bin(7) percent recast(connected) lwidth(medthick) msize(medium)  mcolor(black) lcolor(black) lpattern(solid)),/*
*/ ytitle(Frequency (percent)) ylabel(, noticks nogrid)  ylabel(0(10)50) /*
*/ xtitle(Ratings (intervals)) xlabel(-9 "[-10,-8]" -6 "[-7,-5]" -3 "[-4,-2]" 0 "[-1,1]" 3 "[2,4]" 6 "[5,7]" 9 "[8,10]", noticks nogrid)/*
*/ legend(row(1) order(1 "Current system" 2 "All paid-donor systems")/*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/Figure4_`var'_final.tif, width(1200) replace
}

foreach v in exploit autonomy influence fairpatient fairdonors dignity {
 mean `v', over(cond_8)
 mean `v'_cs
 }

 
/* REGRESSIONS OF MORAL CONCERNS ON TRANSPLANT GAINS AND SYSTEM FEATURES  */

*VARIANCE OF MORAL CONCERNS BY SYSTEM AND SUPPLY (ANOVA)
anova meanrepugnanceindiv cond_8 level

*TABLE 4

reg diff_exploit percent cash pvt high cash_percent pvt_percent high_percent, cl(responseid)
outreg2 using $Tables_final/Table4_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace

foreach y in  diff_autonomy diff_influence diff_fairdonors diff_fairpatient diff_dignity moral_c1 {
reg `y'  percent cash pvt high cash_percent pvt_percent high_percent, cl(responseid)
outreg2 using $Tables_final/Table4_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
}


reg moral_c1  percent cash pvt high cash_percent pvt_percent high_percent $controls2, cluster(responseid)
outreg2 using $Tables_final/Table4_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

areg moral_c1  percent pvt high cash cash_percent pvt_percent high_percent, abs(responseid) cl(responseid)
outreg2 using $Tables_final/Table4_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle("Individual FEs") append


/* Regressions distinguishing for whether the respondents had morality module */

*Table 5
reg favor percent cash pvt high, cluster(responseid)
outreg2 using $Tables_final/Table5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high withmorality, cluster(responseid)
outreg2 using $Tables_final/Table5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high withmorality*, cluster(responseid)
outreg2 using $Tables_final/Table5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high withmorality* $controls2, cluster(responseid)
outreg2 using $Tables_final/Table5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

/*Regressions with supply gains and morality*/

*Table 6
reg favor percent cash pvt high if withmorality==1, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high diff_exploit diff_autonomy diff_influence diff_fairdonors diff_fairpatient diff_dignity, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high  diff_fairpatient , cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high  diff_exploit diff_autonomy diff_influence diff_fairdonors diff_dignity, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high diff_exploit diff_autonomy diff_influence diff_fairdonors diff_fairpatient diff_dignity $controls2, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
areg favor percent diff_exploit diff_autonomy diff_influence diff_fairdonors diff_fairpatient diff_dignity, abs(responseid) cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle("Individual FEs") append
reg favor percent cash pvt high moral_c1 $controls2, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
areg favor percent cash pvt high moral_c1 , abs(responseid) cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle("Individual FEs") append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2, cluster(responseid)
outreg2 using $Tables_final/Table6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append


***APPENDIX: Table B5
reg favor percent cash cash_p pvt pvt_p high high_p $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high diff_exploit diff_autonomy diff_influence diff_fairdonors diff_fairpatient diff_dignity $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB5_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append


/* ANALYSIS BY TYPES
Average principal component of moral concerns by type, supply gains, and system 
*/

bys type_2: tabstat moral_c1, s(mean semean) by(level)
bys type_2: tabstat moral_c1_type_level semoral_c1_type_level, s(mean) by(level)

bys cond_8 type_2: tabstat moral_c1, s(mean semean) by(level)
bys cond_8 type_2: tabstat moral_c1_type_level_cond semoral_c1_type_level_cond, s(mean) by(level)


*Figure 5

twoway (scatter moral_c1_type_level level, sort  mcolor(black) msize(medlarge))/*
*/(rcap  cih_moral_c1_type_level cil_moral_c1_type_level level, lcolor(black) lwidth(medium)), /*
*/ by(type_2) ytitle(Avg. princ. component of moral concerns)    ylabel(-1(0.5)1, noticks nogrid)/*
*/ xtitle(Transplant increases) xline(5.7, lpattern(dash) lcolor(black) lwidth(thin))/*
*/ xlabel(1(1)5, noticks nogrid valuelabel) /*
*/ by(,legend(off)) by(,graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) /*
*/ subtitle(, fcolor(white) size(medsmall) lcolor(white)) by(, note("")) by(type_2, rows(1))
graph export $Figures_final/Figure5_final.tif, width(1200) replace



*APPENDIX: Figure B3
forvalues c=1(1)8 {
twoway (scatter moral_c1_type_level_cond level  if cond_8==`c', sort  mcolor(black) msize(medlarge))/*
*/(rcap  cih_moral_c1_type_level_cond  cil_moral_c1_type_level_cond level  if cond_8==`c', lcolor(black) lwidth(medium)), /*
*/ by(type_2) ytitle(Avg. princ. component of moral concerns)   ylabel(-1.5(0.5)1.5, noticks nogrid)/*
*/ xtitle(Transplant increases) xline(5.7, lpattern(dash) lcolor(black) lwidth(thin))/*
*/ xlabel(1(1)5, noticks nogrid valuelabel) /*
*/ by(,legend(off)) by(,graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) /*
*/ subtitle(, fcolor(white) size(medsmall) lcolor(white)) by(, note("")) by(type_2, rows(1))
graph export $Figures_final/FigureB3_cond`c'_final.tif, width(1200) replace
}

*Analysis of variance of ethical concerns by system and supply, per type
bys type: anova meanrepugnanceindiv cond_8 level
*explanation of  repugnance vairnace by system and supply, per type
anova meanrepugnanceindiv cond_8 level

*Characteristics of types
*Table 7

preserve

keep if one==1&type<5 /*exclude "other" type*/

foreach v in  female college income_high atheist knowtransplant econ scon elib slib found_c1 found_c2 {
	mean `v' if one==1, over (type_2)

}
restore


*APPENDIX: Table B4
tab type cond_8, col chi2


/*ANALYSIS OF DONATIONS */

*Table 8

*ATF

reg donation_atf withmorality cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace

reg donation_atf moral_c1_m cash pvt high  $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_atf t1-t4 cash pvt high  $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

mean donation_atf if one==1, over(type)


*NKF

reg donation_nkf withmorality cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf moral_c1_m cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf t1-t4 cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/Table8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

mean donation_nkf if one==1, over(type)



*APPENDIX: Table B8

reg donation_atf found_c1 found_c2 cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace

reg donation_atf found_c1 found_c2 moral_c1_m cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_atf cash pvt high $controls2 $controls4 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_atf moral_c1_m cash pvt high $controls2 $controls4 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf found_c1 found_c2 cash pvt high $controls2 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf found_c1 found_c2 cash pvt high moral_c1_m $controls2 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf cash pvt high  $controls2 $controls4 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append

reg donation_nkf moral_c1_m cash pvt high $controls2 $controls4 if one==1, rob
outreg2 using $Tables_final/TableB8_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append



*ADDITIONAL APPENDIX MATERIALS

/* ANALYSIS OF TIMING BY RESPONSE TO VIGNETTE QUESTION */
ttest durationvignette if one==1 & durationvignette<180, by(deont)
*Figure B4
twoway (kdensity durationvignette if deont==0 & one==1 & durationvignette<180,  lwidth(medthick)  lcolor(gs8) lpattern(dash))/*
*/(kdensity durationvignette if deont==1 & one==1 & durationvignette<180,  lwidth(medthick) lcolor(black) lpattern(solid)),/*
*/ ytitle(Density) ylabel(, noticks nogrid)  /*
*/ xtitle(Vignette response time (seconds)) xlabel(, noticks nogrid valuelabel)/*
*/ legend(order(1 "Kill" 2 "Don't kill")/*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureB4_top_final.tif, width(1200) replace

/* ANALYSIS OF TIMING BY TYPE */
*Figure B4
twoway (kdensity durationvignette if type==1 & one==1 & durationvignette<180,  lwidth(medthick)  lcolor(gs8) lpattern(dash))/*
*/(kdensity durationvignette if type==2 & one==1 & durationvignette<180,  lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(kdensity durationvignette if type==3 & one==1 & durationvignette<180,  lwidth(medthick) lcolor(black) lpattern(dash)),/*
*/ ytitle(Density) ylabel(, noticks nogrid)  /*
*/ xtitle(Vignette response time (seconds)) xlabel(, noticks nogrid valuelabel)/*
*/ legend(order(1 "Always opposed" 2 "Opposed to favor" 3 "Always in favor") /*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureB4_bottom_final.tif, width(1200) replace


*Figure B5
twoway (kdensity duration if type==1 & one==1 & duration<60,  lwidth(medthick)  lcolor(gs8) lpattern(dash))/*
*/(kdensity duration if type==2 & one==1 & duration<60,  lwidth(medthick) lcolor(black) lpattern(solid))/*
*/(kdensity duration if type==3 & one==1 & duration<60,  lwidth(medthick) lcolor(black) lpattern(dash)) ,/*
*/ ytitle(Density) ylabel(, noticks nogrid)  /*
*/ xtitle(Survey completion time (minutes)) xlabel(, noticks nogrid valuelabel)/*
*/ legend(row(1) order(1 "Always opposed" 2 "Opposed to favor" 3 "Always in favor")/*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureB5_final.tif, width(1200) replace



/* ANALYSIS OF RESPONSES AND TYPE BY COMMENTS */

foreach j in propayments notopayments importanttopic persexper othercomment nonsense nocomment {
replace `j'=0 if `j'==.
}

*REGRESSION OF "ANY COMMENT" ON TYPE DUMMIES
*Table B6
reg anycomment  cash pvt high if one==1, rob
outreg2 using $Tables_final/TableB6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=some comment) replace
reg anycomment cash pvt high withmorality if one==1, rob
outreg2 using $Tables_final/TableB6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=some comment) append
reg anycomment t1 t2 t4 t5 if one==1, rob
outreg2 using $Tables_final/TableB6_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=some comment) append

*Table B7
*regression of mean overall repugnance (individual level, mean of means)
reg moral_c1_m pvt high cash propayments notopayments importanttopic persexper othercomment nonsense nocomment if one==1, rob
outreg2 using $Tables_final/TableB7_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=Princ. comp. of moral concerns) replace
*regression of favor for paid-donor system
reg favor percent pvt high cash propayments notopayments importanttopic persexper othercomment nonsense nocomment, cluster(responseid)
outreg2 using $Tables_final/TableB7_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=favor) append
*regression of donation to ATF
reg donation_atf pvt high cash propayments notopayments importanttopic persexper othercomment nonsense nocomment if one==1, rob
outreg2 using $Tables_final/TableB7_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=donation_ATF) append
*regression of donation to NKF
reg donation_nkf pvt high cash propayments notopayments importanttopic persexper othercomment nonsense nocomment if one==1, rob
outreg2 using $Tables_final/TableB7_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) ctitle(Y=donation_NKF) append

/*CONFIDENCE, IMPORTANCE, CONSEQUENTIALITY, BELIEFS */

tab howstrongly
tab confident if one==1
tab howstrongly type, col chi2
tab othersinfluen
tab influenced if one==1
tab should
tab will
sum people_*, d
sum congress_*, d

*correlation between beliefs about Americans' preferences and influenced by others
table influenced, c(mean people_1 mean people_2 mean people_3 mean people_4) 

*correlation between beliefs about likelihood of Congress passing laws and perception of consequentiality
table consequential, c(mean congress_1 mean congress_2 mean congress_3 mean congress_4) 
 
/* ROBUSTNESS TO 
-CONFIDENCE IN OWN RESPONSES
-PERCEIVED IMPORTANCE
-PERCEIVED CONSEQUENTIALITY
-BELIEFS ABOUT LIKELIHOOD THAT CONGRESS PASSES LAWS
*/

reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("benchmark") bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high confident $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl confident") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high important $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl important") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high consequential $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl consequential") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high cashcongress_pos $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl cashcongress50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high lostwcongress_pos $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl lostwcongress50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high insurcongress_pos $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl insurcongress50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high taxcrcongress_pos $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("ctrl taxcrcongress50") bdec(3) sdec(3) slow(2500) append

reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if confident==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("confident=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if important==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("important=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if consequential==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("consequential=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if cashcongress_pos==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("cashcongress50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if lostwcongress_pos==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("lostwcongress50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if insurcongress_pos==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("insurcongress50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if taxcrcongress_pos==1, cluster(responseid)
outreg2 using $Tables_final/TableB9_final.xls, symbol(***,**,*) ctitle("taxcrcongress50t=1") bdec(3) sdec(3) slow(2500) append

/* ROBUSTNESS TO 
-AFFECTED BY OTHERS
-BELIEFS ABOUT OPINIONS OF AMERICANS */

reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("benchmark") bdec(3) sdec(3) slow(2500) replace
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high influenced $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl influenced") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high cashpeople50 $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl cashpeople50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high lostwpeople50 $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl lostwpeople50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high insurpeople50 $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl insurpeople50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high taxcrpeople50 $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl taxcrpeople50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high socialrec_high $controls2, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("ctrl taxcrpeople50") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if influenced==0, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("influenced=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if cashpeople50==1, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("cashpeople50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if lostwpeople50==1, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("lostwpeople50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if insurpeople50==1, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("insurpeople50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if taxcrpeople50==1, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("taxcrpeople50t=1") bdec(3) sdec(3) slow(2500) append
reg favor percent cash pvt high moral_c1 cash_percent pvt_percent high_percent moral_c1_percent moral_c1_cash moral_c1_pvt moral_c1_high $controls2 if socialrec_high==0, cluster(responseid)
outreg2 using $Tables_final/TableB10_final.xls, symbol(***,**,*) ctitle("socialrec_high") bdec(3) sdec(3) slow(2500) append

*********************************
*******AUXILIARY TESTS***********
*********************************

*** AUXILIARY EXPERIMENT 1 ***

use $Data_final/ELM_AUX1.dta, clear

*Figure C1.1 (right panel)
sort treatment level
twoway (line mfavor level if treatment==1,  lwidth(medthick)  lcolor(gs8) lpattern(dash))/*
*/(rcap cih_mfavor cil_mfavor level if treatment==1,  lwidth(medthick) lcolor(gs8))/*
*/(line mfavor level if treatment==2,  lwidth(medthick) lcolor(black))/*
*/(rcap cih_mfavor cil_mfavor level if treatment==2,  lwidth(medthick) lcolor(black))/*
*/(line mfavor level if treatment==3,  lwidth(medthick) lcolor(black) lpattern(longdash))/*
*/(rcap cih_mfavor cil_mfavor level if treatment==3,  lwidth(medthick) lcolor(black)),/*
*/ ytitle(Support (percent)) ylabel(, noticks nogrid)  ylabel(40(10)90)/*
*/ xtitle(Transplant increases) xlabel(19 23 28 33 38, noticks nogrid valuelabel)/*
*/ legend(row(2) order(1 "$30K, cash, agency pays" 3 "$30K, cash, recipient pays" 5 "$30K, cash, recipient pays - NEW") /*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureC1-1_right_final.tif, width(1200) replace


clear

*** AUXILIARY EXPERIMENT 2 ***

use $Data_final/ELM_AUX2.dta, clear

*Figure C2.1 (right panel)
sort level pvt

twoway (line mfavor level if pvt==0, sort  lcolor(gs8) lwidth(thick) lpattern(dash))/*
*/(rcap  sefavor_h sefavor_l level if pvt==0, lcolor(gs8) lwidth(medium)) /*
*/ (line mfavor level if pvt==1, sort  lcolor(black) lwidth(thick) lpattern(solid))/*
*/(rcap  sefavor_h sefavor_l level if pvt==1, lcolor(black) lwidth(medium)), /*
*/ ytitle(Support (percent))   ylabel(40(10)90, noticks nogrid)/*
*/ xtitle(Tranplant increases)/*
*/ xlabel(, noticks nogrid valuelabel) /*
*/ legend(row(1) order(1 "$30K, cash, agency pays" 3 "$30K, cash, recipient pays") /*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureC2-1_right_final.tif, width(1200) replace

clear


*** AUXILIARY EXPERIMENT 3 ***

use $Data_final/ELM_AUX3.dta, clear

*Table C3.1
global controls = "agecat2-agecat3 female dumrace1 dumrace2 dumrace3 dumrace5 married children atheist nonchrist college employed retired income_high slib scon elib econ volunteer dumreg2-dumreg4"            
reg diff_exploit percent noloanrepay $controls, cl(responseid)
outreg2 using $Tables_final/TableC3-1_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) replace
foreach y in diff_auton diff_influen diff_fairdon diff_fairpat diff_dignity moral_c1 {
reg `y'  percent noloanrepay $controls, cl(responseid)
outreg2 using $Tables_final/TableC3-1_final.xls, symbol(***,**,*) bdec(3) sdec(3) slow(2500) append
}

*Figure C3.1
sort noloanrepay level
twoway (line mfavor level if noloanrepay==0,  lwidth(thick)  lcolor(gs8) lpattern(dash))/*
*/(line mfavor level if noloanrepay==1,  lcolor(gs8) lwidth(thick) lpattern(solid)),/*
*/ ytitle(Support (percent)) ylabel(, noticks nogrid)  ylabel(60(10)90)/*
*/ xtitle(Transplant increases) xlabel(19 23 28 33 38, noticks nogrid valuelabel)/*
*/ legend(row(2) order(1 "$30K, non-cash, agency pays, incl. loan repay" 2 "$30K, non-cash, agency pays, excl. loan repay")/*
*/ region(lcolor(white))) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export $Figures_final/FigureC3-1_final.tif, width(1200) replace


log close
