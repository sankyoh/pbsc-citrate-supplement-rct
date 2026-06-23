****************************************************
* 010_import.do
* Purpose: Import the source Excel file and save it as a dta file
* source Excel file -> df00.dta
****************************************************

* 0) Start the log
cap log close
log using "$LOG/log_010_import.smcl", replace

* 1) Input and output data files
local read_file  "$RAW/foobar.xlsx" // Temporary filename
local write_file "$RAW/df00.dta"
local import_excel_ops `"sheet("hogehoge") cellrange(G3:AF55) clear firstrow"' // Temporary sheet name

* 2) Import the Excel file
import excel using "`read_file'", `import_excel_ops'
gen patient_id = _n, 
order patient_id

* 3) Sanity Check Lv1: Confirm that the imported data are not corrupted
* Variable types and number of observations
describe  // Check whether variable types are appropriate
count     // Check whether the number of observations is as expected

/* Check missing values in patient_id
count if missing(patient_id) 

* Check duplicates in patient_id
duplicates report patient_id 
*/

* Briefly check continuous variables
// summarize commands omitted
	
* Briefly check Boolean/binary variables
// summarize commands omitted

* Inspection only; no changes are applied here.
di "Sanity Check Lv1 completed (no modification applied)"

* 4) Save the raw dta file
compress
label data "RAW data"
save "`write_file'", replace

di "=== Import done ==="

log close