/* 
This script clean the Taiwan Social Change Survey (TSCS) dataset `tscs2010q1.dta`.
Extract basic summary statistics and perrform regression analysis of education on income.
*/


*** SLIDE : https://hackmd.io/@CmXWxbiKT1ukDmAGlXhpPA/r1IBr9xg_#/  



* create directories for data, tables



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




* 2. check missing value, duplication
* `ssc install mdesc` : this is for quick missing check




* append a column to record repeat number





/*
						II. Organize Data
*/


* 1. Extract label for "zip", save to "zip_str" column



* 2. Extract city (at county level), save it to "city" column
*    note that one chinese character stands for 3 bytes




* 3. Recode education level to education years




* 4. Recode income level to median income




* 5. Create column for ln(income)
*    note the NA produced by ln(0)




* 6. Create Dummy for gender



* 7. Assign entry year 





* 8. 
* (1) Create column recording entry year group mean education years, 
* (2) Create column recording num of obs. of each group
* (3) Give labels for these columns






* 9. Save tidy data 






/* 
						III.Summary Statistics
*/


* 1. Frequency table for gender in different city



* 2. Smmary Statistics for income and education year for cities





* 3. 
* (1) Create column recording mean education years for each entry year group, 
* (2) Create column recording num of obs. of each group
	 

	 
	 
	 

* 4. Use collapse to summarize group size and its mean edu years,
*	 and save it to "tmp/GroupEduYear.dta"
*    Don't forget to preserve original dataset

preserve
//your codes
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


//your codes


log close








