[![DOI](https://zenodo.org/badge/1277674761.svg)](https://doi.org/10.5281/zenodo.20813642)

# pbsc-citrate-supplement-rct

This repository contains selected Stata do-files produced as part of statistical analysis for a prospective randomized controlled trial of prophylactic oral calcium-vitamin D3-magnesium supplementation during peripheral blood stem cell (PBSC) collection in healthy donors.

## Study

Japanese title:

**健常ドナーPBSC採取における経口カルシウム補充RCT**

English title:

**Prophylactic Oral Calcium-Vitamin D3-Magnesium Supplementation Reduced Citrate-Related Reactions During Peripheral Blood Stem Cell Collection in Healthy Donors: A Randomized Controlled Trial**

## Analysis overview

The analysis included data import, data cleaning, outcome definition, descriptive statistics by randomized group, regression analyses for primary and secondary endpoints, and an exploratory analysis of serum calcium increase.

Binary outcomes were analyzed using modified Poisson regression. Continuous outcomes were analyzed using linear regression. The exploratory analysis evaluated the association between administered calcium dose and serum calcium increase rate, with adjustment for processed volume.

## Files

### `variable_list.md`

Summarizes the main study variables used in the analysis do-files.

The file includes group variables, baseline and PBSC collection variables, primary and secondary outcomes, and variables used in exploratory regression analyses.

### `master.do`

Runs all analysis modules in order.

### `000_config.do`

Sets the Stata version, project folders, and common paths.

### `do/010_import.do`

Imports the source Excel file, creates `patient_id`, performs basic checks, and saves the raw Stata dataset.

### `do/020_clean.do`

Cleans the dataset, checks IDs, trims string variables, recodes sex and allocation group, renames variables, checks missing values, and saves the cleaned dataset.

### `do/030_define_vars.do`

Creates binary outcome variables for citrate-related reactions:

* `grade_cat1`: Grade 1 or higher
* `grade_cat2`: Grade 2 or higher
* `grade_cat3`: Grade 3 or higher

### `do/100_DesStat.do`

Creates descriptive statistics by randomized group.

Categorical variables are summarized as counts and percentages. Continuous variables are summarized using means, standard deviations, medians, and interquartile ranges.

This program uses `do/make_table1.ado`.

### `do/200_RRanalysis.do`

Performs the main analyses.

For binary outcomes, the program estimates risk ratios and 95% confidence intervals using modified Poisson regression. For continuous outcomes, the program estimates coefficients and 95% confidence intervals using linear regression.

### `do/300_Regress_sub.do`

Performs an exploratory regression analysis of the association between administered calcium dose (`inCa`) and serum calcium increase rate (`sCa_up`).

Both crude and processed-volume-adjusted models are fitted.

### `do/make_table1.ado`

A user-written Stata ado-file used to create descriptive tables.

This ado-file was created by Toshiharu Mitsuhashi and has not been registered in an external Stata package repository (at 23Jun2026).

## Notes

* Patient-level data are not included.
* Source file names and sheet names were masked before publication.
* This repository contains selected Stata do-files from statistical analysis conducted by Toshiharu Mitsuhashi.
* The do-files are provided for documentation and reproducibility of the statistical analysis.
* These files are not intended to replace the final study protocol, statistical analysis plan, or published article.
  ::: 
