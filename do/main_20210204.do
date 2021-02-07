global log = "tmp"
global raw = "rawdata/tscs2015q1.dta"
global tables = "tables"
log using $log/worklog20200204.log, replace

use $raw

global cols    = "id zip v1 v2y v2m agegp v6a v106"
global new_cols = "id zip gender birth_year birth_month agegp edu_level inc_level"

keep $cols
rename ($cols) ($new_cols)


mdesc

decode zip, gen(zip_str)
gen city = substr(zip_str, 1, 9)

recode edu_level (1 2 5 9 13/17 22/99 = .) (3 = 6) (4 = 9) (6 7 8= 12) (10 11 = 14) (12 = 15) (19 = 16) (20 = 18) (21 = 23), gen(edu_year)
recode inc_level (96/max = .) (1 = 0) (22=250000) (23 = 300000), gen(income)


replace income = (income-1.5)*10000 if inrange(inc_level, 2, 21)
gen ln_income = ln(income)
replace ln_income = 0 if income == 0


tab gender, gen(gender_)
rename (gender_1 gender_2) (male female)


gen entry_year = birth_year + 12 if inrange(birth_month, 1, 8)
replace entry_year = birth_year + 13 if inrange(birth_month, 9, 12)
label variable entry_year "國中入學學年度（民國）"


bysort entry_year: egen mean_edu_year = mean(edu_year)
bysort entry_year: egen size = count(id)


label var mean_edu_year "平均教育年數（按國中入學年度）"
label var size "人數（按國中入學年度）"
save "data/final_data_2015.dta", replace

preserve
gen tmp = 1
collapse (sum) size = tmp (mean) mean_edu_year = edu_year, by(entry_year)
save "$tables/GroupEduYearTable_2015.dta", replace
restore


log close
