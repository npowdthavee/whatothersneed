****************************************************
* bayes_factors.do
*
* PURPOSE:
*   Computes Bayes Factors (BF10) for key results in
*   "Correcting Well-being Norm Misperceptions..."
*   Addresses Reviewer 1, PC3 (Westfall-Young concern)
*
* OUTPUTS:
*   1. BF10 for average treatment effect (Table 4 / H2)
*      → Quantifies evidence FOR the null
*   2. BF10 for heterogeneity coefficients (Table 6 / H4)
*      → Quantifies evidence for receptive/backlash effects
*   3. Westfall-Young correction split by treatment arm
*      → 12 coefficients per family (avg arm; low-income arm)
*      → Robustness check against the original 24-coeff family
*   4. Excel export of all BF results
*
* METHOD:
*   JZS Bayes Factor with Cauchy(0, r=0.707) prior on the
*   standardised effect size (Rouder et al., 2009).
*   Normal approximation to t-distribution used throughout;
*   valid and accurate for n > 100 (all our samples n > 1500).
*   BIC-based BF10 reported as a robustness check.
*
* KEY REFERENCES:
*   Rouder, J. N., Speckman, P. L., Sun, D., Morey, R. D., &
*     Iverson, G. (2009). Bayesian t tests for accepting and
*     rejecting the null hypothesis. Psychonomic Bulletin &
*     Review, 16(2), 225-237.
*   Ly, A., Verhagen, A. J., & Wagenmakers, E.-J. (2016).
*     Harold Jeffreys's default Bayes factor for testing point
*     null hypotheses. Frontiers in Psychology, 7, 378.
*
* NOTE FOR ANTHONY:
*   Verify the treat_ variable mapping by running:
*     tab joint_react
*   before running this file, and confirm that:
*     treat_2 = avg arm, dismissive
*     treat_3 = avg arm, mixed
*     treat_4 = avg arm, receptive
*     treat_5 = low-income arm, dismissive
*     treat_6 = low-income arm, mixed
*     treat_7 = low-income arm, receptive
*   If the mapping differs, adjust the wyoung arm-split
*   commands in Section 4 accordingly.
*
* REQUIRES:
*   - wyoung package (ssc install wyoung)
*   - Final.dta
*   - Globals: $data_path_final, $results
****************************************************


*========================================
* 0. Setup
*========================================

* Globals (matching main analysis file)
global control1 age i.gender_dv citizen partnered_dv log_eq_inc ///
    income_missing postsec_dv race_white i.pol_aff_dv hhsize confidence
global sample3 study==3

use "$data_path_final\Final.dta", clear

* Generate treatment-reception dummies (matching main analysis)
* treat_1 = control (joint_react==1), treat_2 through treat_7 = treatment cells
tab joint_react, gen(treat_)

* Convenience: label the 6 treatment cells for display
* (These labels match the joint_react coding in the main analysis)
local cell_vars  "treat_2 treat_3 treat_4 treat_5 treat_6 treat_7"
local cell_names "Avg_Dismiss Avg_Mix Avg_Recept Low_Dismiss Low_Mix Low_Recept"

* Outcome variables and display labels
local outcomes    "redis_tax_1 redis_tax_2 redis_tax_3 money_given"
local out_labels  "UBI Tax Inequality Donation"

* Restrict to Study 3, comprehension check passed (matching Table 6)
local study3_cond "$sample3 & !inlist(comprehensioncheck,3,4)"


*========================================
* 1. Mata: BF10 functions
*========================================

mata:

