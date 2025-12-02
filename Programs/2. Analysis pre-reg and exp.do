
		*************************************
		*		1. Setting globals			*
		*************************************

			global sample1 study==1
			global sample2 study==2
			global sample3 study==3
			global sample12 inlist(study,1,2)
			global sample23 inlist(study,2,3)
			global sample13 inlist(study,1,3)
			global sample123 inlist(study,1,2,3)
			
			global belief personal_threshold others_average similar_average poor_focused gap_avg gap_like gap_low norm_gap_avg norm_gap_sim norm_gap_low norm_gap_avg_v3 norm_gap_sim_v3
			global socio age gen_d_1 gen_d_2 gen_d_3 citizen partnered_dv log_eq_inc postsec_dv race_white pol_d_1 pol_d_2 pol_d_3  hhsize life_ladder		
			global controlb1 personal_threshold3 others_average3 similar_average3 poor_focused3 eq_inc3 
			global controlb2 log_personal_threshold log_others_average log_similar_average log_poor_focused log_eq_inc
			global control1 age i.gender_dv citizen partnered_dv log_eq_inc income_missing postsec_dv race_white i.pol_aff_dv hhsize confidence
			global control2 age i.gender_dv citizen partnered_dv postsec_dv race_white i.pol_aff_dv hhsize income_missing
			global stat_outcome personal_threshold others_average poor_focused redist_index redis_tax_1 redis_tax_2 redis_tax_3 money_given bonus_1 bonus_2 bonus_3
			global stat_control age gen_d_1 gen_d_2 gen_d_3 citizen partnered_dv postsec_dv race_white hhsize pol_d_1 pol_d_2 pol_d_3 log_eq_inc

			use "$data_path_final\Final.dta", clear
					
		*********************************************
		*		2. Analysis for manuscript			*
		*********************************************

			** Table 1: Descriptive Statistics of Beliefs, Gaps and sociodemographics in Study 1 **
			
				su $belief $socio if $sample1
				
				foreach var in $belief {
				ttest `var'=0 if $sample1
				}
				su $belief $socio if $sample1 & income<=3
			
		
			** Table 2: Predictors of gaps and PI in Study 1 **
						
				local l=1
				eststo clear

				foreach var in personal_threshold3 others_average3 similar_average3 poor_focused3 gap_avg3 gap_like3 gap_low3 abs_norm_gap_avg3 abs_norm_gap_low3 abs_norm_gap_sim3 {
					reg `var' $control1 if $sample1, robust
					eststo reg`l'
					su `var' if e(sample)==1
					local l=`l'+1
				}

				esttab reg* using "$results/table2.rtf", ///
				rtf replace label compress b(%9.3f) se(%9.3f) ///
				star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared")) ///
				keep(log_eq_inc 2.pol_aff_dv 3.pol_aff_dv confidence) ///
				order(confidence log_eq_inc 2.pol_aff_dv 3.pol_aff_dv)
				

			** Table 3: Are key outcomes influenced by beliefs in Study 1 **

				foreach var in life_ladder redis_tax_1 redis_tax_2 redis_tax_3 money_given {
					reg `var' personal_threshold3 others_average3 similar_average3 poor_focused3 $control1 if $sample1, robust
					eststo `var'_raw
					reg `var' log_personal_threshold log_others_average log_similar_average log_poor_focused $control1 if $sample1, robust
					eststo `var'_log
					reg `var' norm_gap_avg3 norm_gap_low3 $control1 if $sample1, robust
					eststo `var'_gap	
					reg `var' abs_norm_gap_avg3 abs_norm_gap_low3 $control1 if $sample1, robust
					eststo `var'_abs_gap					
					}

					esttab life_ladder_raw redis_tax_1_raw redis_tax_2_raw redis_tax_3_raw money_given_raw ///
					using "$results/table3_panelA.rtf", rtf replace ///
					keep(personal_threshold3 others_average3 similar_average3 poor_focused3 log_eq_inc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))

					esttab life_ladder_gap redis_tax_1_gap redis_tax_2_gap redis_tax_3_gap money_given_gap ///
					using "$results/table3_panelB.rtf", rtf replace ///
					keep(norm_gap_avg3 norm_gap_low3 log_eq_inc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))

					esttab life_ladder_abs_gap redis_tax_1_abs_gap redis_tax_2_abs_gap redis_tax_3_abs_gap money_given_abs_gap ///
					using "$results/table3_panelC.rtf", rtf replace ///
					keep(abs_norm_gap_avg3 abs_norm_gap_low3 log_eq_inc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))
				
				
			** Table 4: Treatment effects on redistribution attitudes and donation **

				* Estimation Sample: Study 2 *
				
					foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
						reg `var' tr_avg tr_lowinc $control1 if $sample2, robust
						eststo `var'_full
						}
						
					esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
					using "$results/table4_panelA.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared")) ///
					varlabels(tr_avg    "Correction: average" ///
							  tr_lowinc "Correction: low-income")

				* Estimation Sample: Study 3 *
					
					foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
						reg `var' tr_avg tr_lowinc $control1 if $sample3, robust
						eststo `var'_full
						}
						
					esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
					using "$results/table4_panelB.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared")) ///
					varlabels(tr_avg    "Correction: average" ///
							  tr_lowinc "Correction: low-income")
					
				* Estimation Sample: Study 3 excluding those who failed comprehension check *
				
					foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
						reg `var' tr_avg tr_lowinc $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo `var'_full
						}
					
					esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
					using "$results/table4_panelC.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared")) ///
					varlabels(tr_avg    "Correction: average" ///
							  tr_lowinc "Correction: low-income")
					
	
				** Table 5: Updates of pluralistic ignorance **
					
					foreach var in others_average_post poor_focused_post delta_others_average delta_poor_focused norm_gap_avg_post norm_gap_low_post abs_norm_gap_avg_post abs_norm_gap_low_post {
						reg `var' tr_avg tr_lowinc $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo adj_`var'
						}

					foreach var in norm_gap_avg norm_gap_low abs_norm_gap_avg abs_norm_gap_low {					
						su `var' if $sample3 & !inlist(comprehensioncheck,3,4)	
						}
					
					esttab adj_norm_gap_avg_post adj_norm_gap_low_post adj_abs_norm_gap_avg_post adj_abs_norm_gap_low_post ///
					using "$results/table5.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared")) ///
					varlabels(tr_avg    "Correction: average" ///
							  tr_lowinc "Correction: low-income")			
				
					
				** Table 6: Treatment effects **

					foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
						reg `var' i.joint_* $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo `var'_full2						
						}
						
					esttab redis_tax_1_full2 redis_tax_2_full2 redis_tax_3_full2 money_given_full2 ///
					using "$results/table6.rtf", rtf replace ///
					keep(2.joint_react 3.joint_react 5.joint_react 6.joint_react 7.joint_react 9.joint_react) ///
					order(6.joint_react 7.joint_react 9.joint_react 2.joint_react 3.joint_react 5.joint_react) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))
						
					tab joint_react, gen(treat_)						
					wyoung redis_tax_1 redis_tax_2 redis_tax_3 money_given, cmd("reg OUTCOMEVAR treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust") familyp( treat_2 treat_3 treat_4 treat_5 treat_6 treat_7) bootstraps(1000) seed(124)	

					foreach var in norm_gap_avg norm_gap_low abs_norm_gap_avg abs_norm_gap_low {					
						bys joint_react:  su `var' if $sample3 & !inlist(comprehensioncheck,3,4)	
						}					

					
		*********************************************
		*		3. Analysis for appendix			*
		*********************************************

			** Figure B1: Beliefs vs actually needed - continuous **

				* Panel (A): On average *
					
					twoway ///
					(kdensity others_average, lcolor(red) bw(2000)) ///
					if $sample1, ///
					ytitle("Density") xtitle("Income threshold (USD)") ///
					xline(13592.22, lcolor(black) lpattern(dash)) ///
					text(0.00008 14000 "What's really needed", place(e) color(black)) ///
					name(other_raw, replace)
					graph export "$results/figureB1_panelA.png", replace width(2000)
					
				* Panel (B): For low-income families *

					twoway ///
					(kdensity poor_focused, lcolor(orange) bw(2000)) ///
					if $sample1, ///
					ytitle("Density") xtitle("Income threshold (USD)") ///
					xline(8852.47, lcolor(black) lpattern(dash)) ///
					text(0.0001 9200 "What's really needed (low-income families)", place(e) color(black)) ///
					name(poor_raw, replace)
					graph export "$results/figureB1_panelB.png", replace width(2000)					
									

			** Figure B2: Beliefs vs actually needed - In percentage **

				* Panel (A): On average *

					twoway ///
					(histogram gap_band if $sample1, discrete percent fcolor(none) lcolor(navy)) ///
					, xlabel(0(1)5, valuelabel angle(45)) xtitle("Belief ÷ Actual") ytitle("Percentage") ///
					name(gap_avg, replace)
					graph export "$results/figureB2_panelA.png", replace width(2000)

				* Panel (B): For low-income families *

					twoway ///
					(histogram gap_low_band if $sample1, discrete percent fcolor(none) lcolor(navy)) ///
					, xlabel(0(1)5, valuelabel angle(45)) xtitle("Belief ÷ Actual") ytitle("Percentage") ///
					name(gap_poor, replace)	  
					graph export "$results/figureB2_panelB.png", replace width(2000)									

					
			** Figure B3: Update of beliefs in Study 3 **
	
				* Panel (A): On average *
	
					twoway ///
					(kdensity others_average if tr_avg==1, lcolor(blue) bw(2000)) ///
					(kdensity others_average_post if tr_avg==1 & !inlist(comprehensioncheck,3,4),     lcolor(red) bw(2000)) ///
					if $sample3, ///
					legend(order(1 "Before treatment" ///
								 2 "After treatment and valid comprehension check") ///
								ring(0) pos(1) col(1)) ///
					ytitle("Density") xtitle("Income threshold (USD)") ///
					xline(13592.22, lcolor(black) lpattern(dash)) ///
					text(0.00008 14000 "What's really needed", place(e) color(black)) ///
					name(update1, replace)
					graph export "$results/figureB3_panelA.png", replace width(2000)	

				* Panel (B): For low-income families *
					
					twoway ///
					(kdensity poor_focused if tr_low==1, lcolor(blue) bw(2000)) ///
					(kdensity poor_focused_post if tr_low==1 & !inlist(comprehensioncheck,3,4),     lcolor(red) bw(2000)) ///
					if $sample3, ///
					legend(order(1 "Before treatment" ///
								 2 "After treatment and valid comprehension check") ///
								ring(0) pos(1) col(1)) ///
					ytitle("Density") xtitle("Income threshold (USD)") ///
					xline(8852.47, lcolor(black) lpattern(dash)) ///
					text(0.0001 9200 "What's really needed (low-income families)", place(e) color(black)) ///
					name(update2, replace)
					graph export "$results/figureB3_panelB.png", replace width(2000)				
					
									
			** Table B1: Desc stat three samples **
		
				local vars $stat_outcome
				local k : word count `vars'

				matrix BAL = J(2*`k', 6, .)
				matrix colnames BAL = mean_s1 mean_s2 diff21 mean_s3 diff31 diff32
				local rnames

				local rix = 1
				foreach v of local vars {

					* S1 vs S2
					ttest `v' if $sample12, by(study)
					local m1  = r(mu_1)
					local sd1 = r(sd_1)
					local m2  = r(mu_2)
					local sd2 = r(sd_2)
					local d21 = r(mu_2) - r(mu_1)
					local se21 = r(se)

					* S1 vs S3
					ttest `v' if $sample13, by(study)
					local m3  = r(mu_2)   // in $sample13, group 2 corresponds to study 3
					local sd3 = r(sd_2)
					local d31 = r(mu_2) - r(mu_1)
					local se31 = r(se)

					* S2 vs S3
					ttest `v' if $sample23, by(study)
					local d32  = r(mu_2) - r(mu_1)
					local se32 = r(se)

					* Row 1: means & diffs in your order
					matrix BAL[`rix',1] = `m1'
					matrix BAL[`rix',2] = `m2'
					matrix BAL[`rix',3] = `d21'
					matrix BAL[`rix',4] = `m3'
					matrix BAL[`rix',5] = `d31'
					matrix BAL[`rix',6] = `d32'

					* Row 2: SDs for means, SEs for diffs (aligned to columns)
					local rix2 = `rix' + 1
					matrix BAL[`rix2',1] = `sd1'
					matrix BAL[`rix2',2] = `sd2'
					matrix BAL[`rix2',3] = `se21'
					matrix BAL[`rix2',4] = `sd3'
					matrix BAL[`rix2',5] = `se31'
					matrix BAL[`rix2',6] = `se32'

					* Row names (use variable label if present)
					local lbl : variable label `v'
					if "`lbl'" == "" local lbl "`v'"
					local rnames `"`rnames' "`lbl' (mean/diff)" "`lbl' (sd/se)""'

					local rix = `rix' + 2
				}

				
				matlist BAL, format(%9.3f) rowtitle("")
				esttab matrix(BAL, fmt(%9.3f)) using "$results/tableB1.rtf", rtf replace ///
				nomtitle nonumber compress ///
				title("Balance table: S1, S2, S3") ///
				cell("mean_s1(fmt(3)) mean_s2(fmt(3)) diff21(fmt(3)) mean_s3(fmt(3)) diff31(fmt(3)) diff32(fmt(3))")


			** Table B2: Balance of covariates **

				local vars $stat_control
				local k : word count `vars'

				matrix BAL = J(2*`k', 6, .)
				matrix colnames BAL = mean_s1 mean_s2 diff21 mean_s3 diff31 diff32

				local rnames
				local rix = 1

				foreach v of local vars {
					* Study 1 vs Study 2
					ttest `v' if $sample12, by(study)
					local m1  = r(mu_1)
					local sd1 = r(sd_1)
					local m2  = r(mu_2)
					local sd2 = r(sd_2)
					local d21 = r(mu_2) - r(mu_1)
					local se21 = r(se)

					* Study 1 vs Study 3
					ttest `v' if $sample13, by(study)
					local m3  = r(mu_2)   // in sample13, group 2 = study 3
					local sd3 = r(sd_2)
					local d31 = r(mu_2) - r(mu_1)
					local se31 = r(se)

					* Study 2 vs Study 3
					ttest `v' if $sample23, by(study)
					local d32  = r(mu_2) - r(mu_1)
					local se32 = r(se)

					* Row 1: means & differences
					matrix BAL[`rix',1] = `m1'
					matrix BAL[`rix',2] = `m2'
					matrix BAL[`rix',3] = `d21'
					matrix BAL[`rix',4] = `m3'
					matrix BAL[`rix',5] = `d31'
					matrix BAL[`rix',6] = `d32'

					* Row 2: SDs for means, SEs for differences
					local rix2 = `rix' + 1
					matrix BAL[`rix2',1] = `sd1'
					matrix BAL[`rix2',2] = `sd2'
					matrix BAL[`rix2',3] = `se21'
					matrix BAL[`rix2',4] = `sd3'
					matrix BAL[`rix2',5] = `se31'
					matrix BAL[`rix2',6] = `se32'

					local rix = `rix' + 2
				}

				* Manually assign clean rownames
				matrix rownames BAL =  ///
					"Age" "" ///
					"Female" "" ///
					"Non-binary" "" ///
					"Other gender" "" ///
					"US citizen" "" ///
					"Partnered" "" ///
					"Post-secondary education" "" ///
					"White" "" ///
					"Household size" "" ///
					"Democrat" "" ///
					"Independent" "" ///
					"Republican" "" ///
					"Log equivalized income" ""

				matlist BAL, format(%9.3f) rowtitle("")
				esttab matrix(BAL, fmt(%9.3f)) using "$results/tableB2.rtf", rtf replace ///
				nomtitle nonumber compress ///
				title("Balance of covariates across studies") ///
				cell("mean_s1(fmt(3)) mean_s2(fmt(3)) diff21(fmt(3)) mean_s3(fmt(3)) diff31(fmt(3)) diff32(fmt(3))") 
	
		
			** Table B3: Balance of covariates across treatment vs control **
	
				local vars $stat_control
				local k : word count `vars'

				matrix BAL = J(2*`k', 3, .)
				matrix colnames BAL = mean_s1 mean_s2 diff21

				local rnames
				local rix = 1

				foreach v of local vars {
					* Study 1 vs Study 2
					ttest `v' if $sample23, by(treat_coll)
					local m1  = r(mu_1)
					local sd1 = r(sd_1)
					local m2  = r(mu_2)
					local sd2 = r(sd_2)
					local d21 = r(mu_2) - r(mu_1)
					local se21 = r(se)

					* Row 1: means & differences
					matrix BAL[`rix',1] = `m1'
					matrix BAL[`rix',2] = `m2'
					matrix BAL[`rix',3] = `d21'

					* Row 2: SDs for means, SEs for differences
					local rix2 = `rix' + 1
					matrix BAL[`rix2',1] = `sd1'
					matrix BAL[`rix2',2] = `sd2'
					matrix BAL[`rix2',3] = `se21'

					local rix = `rix' + 2
				}

				* Manually assign clean rownames
				matrix rownames BAL =  ///
					"Age" "" ///
					"Female" "" ///
					"Non-binary" "" ///
					"Other gender" "" ///
					"US citizen" "" ///
					"Partnered" "" ///
					"Post-secondary education" "" ///
					"White" "" ///
					"Household size" "" ///
					"Democrat" "" ///
					"Independent" "" ///
					"Republican" "" ///
					"Log equivalized income" ""

				matlist BAL, format(%9.3f) rowtitle("")
				esttab matrix(BAL, fmt(%9.3f)) using "$results/tableB3.rtf", rtf replace ///
				nomtitle nonumber compress ///
				title("Balance of covariates across studies") ///
				cell("mean_s1(fmt(3)) mean_s2(fmt(3)) diff21(fmt(3)) mean_s3(fmt(3)) diff31(fmt(3)) diff32(fmt(3))") 

				
	
			** Table B4: Treatment effects on redistribution attitudes and donation **

				* Estimation Sample: Study 2 *
				
					foreach var in delta_life_ladder life_ladder_post {
						reg `var' tr_avg tr_lowinc $control1 if $sample2, robust
						eststo `var'_full
						}
						
					esttab delta_life_ladder_full life_ladder_post_full ///
					using "$results/tableB4_panelA.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))

				* Estimation Sample: Study 3 *
					
					foreach var in delta_life_ladder life_ladder_post {
						reg `var' tr_avg tr_lowinc $control1 if $sample3, robust
						eststo `var'_full
						}
						
					esttab delta_life_ladder_full life_ladder_post_full ///
					using "$results/tableB4_panelB.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))
					
				* Estimation Sample: Study 3 excluding those who failed comprehension check *
				
					foreach var in delta_life_ladder life_ladder_post {
						reg `var' tr_avg tr_lowinc $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo `var'_full
						}
					
					esttab delta_life_ladder_full life_ladder_post_full ///
					using "$results/tableB4_panelC.rtf", rtf replace ///
					keep(tr_avg tr_lowinc) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))				
				
				
			** Table B5: Reactions to corrective treatments, redistribution items and donation – OLS results **		
					
				foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
					reg `var' i.a_believe_d i.p_believe_d $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
					eststo `var'_short
					reg `var' i.a_similar_d i.p_similar_d $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
					eststo `var'_full				
					}					
					
				esttab redis_tax_1_short redis_tax_2_short redis_tax_3_short money_given_short ///
				using "$results/tableB5_panelA.rtf", rtf replace ///
				keep(1.a_believe_d 2.a_believe_d 1.p_believe_d 2.p_believe_d) ///
				label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared"))
					
				esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
				using "$results/tableB5_panelB.rtf", rtf replace ///
				keep(1.a_similar_d 2.a_similar_d 1.p_similar_d 2.p_similar_d) ///
				label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared"))
	
	
			** Table B6: Beliefs updating of well-being norms – OLS results **		
		
				foreach var in redist_index money_given {
					reg `var' i.joint_* $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
					eststo `var'_full2						
					}

					esttab redist_index_full2 money_given_full2 ///
					using "$results/tableB6.rtf", rtf replace ///
					keep(2.joint_react 3.joint_react 5.joint_react 6.joint_react 7.joint_react 9.joint_react) ///
					order(6.joint_react 7.joint_react 9.joint_react 2.joint_react 3.joint_react 5.joint_react) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))
					
					wyoung redist_index money_given, cmd("reg OUTCOMEVAR treat_2 treat_3 treat_4 treat_5 treat_6 treat_7 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust") familyp( treat_2 treat_3 treat_4 treat_5 treat_6 treat_7) bootstraps(1000) seed(124)					
				
				
				
			** Table B7: Reactions to corrective treatments, redistribution items and donation – OLS results **

				foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
					reg `var' c.tr_avg##c.deservingness_1 c.tr_lowinc##c.deservingness_1 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
					eststo `var'_short
					reg `var' c.tr_avg##c.deservingness_2 c.tr_lowinc##c.deservingness_2 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
					eststo `var'_full
					reg `var' c.tr_avg##c.deservingness_3 c.tr_lowinc##c.deservingness_3 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust		
					eststo `var'_full2
					}
						
				esttab redis_tax_1_short redis_tax_2_short redis_tax_3_short money_given_short ///
				using "$results/tableB7_panelA.rtf", rtf replace ///
				keep(tr_avg c.tr_avg#c.deservingness_1 tr_lowinc c.tr_lowinc#c.deservingness_1) ///
				label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared"))				
					
				esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
				using "$results/tableB7_panelB.rtf", rtf replace ///
				keep(tr_avg c.tr_avg#c.deservingness_2 tr_lowinc c.tr_lowinc#c.deservingness_2) ///
				label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared"))

				esttab redis_tax_1_full2 redis_tax_2_full2 redis_tax_3_full2 money_given_full2 ///
				using "$results/tableB7_panelC.rtf", rtf replace ///
				keep(tr_avg c.tr_avg#c.deservingness_3 tr_lowinc c.tr_lowinc#c.deservingness_3) ///
				label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
				stats(N r2, labels("Observations" "R-squared"))
					
				** Table B8: Reactions to corrective treatments, redistribution items and donation – OLS results **

					foreach var in redis_tax_1 redis_tax_2 redis_tax_3 money_given {
						reg `var' c.tr_avg##c.norm_gap_avg3 c.tr_lowinc##c.norm_gap_low3 $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo `var'_short
						reg `var' c.tr_avg##c.confidence c.tr_lowinc##c.confidence $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo `var'_full
						}
						
					esttab redis_tax_1_short redis_tax_2_short redis_tax_3_short money_given_short ///
					using "$results/tableB8_panelA.rtf", rtf replace ///
					keep(tr_avg c.tr_avg#c.norm_gap_avg3 tr_lowinc c.tr_lowinc#c.norm_gap_low3) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))
					
					esttab redis_tax_1_full redis_tax_2_full redis_tax_3_full money_given_full ///
					using "$results/tableB8_panelB.rtf", rtf replace ///
					keep(tr_avg c.tr_avg#c.confidence tr_lowinc c.tr_lowinc#c.confidence) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared")) 
				
				
				** Table B9: Causal mediation analysis – Natural indirect effects of gaps in well-being norms for low-income families **

					mediate (redis_tax_1  $control1) (abs_norm_gap_low_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (redis_tax_2  $control1) (abs_norm_gap_low_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (redis_tax_3  $control1) (abs_norm_gap_low_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (money_given  $control1) (abs_norm_gap_low_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction



				** Table B10: Causal mediation analysis – Natural indirect effects of gaps in well-being norms for average American **

					mediate (redis_tax_1  $control1) (abs_norm_gap_avg_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (redis_tax_2  $control1) (abs_norm_gap_avg_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (redis_tax_3  $control1) (abs_norm_gap_avg_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction

					mediate (money_given  $control1) (abs_norm_gap_avg_post $control1) (joint_react) if $sample3 & !inlist(comprehensioncheck,3,4), nointeraction
					
					
					
				** Table B11: Beliefs updating of well-being norms – OLS results **
					
					foreach var in norm_gap_avg_post norm_gap_low_post abs_norm_gap_avg_post abs_norm_gap_low_post {
						reg `var' i.joint_* $control1 if $sample3 & !inlist(comprehensioncheck,3,4), robust
						eststo adj2_`var'
						}					
					
					esttab adj2_norm_gap_avg_post adj2_norm_gap_low_post adj2_abs_norm_gap_avg_post adj2_abs_norm_gap_low_post ///
					using "$results/tableB11.rtf", rtf replace ///
					keep(2.joint_react 3.joint_react 5.joint_react 6.joint_react 7.joint_react 9.joint_react) ///
					order(6.joint_react 7.joint_react 9.joint_react 2.joint_react 3.joint_react 5.joint_react) ///
					label b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
					stats(N r2, labels("Observations" "R-squared"))					