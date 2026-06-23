****************************************************
* 200_RRanalysis.do
* Purpose: Perform modified Poisson regression for binary outcomes
* Purpose: Perform linear regression for continuous outcomes
* Apply the same workflow to the primary and secondary outcomes.
****************************************************

cap log close
log using "$LOG\log_200_RRanalysis.smcl", replace

* 1) Input and output data files
local read_file  "$CLEAN\df02_clean.dta"
local write_file "$OUT\Main_results.xlsx"

use "`read_file'", clear

/***************************************************
a) Perform modified Poisson regression under the following conditions
Intervention                   : intv
Primary Outcome                : grade_cat1
Secondary Outcome(dicothomous) : grade_cat2 grade_cat3
Secondary Outcome(continuous)  : iCa_max iCa_15min iCa_30min iK_max iK_15min iK_30min sCa_up sK_down sMg_down

---

1) Define the postfile
2) Run poisson -> lincom -> obtain the point estimate, lower confidence limit, upper confidence limit, and p-value
3) Write the results using post
4) Repeat the analysis for the next outcome.
5) postclose

***************************************************/
* 0) Preparation
****************************************************
local outvs1 grade_cat1 grade_cat2 grade_cat3 
local outvs2 iCa_max iCa_15min iCa_30min iK_max iK_15min iK_30min sCa_up sK_down sMg_down

****************************************************
* 1) Prepare the postfile to store results
****************************************************
tempname memhold
tempfile results

postfile `memhold' ///
	str20 outcome ///
	float cRR cCI_l cCI_u cPv ///
	using "`results'", replace
	
****************************************************
* 2) Run the main analysis (binary outcomes)
****************************************************

foreach outv of local outvs1 {	
	capture noisily poisson `outv' intv,robust irr
	if !_rc {
		capture noisily lincom intv, eform level(95)
		if !_rc {
			local b`m'   = r(estimate)
			local lb`m'  = r(lb)
			local ub`m'  = r(ub)
			local pv`m'  = r(p)
		}
		else {
			local b`m'   = .
			local se`m'  = .
			local lb`m'  = .
			local ub`m'  = .
		}
	}
	post `memhold' ("`outv'") ///
		(`b') (`lb') (`ub') (`pv') 
}

****************************************************
* 3) Run the main analysis (continuous outcomes)
****************************************************

foreach outv of local outvs2 {	
	capture noisily regress `outv' intv,robust
	if !_rc {
		capture noisily lincom intv, level(95)
		if !_rc {
			local b`m'   = r(estimate)
			local lb`m'  = r(lb)
			local ub`m'  = r(ub)
			local pv`m'  = r(p)
		}
		else {
			local b`m'   = .
			local se`m'  = .
			local lb`m'  = .
			local ub`m'  = .
		}
	}
	post `memhold' ("`outv'") ///
		(`b') (`lb') (`ub') (`pv') 
}


postclose `memhold'

****************************************************
* 4) Format results for output
****************************************************
use "`results'", clear

gen str60 RR_95CI = ""
replace RR_95CI = ///
    strtrim(string(cRR,   "%9.3f")) + " (" + ///
    strtrim(string(cCI_l, "%9.3f")) + " to " + ///
    strtrim(string(cCI_u, "%9.3f")) + ")" ///
    if !missing(cRR, cCI_l, cCI_u)

gen str20 p_value = ""
replace p_value = strtrim(string(cPv, "%9.3f")) if !missing(cPv)

keep outcome RR_95CI p_value

label variable outcome  "Outcome"
label variable RR_95CI  "Risk ratio/Coef. (95% CI)"
label variable p_value  "p value"

list, sep(0)

****************************************************
* 5) Export results to Excel
****************************************************
export excel using "`write_file'", ///
    sheet("Main analysis") firstrow(varlabels) replace

log close
exit