// --------------------------------------------------
// bf10_jzs()
// JZS Bayes Factor via numerical integration
//
// Model:
//   H0: beta = 0  →  t ~ N(0, 1)
//   H1: delta ~ Cauchy(0, r)  →  t ~ N(delta*sqrt(n), 1)
//
// BF10 = integral of exp(t*delta*sqrt(n) - delta^2*n/2)
//              * Cauchy(delta; 0, r) d_delta
//
// Integration: trapezoidal rule on [-bound, +bound]
// Step = 0.0005 (sufficient: integrand is essentially zero
// outside |delta| << 1 for n > 100)
//
// Args:
//   t     : t-statistic from OLS regression
//   n     : sample size (e(N))
//   r     : Cauchy prior scale (default 0.707 = 1/sqrt(2))
//
// Returns: BF10 scalar (> 1 = evidence for H1; < 1 = for H0)
// --------------------------------------------------
real scalar bf10_jzs(real scalar t, real scalar n, real scalar r) {

    real scalar delta, step, result, log_lr, cauchy_d
    real scalar bound

    step  = 0.0005
    bound = 10        // Cauchy density negligible beyond |delta|=10 for r<=1

    result = 0
    delta  = -bound

    while (delta <= bound) {

        // Log likelihood ratio: log[p(t|delta) / p(t|0)]
        // Under N(delta*sqrt(n), 1) vs N(0,1):
        log_lr = t * delta * sqrt(n) - (delta^2 * n) / 2

        // Cauchy(delta; 0, r) density
        cauchy_d = r / (pi() * (r^2 + delta^2))

        // Trapezoidal contribution
        result = result + exp(log_lr) * cauchy_d * step

        delta = delta + step
    }

    return(result)
}


// --------------------------------------------------
// bf10_bic()
// BIC-based Bayes Factor approximation
//
// BF10 ≈ exp( (t^2 - log(n)) / 2 )
//
// Equivalent to comparing BIC of model with vs without
// the coefficient of interest (unit information prior).
// Used here as a robustness check alongside the JZS BF.
//
// Reference: Wagenmakers (2007), Psychonomic Bulletin & Review
// --------------------------------------------------
real scalar bf10_bic(real scalar t, real scalar n) {
    return(exp((t^2 - log(n)) / 2))
}


// --------------------------------------------------
// bf_label()
// Returns Jeffreys (1961) evidence strength label
// --------------------------------------------------
string scalar bf_label(real scalar bf10) {
    if      (bf10 >= 100)    return("Extreme evidence for H1")
    else if (bf10 >= 30)     return("Very strong evidence for H1")
    else if (bf10 >= 10)     return("Strong evidence for H1")
    else if (bf10 >= 3)      return("Moderate evidence for H1")
    else if (bf10 >= 1)      return("Anecdotal evidence for H1")
    else if (bf10 >= 1/3)    return("Anecdotal evidence for H0")
    else if (bf10 >= 1/10)   return("Moderate evidence for H0")
    else if (bf10 >= 1/30)   return("Strong evidence for H0")
    else if (bf10 >= 1/100)  return("Very strong evidence for H0")
    else                     return("Extreme evidence for H0")
}

end


*========================================
* 2. BF10 for Average Treatment Effect
*    (Table 4 / H2: null average effect)
*========================================
* We test tr_avg and tr_lowinc across 4 outcomes
* in Study 3 (comprehension check passed)
* BF10 < 1/3 = moderate evidence FOR the null

display _newline(2)
display "========================================================"
display "SECTION 2: Bayes Factors — Average Treatment Effect (H2)"
display "========================================================"
display "Prior: Cauchy(0, r=0.707) | Method: JZS + BIC approx."
display "Sample: Study 3, comprehension check passed"
display "--------------------------------------------------------"

* Storage matrix: 8 rows (4 outcomes × 2 treatments), 5 cols
matrix ATE_BF = J(8, 5, .)
matrix colnames ATE_BF = t_stat n BF10_JZS BF10_BIC BF10_JZS_inv

local rownames ""
local row = 1
local j   = 1

