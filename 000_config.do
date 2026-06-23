****************************************************
* 00_config.do
* Purpose: Set up the analysis environment, paths, and common options
****************************************************

* 1) Specify the Stata version
version 19.0

* 2) Prevent output from pausing
set more off

* 3) Display formats for results (optional; usually left commented out)
// set cformat %9.3f
// set pformat %9.3f
// set sformat %9.3f

* 4) Define the project root
display "project directory: " c(pwd)
global PROJ "`c(pwd)'" 

* 5) Define frequently used folders as global macros
global RAW   "${PROJ}/data_raw"
global CLEAN "${PROJ}/data_clean"
global DO    "${PROJ}/do"
global LOG   "${PROJ}/log"
global OUT   "${PROJ}/output"

* 6) Load project-specific ado files here, if any


di "Project root: ${PROJ}"

di "=== Config loaded ==="