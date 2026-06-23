# Variable list

This file summarizes the main study variables used in the analysis do-files from `100_DesStat.do` onward.

## Group variable

| Variable | Description |
|---|---|
| `intv` | Randomized group. `1` = Group A, prophylactic oral calcium-vitamin D3-magnesium supplementation; `0` = Group B, control. |

## Baseline and collection variables

| Variable | Description |
|---|---|
| `age` | Age. |
| `sex` | Sex. `1` = Male; `0` = Female. |
| `height` | Height. |
| `weight` | Body weight. |
| `tbv` | Total blood volume. |
| `flow_rate` | Blood flow rate during PBSC collection. |
| `inf_rate` | Infusion rate. |
| `pre_cd34` | Pre-collection CD34-positive cell count. |
| `time` | PBSC collection time. |
| `acd` | ACD amount or volume. |
| `inCa` | Administered calcium dose. |
| `inK` | Administered potassium dose. |
| `proc_vol` | Processed blood volume. |

## Primary and secondary binary outcomes

| Variable | Description |
|---|---|
| `grade_cat1` | Citrate-related reaction of Grade 1 or higher. |
| `grade_cat2` | Citrate-related reaction of Grade 2 or higher. |
| `grade_cat3` | Citrate-related reaction of Grade 3 or higher. |

## Secondary continuous outcomes

| Variable | Description |
|---|---|
| `iCa_max` | Ionized calcium-related outcome at the maximum point. |
| `iCa_15min` | Ionized calcium-related outcome at 15 minutes. |
| `iCa_30min` | Ionized calcium-related outcome at 30 minutes. |
| `iK_max` | Ionized potassium-related outcome at the maximum point. |
| `iK_15min` | Ionized potassium-related outcome at 15 minutes. |
| `iK_30min` | Ionized potassium-related outcome at 30 minutes. |
| `sCa_up` | Serum calcium increase rate. |
| `sK_down` | Serum potassium decrease rate. |
| `sMg_down` | Serum magnesium decrease rate. |

## Variables created only for descriptive tables

| Variable | Description |
|---|---|
| `age2` | Duplicate of `age`, created for median and interquartile range output. |
| `height2` | Duplicate of `height`, created for median and interquartile range output. |
| `weight2` | Duplicate of `weight`, created for median and interquartile range output. |
| `tbv2` | Duplicate of `tbv`, created for median and interquartile range output. |
| `flow_rate2` | Duplicate of `flow_rate`, created for median and interquartile range output. |
| `inf_rate2` | Duplicate of `inf_rate`, created for median and interquartile range output. |
| `pre_cd342` | Duplicate of `pre_cd34`, created for median and interquartile range output. |
| `time2` | Duplicate of `time`, created for median and interquartile range output. |
| `acd2` | Duplicate of `acd`, created for median and interquartile range output. |
| `inCa2` | Duplicate of `inCa`, created for median and interquartile range output. |
| `inK2` | Duplicate of `inK`, created for median and interquartile range output. |
| `proc_vol2` | Duplicate of `proc_vol`, created for median and interquartile range output. |

## Analysis use

| Variable | Main use |
|---|---|
| `intv` | Exposure variable in the main group comparison. |
| `grade_cat1` | Primary endpoint in the modified Poisson regression. |
| `grade_cat2`, `grade_cat3` | Secondary binary endpoints in modified Poisson regression. |
| `iCa_max`, `iCa_15min`, `iCa_30min`, `iK_max`, `iK_15min`, `iK_30min`, `sCa_up`, `sK_down`, `sMg_down` | Secondary continuous endpoints in linear regression. |
| `inCa` | Exposure variable in the exploratory regression analysis. |
| `proc_vol` | Covariate in the adjusted exploratory regression analysis. |
| `sCa_up` | Outcome variable in the exploratory regression analysis. |

## Notes

- Patient-level data are not included in this repository.
- Some variables were renamed from the original dataset to shorter English names.
- Variables ending in `2` were created only for descriptive table formatting and were not used as separate clinical variables.
- Output-formatting variables created inside the do-files, such as confidence interval strings and p-value strings, are not listed as study variables.