foreach out of local outcomes {

    local outlab : word `j' of `out_labels'

    * Run regression (matching Table 4 specification)
    reg `out' tr_avg tr_lowinc $control1 if `study3_cond', robust

    local n_obs = e(N)

    foreach treat in tr_avg tr_lowinc {

        local t_val = _b[`treat'] / _se[`treat']

        * Compute BF10
        mata: st_numscalar("r_bf_jzs", bf10_jzs(`t_val', `n_obs', 0.707))
        mata: st_numscalar("r_bf_bic", bf10_bic(`t_val', `n_obs'))

        * Store
        matrix ATE_BF[`row', 1] = `t_val'
        matrix ATE_BF[`row', 2] = `n_obs'
        matrix ATE_BF[`row', 3] = r_bf_jzs
        matrix ATE_BF[`row', 4] = r_bf_bic
        matrix ATE_BF[`row', 5] = 1 / r_bf_jzs   // BF01: evidence for null

        * Display
        display "`outlab' | `treat':"
        display "  t = " %6.3f `t_val' "  |  n = " `n_obs'
        display "  BF10 (JZS) = " %8.4f r_bf_jzs  ///
                "  |  BF01 = " %8.4f (1/r_bf_jzs)
        display "  BF10 (BIC) = " %8.4f r_bf_bic
        mata: display("  Evidence:   " + bf_label(r_bf_jzs))
        display "  ..."

        local rownames "`rownames' `outlab'_`treat'"
        local row = `row' + 1
    }
    local j = `j' + 1
}

matrix rownames ATE_BF = `rownames'

display _newline "Summary matrix — Average Treatment Effect BFs:"
matrix list ATE_BF, format(%8.4f)


*========================================
* 3. BF10 for Heterogeneity Coefficients
*    (Table 6 / H4: reception profiles)
*========================================
* 6 treatment-reception cells × 4 outcomes = 24 coefficients
* Key cells of interest:
*   Low_Dismiss (treat_5): backlash — expect BF10 >> 1
*   Low_Recept  (treat_7): positive shift — expect BF10 > 1
*   All Avg arm cells: expect BF10 ≈ 1 (no heterogeneity)

display _newline(2)
display "========================================================"
display "SECTION 3: Bayes Factors — Heterogeneity (Table 6 / H4)"
display "========================================================"
display "Prior: Cauchy(0, r=0.707) | Method: JZS + BIC approx."
display "--------------------------------------------------------"

* Storage matrix: 24 rows (4 outcomes × 6 cells), 5 cols
matrix HET_BF = J(24, 5, .)
matrix colnames HET_BF = t_stat n BF10_JZS BF10_BIC BF10_JZS_inv

local rownames ""
local row = 1
local j   = 1

foreach out of local outcomes {

    local outlab : word `j' of `out_labels'

    * Run regression (matching Table 6 specification)
    reg `out' treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 ///
        $control1 if `study3_cond', robust

    local n_obs = e(N)

    local k = 1
    foreach cell of local cell_vars {

        local celllab : word `k' of `cell_names'
        local t_val = _b[`cell'] / _se[`cell']

        mata: st_numscalar("r_bf_jzs", bf10_jzs(`t_val', `n_obs', 0.707))
        mata: st_numscalar("r_bf_bic", bf10_bic(`t_val', `n_obs'))

        matrix HET_BF[`row', 1] = `t_val'
        matrix HET_BF[`row', 2] = `n_obs'
        matrix HET_BF[`row', 3] = r_bf_jzs
        matrix HET_BF[`row', 4] = r_bf_bic
        matrix HET_BF[`row', 5] = 1 / r_bf_jzs

        display "`outlab' | `celllab':"
        display "  t = " %6.3f `t_val' "  |  n = " `n_obs'
        display "  BF10 (JZS) = " %8.4f r_bf_jzs ///
                "  |  BF01 = " %8.4f (1/r_bf_jzs)
        display "  BF10 (BIC) = " %8.4f r_bf_bic
        mata: display("  Evidence:   " + bf_label(r_bf_jzs))
        display "  ..."

        local rownames "`rownames' `outlab'_`celllab'"
        local row = `row' + 1
        local k   = `k' + 1
    }
    local j = `j' + 1
}

matrix rownames HET_BF = `rownames'

display _newline "Summary matrix — Heterogeneity BFs:"
matrix list HET_BF, format(%8.4f)


*========================================
* 4. Westfall-Young: Split by Treatment Arm
*    Robustness check vs original 24-coeff family
*========================================
* RATIONALE (for response letter):
*   The original WY pools both arms (24 coefficients).
*   A more principled family definition splits by arm,
*   since the two arms are conceptually distinct interventions.
*   Pooling penalises the low-income arm for multiple testing
*   burden generated by the avg arm (which shows no heterogeneity).
*   We report both: original 24-coeff (conservative benchmark)
*   and arm-split 12-coeff (principled alternative).

display _newline(2)
display "========================================================"
display "SECTION 4: Westfall-Young, Split by Treatment Arm"
display "========================================================"

* --- 4a. Original (24-coefficient family) — for reference ---
display _newline "--- 4a. Original: 24-coefficient family (both arms combined) ---"
wyoung redis_tax_1 redis_tax_2 redis_tax_3 money_given, ///
    cmd("reg OUTCOMEVAR treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 ///
        $control1 if `study3_cond', robust") ///
    familyp(treat_2 treat_3 treat_4 treat_5 treat_6 treat_7) ///
    bootstraps(1000) seed(124)

* --- 4b. Arm split: Average American arm (12 coefficients) ---
* treat_2 = avg dismiss | treat_3 = avg mix | treat_4 = avg recept
display _newline "--- 4b. Arm split: Average American arm (12 coefficients) ---"
wyoung redis_tax_1 redis_tax_2 redis_tax_3 money_given, ///
    cmd("reg OUTCOMEVAR treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 ///
        $control1 if `study3_cond', robust") ///
    familyp(treat_2 treat_3 treat_4) ///
    bootstraps(1000) seed(124)

* --- 4c. Arm split: Low-income arm (12 coefficients) ---
* treat_5 = low dismiss | treat_6 = low mix | treat_7 = low recept
display _newline "--- 4c. Arm split: Low-income arm (12 coefficients) ---"
wyoung redis_tax_1 redis_tax_2 redis_tax_3 money_given, ///
    cmd("reg OUTCOMEVAR treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 ///
        $control1 if `study3_cond', robust") ///
    familyp(treat_5 treat_6 treat_7) ///
    bootstraps(1000) seed(124)

* NOTE: The wyoung cmd includes all 6 treat_ dummies in the regression
* (matching Table 6 specification) but the familyp correction is applied
* only to the arm-specific subset. This correctly accounts for the full
* model while restricting the multiple testing correction to the relevant family.


*========================================
* 5. Export to Excel
*========================================

display _newline(2)
display "========================================================"
display "SECTION 5: Exporting results to Excel"
display "========================================================"

putexcel set "$results/bayes_factors.xlsx", replace

* --- Header ---
putexcel A1 = "Bayes Factor Analysis — Well-being Norms Paper"
putexcel A2 = "Prior: Cauchy(0, r=0.707) on standardised effect size"
putexcel A3 = "Method: JZS Bayes Factor (normal approximation to t); BIC approximation as robustness check"
putexcel A4 = "Reference: Rouder et al. (2009); Ly et al. (2016)"
putexcel A5 = "Jeffreys scale: BF10 > 10 = strong H1; BF10 < 1/10 = strong H0; BF10 in (1/3, 3) = ambiguous"

* --- Table: Average Treatment Effect ---
putexcel A7 = "TABLE A: Bayes Factors — Average Treatment Effect (H2)"
putexcel A8 = "Interpretation: BF10 < 1/3 = moderate evidence FOR the null"
putexcel A9 = matrix(ATE_BF), names

* --- Table: Heterogeneity ---
local het_row = 9 + rowsof(ATE_BF) + 4
putexcel A`het_row' = "TABLE B: Bayes Factors — Heterogeneity by Reception Profile (H4)"
local het_row2 = `het_row' + 1
putexcel A`het_row2' = "Key cells: Low_Dismiss (backlash) and Low_Recept (positive shift)"
local het_row3 = `het_row' + 2
putexcel A`het_row3' = matrix(HET_BF), names

display "Results saved to: $results/bayes_factors.xlsx"
display _newline "Done. Review ATE_BF and HET_BF matrices above."
display "Westfall-Young arm-split results are in the Stata output log."
