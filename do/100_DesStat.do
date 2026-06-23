****************************************************
* 100_DesStat.do
* Purpose: Calculate descriptive statistics.
****************************************************

cap log close
log using "$LOG\log_100_DesStat.smcl", replace

* 1) Input and output data files
local read_file  "$CLEAN\df02_clean.dta"
local write_file "$OUT\DesStat_results.xlsx"

use "`read_file'", clear
keep intv age sex height weight tbv flow_rate inf_rate pre_cd34 time acd inCa inK proc_vol


/***************************************************
a) Calculate descriptive statistics under the following conditions

Categorical variables are summarized as frequencies and percentages. Continuous variables are summarized as means, standard deviations, medians, and interquartile ranges.
Summaries are stratified by intv=0 and intv=1.

Variables to be summarized
age, sex, HT, BW, TBV, flow rate, infusion rate, pre CD34, time, ACD, administered Ca dose (mg), administered K dose (mEq), processed volume

The variable names are as follows.
age sex height weight tbv flow_rate inf_rate pre_cd34 time acd inCa inK proc_vol

Among these variables, only sex is a categorical variable.

Use the external command make_table1.ado.

***************************************************/

local vars age* i.sex height* weight* tbv* flow_rate* inf_rate* pre_cd34* time* acd* inCa* inK* proc_vol*
local contvars age height weight tbv flow_rate inf_rate pre_cd34 time acd inCa inK proc_vol
local iqrvars age2 height2 weight2 tbv2 flow_rate2 inf_rate2 pre_cd342 time2 acd2 inCa2 inK2 proc_vol2

foreach v of local contvars {
    gen `v'2 = `v', after(`v')
    label variable `v'2 " "
}

* 1) to fix line-break of variable label
foreach v of local contvars {
    local vl : variable label `v'

    local vl2 = subinstr(`"`vl'"', char(34), "'", .)
    local vl2 = subinstr(`"`vl2'"', char(10), " ", .)
    local vl2 = subinstr(`"`vl2'"', char(13), " ", .)

    if `"`vl'"' != `"`vl2'"' {
        label variable `v' `"`vl2'"'
    }
}

make_table1 `vars', by(intv) ///
    sdvars(`contvars') ///
    iqrvars(`iqrvars') ///
    writefile("`write_file'")


misstable sum 

log close
exit
