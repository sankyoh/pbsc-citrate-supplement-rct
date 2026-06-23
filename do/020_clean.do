****************************************************
* 02_clean.do
* Purpose: Clean the dataset and save an analysis-ready file
* df00.dta -> df01_clean.dta
****************************************************

* 0) Start the log
cap log close
log using "$LOG\log_020_clean.smcl", replace

* 1) Input and output data files
local read_file  "$RAW\df00.dta"
local write_file "$CLEAN\df01_clean.dta"

use "`read_file'", clear

****************************************************
* 0) ID checks
****************************************************

* Check whether patient_id has missing values
// Stop here if missing values are present
count if missing(patient_id)
assert patient_id!=.

* Check whether patient_id is unique (duplicates would invalidate subsequent analyses)
// Stop here if duplicate IDs are present
isid patient_id

****************************************************
* 1) Trim string variables
****************************************************
// Remove extra spaces that may have been introduced during data import
// Convert string variables to numeric variables when possible.
quietly ds, has(type string)
local strings `r(varlist)'
foreach v of local strings {
	replace `v' = strtrim(`v') if !missing(`v')
	cap noisily destring `v', replace
}

****************************************************
* 2) Recode sex
****************************************************
gen byte sex = (性別=="M") if inlist(性別,"F","M")
label define sex 0 "Female" 1 "Male", replace
label values sex sex
label variable sex "性別"
order sex, after(性別)
tab 性別 sex
drop 性別

****************************************************
* 3) Recode allocation group
****************************************************
gen byte intv = (割付番号=="A") if inlist(割付番号, "A", "B")
label define intv 0 "B" 1 "A"
label values intv intv
label variable intv "介入"
order intv, after(割付番号)
tab 割付番号 intv
drop 割付番号
drop H
drop I

****************************************************
* 3) Rename long variable names to shorter names and add labels
* Some variable-name mappings were generated with ChatGPT and then manually revised
* https://example.com/foobar
****************************************************
rename 年齢             age
rename HT              height
rename BW              weight
rename TBV             tbv

rename 流量            flow_rate
rename 注入率          inf_rate
rename preCD34         pre_cd34
rename 時間            time
rename ACD             acd
rename 投与Ca量mg      inCa
rename 投与K量ｍEq      inK
rename 処理量          proc_vol

rename Grade          grade

rename 最大値 iCa_max
rename 分値   iCa_15min
rename Z      iCa_30min

rename AA iK_max
rename AB iK_15min
rename AC iK_30min

rename 前後値 sCa_up
rename AE    sK_down
rename AF    sMg_down

* --- variable labels (use original long names as labels) ---
label variable patient_id "patient_id"

****************************************************
* 4) Labels for Boolean variables
****************************************************
/* Not needed */

****************************************************
* 5) Sanity Check Lv2: Pre-analysis checks
****************************************************
* Check variable types
des

/* Check that binary variables are coded as 0/1. Stop otherwise.
su `boolvars' 
foreach v of local boolvars {
	* Apply value labels (0/1)
	assert `v'==0 | `v'==1
} */

* Check that sex is coded as 0/1. Stop otherwise.
assert sex==0 | sex==1

* Age: plausible range 18-120
gen byte age_outlier = (age < 18 | age > 120) if !missing(age)
label variable age_outlier "Age out of plausible range (18-120)"
tab age_outlier, missing
su age if age_outlier == 1


****************************************************
* 6) Summarize missing values
****************************************************
* At this stage, only summarize missingness; do not handle missing values.
misstable summarize

/* Create missingness indicators
foreach v in bmi sbp fev1 cv_time {
    gen byte miss_`v' = missing(`v')         // 1 if missing
    label values miss_`v' miss01
    label variable miss_`v' "`v' missingness"
} */

****************************************************
* 7) Save the cleaned dataset
****************************************************
* Final check
codebook 

compress
label data "Cleaning済"
save "`write_file'", replace

di "=== Clean done ==="

cap log close