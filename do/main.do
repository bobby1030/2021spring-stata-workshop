/* 
This script clean the Taiwan Social Change Survey (TSCS) dataset `tscs2010q1.dta`.
Extract basic summary statistics and perrform regression analysis of education on income.
*/


* clear previous result in case
clear
cap log close


* set short name for commands or paths
global log   = "tmp"
global raw   = "rawdata/tscs2010q1.dta"
global table = "tables"

* start logging
log using $log/worklog20210201.log, replace



/*
						I. Data Cleaning 
*/


* 0. Load Data
use $raw


* 1. Select necessary columns, and rename them
global cols    = "id zip v1 v2y v2m age v7a v106"
global newcols = "id zip gender birth_year birth_month age edu_level inc_level"

keep $cols
rename ($cols) ($newcols)


* 2. check missing value, duplication
* `ssc install mdesc` : this is for quick missing check
mdesc

duplicates report
* append a column to record repeat number
duplicates tag, gen(repeat)


/*
						II. Organize Data
*/


* 1. Extract label for "zip", save to "zip_str" column
decode zip, gen(zip_str)

* 2. Extract city (at county level), save it to "city" column
*    note that one chinese character stands for 3 bytes
gen city = substr(zip_str, 1, 9)



* 3. Recode education level to education years
recode edu_level (1 2 5 9 13/17 22/99 = .) (3 = 6) (4 = 9) (6 7 8= 12) ///
(10 11 = 14) (12 = 15) (19 = 16) (20 = 18) (21 = 23), gen(edu_year)


* 4. Recode income level to median income
recode inc_level (1 = 0) (95/max = .) (23/24 = 300000), gen(income)
replace income = (income - 1.5)*10000 if inrange(inc_level, 2, 22)


* 5. Create column for ln(income)
*    note the NA produced by ln(0)
gen ln_income = ln(income)
replace ln_income = 0 if income == 0


* 6. Create Dummy for gender
tab gender, gen(gender_)

gen female = gender_2 // for latter use


* 7. Assign entry year 
gen entry_year = birth_year + 12 if inrange(birth_month, 1, 8)
replace entry_year = birth_year + 13 if missing(entry_year)

label var entry_year "國中入學學年度（民國）"


* 8. 
* (1) Create column recording entry year group mean education years, 
* (2) Create column recording num of obs. of each group
* (3) Give labels for these columns
	 
bys entry_year: egen mean_edu_year = mean(edu_year)
bys entry_year: egen size          = count(id)

label var mean_edu_year "平均教育年數（按國中入學年度）"
label var size "人數（按國中入學年度）"

* 9. Save tidy data 
save "data/final_data.dta", replace


/* 
						III.Summary Statistics
*/


* 1. Frequency table for gender in different city
tab city gender

* 2. Smmary Statistics for income and education year for cities
tab city, sum(income)
tab city, sum(edu_year)

// bys city: sum(income edu_year) // long version


* 3. 
* (1) Create column recording entry year group mean education years, 
* (2) Create column recording num of obs. of each group
	 
bys entry_year: egen group_mean_edu_year = mean(edu_year)
bys entry_year: egen group_obs           = count(id)


* 4. Use collapse to summarize group size and its mean edu years,
*	 and save it to "tmp/GroupEduYear.dta"
*    Don't forget to preserve original dataset
preserve
gen tmp = 1
collapse (sum) size = tmp  (mean) mean_edu_year = edu_year, by(entry_year)
save "$table/GroupEduYearTable.dta", replace
restore


/*
						IV. Regression Analysis
*/

* 1. 
* (1) Regress Income on education year
* (2) Regress Income on education year + gender (female)
* (3) Regress Income on education year + gender (female) + interaction term

* 2. Repeat above procedure with log income 

* 3. Use outreg2 to save results to "tables/regIncome.xls"


reg income edu_year, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) replace

reg income edu_year female, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) append

reg income edu_year female female#c.edu_year, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) append

reg ln_income edu_year, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) append

reg ln_income edu_year female, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) append

reg ln_income edu_year female female#c.edu_year, robust
outreg2 using $table/regIncome.xls, bdec(2) sdec(2) slow(1000) append



log close








