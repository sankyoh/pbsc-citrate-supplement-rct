****************************************************
* 030_define_vars.do
* Purpose: Create variables required for analysis
* df01_clean.dta -> df02_clean.dta
****************************************************

* 0) Start the log
cap log close
log using "$LOG\log_030_define_vars.smcl", replace

* 1) Input and output data files
local read_file  "$CLEAN\df01_clean.dta"
local write_file "$CLEAN\df02_clean.dta"

use "`read_file'", clear

****************************************************
* 1) Define outcome variables
****************************************************
label define ny 0 "No" 1 "Yes"
gen grade_cat1 = (grade>=1) if inrange(grade, 0, 4)
gen grade_cat2 = (grade>=2) if inrange(grade, 0, 4)
gen grade_cat3 = (grade>=3) if inrange(grade, 0, 4)
label variable grade_cat1 "1 if Grade>=1"
label variable grade_cat2 "1 if Grade>=2"
label variable grade_cat3 "1 if Grade>=3"
label values   grade_cat1 ny
label values   grade_cat2 ny
label values   grade_cat3 ny

****************************************************
* 2) Define exposure variables
****************************************************
// Not needed

****************************************************
* 7) Save the analysis dataset
****************************************************
* Final check
codebook 

compress
label data "Cleaning + Variable define"
save "`write_file'", replace

di "=== Clean done ==="

cap log close