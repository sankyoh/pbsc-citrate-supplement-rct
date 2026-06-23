****************************************************
* master.do
* Purpose: Run each module sequentially from top to bottom
****************************************************

* 0) config
// Place 000_config.do in the same directory as master.do and the project files.
do 000_config.do

* 1) import
// Excel -> df00.dta
do $DO/010_import.do

* 2) cleaning
do $DO/020_clean.do

* 3) define exposure/outcome variables
do $DO/030_define_vars.do

****************************************************
* II-1) Descriptive Statistics
do $DO/100_DesStat.do

* II-2) Main Analysis (Intervention Effect on Outcomes)
do $DO/200_RRanalysis.do

* II-3) Sub Analysis (Association between inCa and sCa_up)
do $DO/300_Regress_sub.do

