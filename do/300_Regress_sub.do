****************************************************
* 300_Regress_sub.do
* Purpose: Conduct a subgroup/exploratory analysis.
* Exposure = administered Ca dose (mg), inCa
* Outcome = serum Ca increase rate, sCa_up
* Confounder = processed volume, proc_vol
* Analysis: linear regression
****************************************************

cap log close
log using "$LOG\log_200_Regression_sub.smcl", replace

* 1) Input and output data files
local read_file  "$CLEAN\df02_clean.dta"
local write_file "$OUT\SUBresults.xlsx"

use "`read_file'", clear

/***************************************************
a) Perform linear regression under the following conditions
Exposure                   : inCa
Primary Outcome            : sCa_up
Covariates                 : proc_vol
---

1) Define the postfile
2) Run regress -> lincom -> obtain the point estimate, lower confidence limit, upper confidence limit, and p-value
3) Write the results using post
4) Repeat the analysis for the next model (inCa + proc_vol).
5) postclose

***************************************************/
* 0) Preparation
****************************************************
local outv    sCa_up 
local covars0          // Covariates used in the crude model; intentionally left blank
local covars1 proc_vol // Covariates used in the adjusted model

****************************************************
* 1) Prepare the postfile to store results
****************************************************
tempname memhold
tempfile results

postfile `memhold' ///
	str20 model ///
	float cCoef cCI_l cCI_u cPv ///
    float aCoef aCI_l aCI_u aPv ///
	using "`results'", replace
	
****************************************************
* 2) Run the analysis
****************************************************

forvalues m = 0/1 {	
	capture noisily regress `outv' inCa `covars`m''
	if !_rc {
		capture noisily lincom inCa, level(95)
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
}

post `memhold' ("inCa->sCa_up") ///
		(`b0') (`lb0') (`ub0') (`pv0') ///
		(`b1') (`lb1') (`ub1') (`pv1') 


postclose `memhold'

****************************************************
* 4) Format results for output
****************************************************
use "`results'", clear

gen str60 cCoef_95CI = ""
replace cCoef_95CI = ///
    strtrim(string(cCoef,   "%9.3f")) + " (" + ///
    strtrim(string(cCI_l, "%9.3f")) + " to " + ///
    strtrim(string(cCI_u, "%9.3f")) + ")" ///
    if !missing(cCoef, cCI_l, cCI_u)

gen str60 aCoef_95CI = ""
replace aCoef_95CI = ///
    strtrim(string(aCoef,   "%9.3f")) + " (" + ///
    strtrim(string(aCI_l, "%9.3f")) + " to " + ///
    strtrim(string(aCI_u, "%9.3f")) + ")" ///
    if !missing(aCoef, aCI_l, aCI_u)

foreach x of var cPv aPv {
    gen str20 `x'_value = ""
    replace `x'_value = strtrim(string(`x', "%9.3f")) if !missing(`x')
    replace `x'_value = "<0.001" if `x' < 0.001
}

keep  model cCoef_95CI cPv_value aCoef_95CI aPv_value
order model cCoef_95CI cPv_value aCoef_95CI aPv_value

label variable model  "Model"
label variable cCoef_95CI  "Crude Coef. (95% CI)"
label variable aCoef_95CI  "Adjusted Coef. (95% CI)"
label variable cPv_value  "p value"
label variable aPv_value  "p value"

list, sep(0)

****************************************************
* 5) Export results to Excel
****************************************************
export excel using "`write_file'", ///
    sheet("Sub analysis") firstrow(varlabels) replace

log close
exit