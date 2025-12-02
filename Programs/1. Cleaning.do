
		*****************************************************
		*		1. Transforming raw .csv into .dta			*
		*****************************************************

			import delimited "$data_path_study1/Pluralistic_ignorance_baseline_labeled_28Jul2025.csv", clear
			save "$data_path_final\Study1_raw.dta", replace

			import delimited "$data_path_study2/Pluralistic_ignorance_study2.csv", clear
			save "$data_path_final\Study2_raw.dta", replace

			import delimited "$data_path_study3/Pluralistic_ignorance_Study3_with_manipulation_check_label.csv", clear
			save "$data_path_final\Study3_raw.dta", replace
			
		*************************************
		*		2. Cleaning routine			*
		*************************************

			forvalues i=1(1)3 {
				use "$data_path_final\Study`i'_raw.dta", clear

					* Cleaning shared across surveys *
					
						* Cleaning at the study level *
						
					gen study=`i'
					label variable age "Study ID"

					keep if q15=="Thailand" /* keep if final comprehension check validated - #obs excluded per study (in %), respectively: 9 (0.83%), 2 (0.12%), 6 (0.37%) */
					
						* Cleaning at the individual level *
						
							* Sociodemographics *
							
								label variable age "Age"

								clonevar gender_str = gender
								drop gender
								gen gender = .
								replace gender = 1 if gender_str=="Male"
								replace gender = 2 if gender_str=="Female"
								replace gender = 3 if gender_str=="Non-binary/third gender" | gender_str=="Non-binary / third gender"
								replace gender = 4 if gender_str=="Other"
								replace gender = 5 if gender_str=="Prefer not to say"
								label define genderlbl 1 "Male" 2 "Female" 3 "Non-binary/third gender" 4 "Other" 5 "Prefer not to say", replace
								label values gender genderlbl
								label variable gender "Gender"

								clonevar residence_str = residence
								drop residence
								gen residence = .
								replace residence = 1 if inlist(residence_str,"Yes")
								replace residence = 0 if inlist(residence_str,"No")
								label define residencelbl 1 "Yes" 0 "No", replace
								label values residence residencelbl
								label variable residence "US resident"

								clonevar citizen_str = citizen
								drop citizen
								gen citizen = .
								replace citizen = 1 if inlist(citizen_str,"Yes")
								replace citizen = 0 if inlist(citizen_str,"No")
								label define citizenlbl 1 "Yes" 0 "No", replace
								label values citizen citizenlbl
								label variable citizen "US citizen"

								clonevar marital_status_str = marital_status
								drop marital_status
								gen marital_status = .
								replace marital_status = 1 if marital_status_str=="Single"
								replace marital_status = 2 if marital_status_str=="Married"
								replace marital_status = 3 if marital_status_str=="Cohabiting"
								replace marital_status = 4 if marital_status_str=="Divorced"
								replace marital_status = 5 if marital_status_str=="Separated"
								replace marital_status = 6 if marital_status_str=="Widowed"
								replace marital_status = 7 if marital_status_str=="Prefer not to say"
								label define maritallbl 1 "Single" 2 "Married" 3 "Cohabiting" 4 "Divorced" 5 "Separated" 6 "Widowed" 7 "Prefer not to say", replace
								label values marital_status maritallbl
								label variable marital_status "Marital status"

								clonevar income_str = income
								drop income
								gen income = .
								replace income = 1  if income_str=="Less than $1,000/month"
								replace income = 2  if income_str=="$1,000–$1,666/month" 
								replace income = 3  if income_str=="$1,667–$2,499/month"
								replace income = 4  if income_str=="$2,500–$3,333/month"
								replace income = 5  if income_str=="$3,334–$4,166/month"
								replace income = 6  if income_str=="$4,167–$4,999/month"
								replace income = 7  if income_str=="$5,000–$5,833/month"
								replace income = 8  if income_str=="$5,834–$6,666/month"
								replace income = 9  if income_str=="$6,667–$7,499/month"
								replace income = 10 if income_str=="$7,500–$8,333/month"
								replace income = 11 if income_str=="$8,334–$12,499/month"
								replace income = 12 if income_str=="$12,500/month or more"
								replace income = 13 if income_str=="Prefer not to say"
								label define incomelbl ///
								  1 "Less than $1,000/month" ///
								  2 "$1,000–$1,666/month" ///
								  3 "$1,667–$2,499/month" ///
								  4 "$2,500–$3,333/month" ///
								  5 "$3,334–$4,166/month" ///
								  6 "$4,167–$4,999/month" ///
								  7 "$5,000–$5,833/month" ///
								  8 "$5,834–$6,666/month" ///
								  9 "$6,667–$7,499/month" ///
								  10 "$7,500–$8,333/month" ///
								  11 "$8,334–$12,499/month" ///
								  12 "$12,500/month or more" ///
								  13 "Prefer not to say", replace
								label values income incomelbl
								label variable income "Gross monthly household income"

								clonevar education_str = education
								drop education
								gen education = .
								replace education = 1 if education_str=="Some high school"
								replace education = 2 if education_str=="High school graduate or GED equivalent"
								replace education = 3 if education_str=="Some undergraduate"
								replace education = 4 if education_str=="Completed undergraduate"
								replace education = 5 if education_str=="Some graduate"
								replace education = 6 if education_str=="Completed graduate (Master's or PhD)"
								replace education = 7 if education_str=="Other"
								replace education = 8 if education_str=="Prefer not to say"
								replace education = 6 if education==.
								label define educationlbl 1 "Some high school" 2 "High school graduate or GED equivalent" 3 "Some undergraduate" 4 "Completed undergraduate" 5 "Some graduate" 6 "Completed graduate (Master's or PhD)" 7 "Other" 8 "Prefer not to say", replace
								label values education educationlbl
								label var education "Highest level of education?"

								clonevar political_aff_str = politic_aff
								drop politic_aff
								gen politic_aff = .
								replace politic_aff = 1 if political_aff_str=="Strong Democrat"
								replace politic_aff = 2 if political_aff_str=="Lean Democrat"
								replace politic_aff = 3 if political_aff_str=="Independent"
								replace politic_aff = 4 if political_aff_str=="Lean Republican"
								replace politic_aff = 5 if political_aff_str=="Strong Republican"
								replace politic_aff = 6 if political_aff_str=="No political affiliation"
								replace politic_aff = 7 if political_aff_str=="Prefer not to say"
								label define politicallbl 1 "Strong Democrat" 2 "Lean Democrat" 3 "Independent" 4 "Lean Republican" 5 "Strong Republican" 6 "No political affiliation" 7 "Prefer not to say", replace
								label values politic_aff politicallbl
								label var politic_aff "Political affiliation"

								label variable hhsize "Household size"

								gen race_white   = strpos(race, "White/Caucasian") > 0
								gen race_asian   = strpos(race, "Asian") > 0
								gen race_black   = strpos(race, "Black/African") > 0
								gen race_hisp    = strpos(race, "Hispanic/Latinx") > 0
								gen race_native  = strpos(race, "Native American") > 0
								gen race_pacific = strpos(race, "Pacific Islander") > 0
								gen race_other   = strpos(race, "Other") > 0
								gen race_pna     = strpos(race, "Prefer not to answer") > 0
								label define racedummy 0 "No" 1 "Yes", replace
								foreach v in race_white race_asian race_black race_hisp race_native race_pacific race_other race_pna {
									label values `v' racedummy
									}
								label var race        "Race"
								label var race_white  "Race: White/Caucasian"
								label var race_asian  "Race: Asian"
								label var race_black  "Race: Black/African"
								label var race_hisp   "Race: Hispanic/Latinx"
								label var race_native "Race: Native American"
								label var race_pacific "Race: Pacific Islander"
								label var race_other  "Race: Other"
								label var race_pna    "Race: Prefer not to answer"

								
							* Attitudes towards redistribution *


								label variable bonus_1 "Donation to help low-income families (e.g., Feeding America)"
								label variable bonus_2 "Donation to imporve public services (e.g., DonorsChoose)"
								label variable bonus_3 "Donation to support economic growth (e.g., Kiva)"
								label variable bonus_4 "Keep the money (as a personal bonus via Prolific)"

								label define redislbl ///
									0  "0 - Not at all supportive" ///
									1  "1" ///
									2  "2" ///
									3  "3" ///
									4  "4" ///
									5  "5" ///
									6  "6" ///
									7  "7" ///
									8  "8" ///
									9  "9" ///
									10 "10 - Completely supportive", replace

								local itemlbl_1 "Increase income taxes on the highest earners in the United States"
								local itemlbl_2 "Introduce a Universal Basic Income (UBI) in the United States"
								local itemlbl_3 "Do more to reduce income inequality"

								forvalues j = 1/3 {
									local v redis_tax_`j'

									clonevar `v'_str = `v'
									drop `v'
									gen `v' = .

									replace `v' = 0  if `v'_str=="0 - Not at all supportive"
									replace `v' = 1  if `v'_str=="1"
									replace `v' = 2  if `v'_str=="2"
									replace `v' = 3  if `v'_str=="3"
									replace `v' = 4  if `v'_str=="4"
									replace `v' = 5  if `v'_str=="5"
									replace `v' = 6  if `v'_str=="6"
									replace `v' = 7  if `v'_str=="7"
									replace `v' = 8  if `v'_str=="8"
									replace `v' = 9  if `v'_str=="9"
									replace `v' = 10 if `v'_str=="10 - Completely supportive"
									replace `v' = . if trim(lower(`v'_str))=="don't know/prefer not to answer" ///
													  | trim(lower(`v'_str))=="dont know/prefer not to answer"

									label values `v' redislbl
									label variable redis_tax_1 "To what extent do you support the introduction of a universal basic income (UBI) in the United States?"
									label variable redis_tax_2 "To what extent do you support increasing taxes on high earners?"
									label variable redis_tax_3 "To what extent do you support doing more to reduce income inequality?"
									}

					* Survey-specific cleaning *

						if study==1 {
							clonevar life_ladder_str = life_ladder
							drop life_ladder
							gen life_ladder = .
							replace life_ladder = 0 if life_ladder_str=="0 - Not at all satisfied"
							replace life_ladder = 1 if life_ladder_str=="1"
							replace life_ladder = 2 if life_ladder_str=="2"
							replace life_ladder = 3 if life_ladder_str=="3"
							replace life_ladder = 4 if life_ladder_str=="4"
							replace life_ladder = 5 if life_ladder_str=="5"
							replace life_ladder = 6 if life_ladder_str=="6"
							replace life_ladder = 7 if life_ladder_str=="7"
							replace life_ladder = 8 if life_ladder_str=="8"
							replace life_ladder = 9 if life_ladder_str=="9"
							replace life_ladder = 10 if life_ladder_str=="10 - Completely satisfied"
							label define lifeladderlbl ///
								0 "0 - Not at all satisfied" ///
								1 "1" ///
								2 "2" ///
								3 "3" ///
								4 "4" ///
								5 "5" ///
								6 "6" ///
								7 "7" ///
								8 "8" ///
								9 "9" ///
								10 "10 - Completely satisfied", replace
							label values life_ladder lifeladderlbl
							label var life_ladder "Life satisfaction"   
							}


						if inlist(study,2,3) {
							clonevar life_ladder_str = life_ladder_pre
							drop life_ladder_pre
							gen life_ladder = .
							replace life_ladder = 0 if life_ladder_str=="0 - Not at all satisfied"
							replace life_ladder = 1 if life_ladder_str=="1"
							replace life_ladder = 2 if life_ladder_str=="2"
							replace life_ladder = 3 if life_ladder_str=="3"
							replace life_ladder = 4 if life_ladder_str=="4"
							replace life_ladder = 5 if life_ladder_str=="5"
							replace life_ladder = 6 if life_ladder_str=="6"
							replace life_ladder = 7 if life_ladder_str=="7"
							replace life_ladder = 8 if life_ladder_str=="8"
							replace life_ladder = 9 if life_ladder_str=="9"
							replace life_ladder = 10 if life_ladder_str=="10 - Completely satisfied"
							label define lifeladderlbl_pre ///
								0 "0 - Not at all satisfied" ///
								1 "1" ///
								2 "2" ///
								3 "3" ///
								4 "4" ///
								5 "5" ///
								6 "6" ///
								7 "7" ///
								8 "8" ///
								9 "9" ///
								10 "10 - Completely satisfied", replace
							label values life_ladder lifeladderlbl_pre
							label var life_ladder "Life satisfaction"

							clonevar life_ladder_post_str = life_ladder_post
							drop life_ladder_post
							gen life_ladder_post = .
							replace life_ladder_post = 0 if life_ladder_post_str=="0 - Not at all satisfied"
							replace life_ladder_post = 1 if life_ladder_post_str=="1"
							replace life_ladder_post = 2 if life_ladder_post_str=="2"
							replace life_ladder_post = 3 if life_ladder_post_str=="3"
							replace life_ladder_post = 4 if life_ladder_post_str=="4"
							replace life_ladder_post = 5 if life_ladder_post_str=="5"
							replace life_ladder_post = 6 if life_ladder_post_str=="6"
							replace life_ladder_post = 7 if life_ladder_post_str=="7"
							replace life_ladder_post = 8 if life_ladder_post_str=="8"
							replace life_ladder_post = 9 if life_ladder_post_str=="9"
							replace life_ladder_post = 10 if life_ladder_post_str=="10 - Completely satisfied"
							label define lifeladderlbl_post ///
								0 "0 - Not at all satisfied" ///
								1 "1" ///
								2 "2" ///
								3 "3" ///
								4 "4" ///
								5 "5" ///
								6 "6" ///
								7 "7" ///
								8 "8" ///
								9 "9" ///
								10 "10 - Completely satisfied", replace
							label values life_ladder_post lifeladderlbl_post
							label var life_ladder_post "Life satisfaction (post-treatment)"
														
							clonevar treatment_str = treatment
							drop treatment
							gen treatment = .
							replace treatment = 1 if trim(treatment_str)=="Normcorrection-average"
							replace treatment = 2 if trim(treatment_str)=="Normcorrection-control_a"
							replace treatment = 3 if trim(treatment_str)=="Normcorrection-control_p"
							replace treatment = 4 if trim(treatment_str)=="Normcorrection-lowincome"
							label define treatmentlbl ///
								1 "Normcorrection-average" ///
								2 "Normcorrection-control_a" ///
								3 "Normcorrection-control_p" ///
								4 "Normcorrection-lowincome", replace
							label values treatment treatmentlbl
							label var treatment "Treatment arm"

							gen tr_avg    = treatment==1
							gen tr_ctrl_a = treatment==2
							gen tr_ctrl_p = treatment==3
							gen tr_lowinc = treatment==4
							label define yesno 0 "No" 1 "Yes", replace
							label values tr_avg tr_ctrl_a tr_ctrl_p tr_lowinc yesno
							label var tr_avg    "Arm: Normcorrection-average"
							label var tr_ctrl_a "Arm: Normcorrection-control_a"
							label var tr_ctrl_p "Arm: Normcorrection-control_p"
							label var tr_lowinc "Arm: Normcorrection-lowincome"	
							}


						if inlist(study,1,2) {
							label variable personal_threshold "How much pre-tax household income per month would make you feel highly satisfied with life (8–10 on 0–10 scale)?"
							label variable others_average "In your best guess, how much pre-tax income per month do you think the average American believe is needed?"
							label variable similar_average "In your best guess, how much pre-tax income per month do you think people like you believe is needed?"
							label variable poor_focused "In your best guess, how much pre-tax income per month do you think low-income families believe is needed?"

							clonevar confidence_str = confidence
							drop confidence
							gen confidence = .
							replace confidence = 1 if confidence_str=="Not at all confident"
							replace confidence = 2 if confidence_str=="Slightly confident"
							replace confidence = 3 if confidence_str=="Moderately confident"
							replace confidence = 4 if confidence_str=="Very confident"
							replace confidence = 5 if confidence_str=="Extremely confident"
							label define conflbl 1 "Not at all confident" 2 "Slightly confident" 3 "Moderately confident" 4 "Very confident" 5 "Extremely confident", replace
							label values confidence conflbl
							label var confidence "Confidence"

							clonevar otherbelief_do_str = othersbelief_do
							split otherbelief_do_str, parse("|") gen(orderpart)
							gen others_average_order = .
							gen similar_average_order = .
							gen poor_focused_order = .
							forvalues j = 1/3 {
								replace others_average_order  = `j' if strpos(orderpart`j', "others_average")>0
								replace similar_average_order = `j' if strpos(orderpart`j', "similar_average")>0
								replace poor_focused_order    = `j' if strpos(orderpart`j', "poor_focused")>0
								}
							label var others_average_order  "Order of others_average (1–3)"
							label var similar_average_order "Order of similar_average (1–3)"
							label var poor_focused_order    "Order of poor_focused (1–3)"

							drop orderpart* othersbelief_do
							}

						if study==3 {
							rename *_pre *
							rename othersbeliefpre_do othersbelief_do
							rename personal_thresh personal_threshold

							label variable personal_threshold "How much pre-tax household income per month would make you feel highly satisfied with life (8–10 on 0–10 scale)?"
							label variable others_average "In your best guess, how much pre-tax income per month do you think the average American believe is needed?"
							label variable similar_average "In your best guess, how much pre-tax income per month do you think people like you believe is needed?"
							label variable poor_focused "In your best guess, how much pre-tax income per month do you think low-income families believe is needed?"

							clonevar confidence_str = confidence
							drop confidence
							gen confidence = .
							replace confidence = 1 if confidence_str=="Not at all confident"
							replace confidence = 2 if confidence_str=="Slightly confident"
							replace confidence = 3 if confidence_str=="Moderately confident"
							replace confidence = 4 if confidence_str=="Very confident"
							replace confidence = 5 if confidence_str=="Extremely confident"
							label define conflbl 1 "Not at all confident" 2 "Slightly confident" 3 "Moderately confident" 4 "Very confident" 5 "Extremely confident", replace
							label values confidence conflbl
							label var confidence "How confident are you in your estimate of what others believe?"

							clonevar othersbeliefpost_do_str = othersbeliefpost_do
							split othersbeliefpost_do_str, parse("|") gen(orderpart)
							gen similar_average_pos_order = .
							gen others_average_post_order  = .
							gen poor_focus_post_order  = .
							forvalues j = 1/3 {
								replace similar_average_pos_order = `j' if strpos(orderpart`j', "similar_average_pos")>0
								replace others_average_post_order  = `j' if strpos(orderpart`j', "others_average_post")>0
								replace poor_focus_post_order  = `j' if strpos(orderpart`j', "poor_focus_post")>0
								}
							label var similar_average_pos_order "Order of similar_average_order_pos (1–3)"
							label var others_average_post_order  "Order of others_average_order_post (1–3)"
							label var poor_focus_post_order  "Order of poor_focus_order_post (1–3)"
							drop orderpart* othersbeliefpost_do

							clonevar otherbelief_do_str = othersbelief_do
							split otherbelief_do_str, parse("|") gen(orderpart)
							gen others_average_order = .
							gen similar_average_order = .
							gen poor_focused_order = .
							forvalues j = 1/3 {
								replace others_average_order  = `j' if strpos(orderpart`j', "others_average_pre")>0
								replace similar_average_order = `j' if strpos(orderpart`j', "similar_average_pre")>0
								replace poor_focused_order    = `j' if strpos(orderpart`j', "poor_focused_pre")>0
								}
							label var others_average_order  "Order of others_average (1–3)"
							label var similar_average_order "Order of similar_average (1–3)"
							label var poor_focused_order    "Order of poor_focused (1–3)"

							drop orderpart* othersbelief_do

							foreach v in ncorrect_a_believe  ncorrect_p_believe {					
								clonevar `v'_str = `v'
								drop `v'
								gen `v' = .
								replace `v' = 1 if `v'_str=="Extremely unbelievable"
								replace `v' = 2 if `v'_str=="Somewhat unbelievable"
								replace `v' = 3 if `v'_str=="Neither believable nor unbelievable"
								replace `v' = 4 if `v'_str=="Somewhat believable"
								replace `v' = 5 if `v'_str=="Extremely believable"		
								label define believabilitylbl /// 
								1 "Extremely unbelievable" /// 
								2 "Somewhat unbelievable" /// 
								3 "Neither believable nor unbelievable" /// 
								4 "Somewhat believable" /// 
								5 "Extremely believable", replace
								label values `v' believabilitylbl
								label var `v' "How believable did you find the information shown to you earlier?"
								}

							foreach v in ncorrect_p_similar ncorrect_a_similar {
								clonevar `v'_str = `v'
								drop `v'
								gen `v' = .
								replace `v' = 1 if `v'_str=="Not at all relevant"
								replace `v' = 2 if `v'_str=="Slightly relevant"
								replace `v' = 3 if `v'_str=="Moderately relevant"
								replace `v' = 4 if `v'_str=="Very relevant"
								replace `v' = 5 if `v'_str=="Extremely relevant"
								label define relevancelbl /// 
								1 "Not at all relevant" /// 
								2 "Slightly relevant" /// 
								3 "Moderately relevant" /// 
								4 "Very relevant" /// 
								5 "Extremely relevant", replace
								label values `v' relevancelbl
								label var `v' "How relevant did you find the information shown to you earlier?"
								}

							label define agree7 ///
							1 "Strongly disagree" ///
							2 "Disagree" ///
							3 "Somewhat disagree" ///
							4 "Neither agree nor disagree" ///
							5 "Somewhat agree" ///
							6 "Agree" ///
							7 "Strongly agree", replace
							forvalues j = 1/3 {
								local v deservingness_`j'
								clonevar `v'_str = `v'
								drop `v'
								gen `v' = .
								replace `v' = 1 if `v'_str=="Strongly disagree"
								replace `v' = 2 if `v'_str=="Disagree"
								replace `v' = 3 if `v'_str=="Somewhat disagree"
								replace `v' = 4 if `v'_str=="Neither agree nor disagree"
								replace `v' = 5 if `v'_str=="Somewhat agree"
								replace `v' = 6 if `v'_str=="Agree"
								replace `v' = 7 if `v'_str=="Strongly agree"
								label values `v' agree7
								}
							label var deservingness_1 "People who are poor in the United States generally deserve help from the government"
							label var deservingness_2 "Most people who are poor in the United States are poor because of bad luck, not because of a lack of effort"
							label var deservingness_3 "Government assistance should only go to people who are trying to improve their situation"

							clonevar confidence_str2 = confidence_post
							drop confidence_post
							gen confidence_post = .
							replace confidence_post = 1 if confidence_str2=="Not at all confident"
							replace confidence_post = 2 if confidence_str2=="Slightly confident"
							replace confidence_post = 3 if confidence_str2=="Moderately confident"
							replace confidence_post = 4 if confidence_str2=="Very confident"
							replace confidence_post = 5 if confidence_str2=="Extremely confident"
							label define conflbl 1 "Not at all confident" 2 "Slightly confident" 3 "Moderately confident" 4 "Very confident" 5 "Extremely confident", replace
							label values confidence_post conflbl
							label var confidence "How confident are you in your estimate of what others believe?"
							drop confidence_str2

							clonevar comprehensioncheck_str = comprehensioncheck
							drop comprehensioncheck
							gen comprehensioncheck = .

							replace comprehensioncheck = 1 if comprehensioncheck_str == "In fact, we found that 86% of the people we surveyed underestimated the amount of income people from low-income families actually need to feel highly satisfied with their lives."
							replace comprehensioncheck = 2 if comprehensioncheck_str == "In fact, we found that 85% of the people we surveyed underestimated the amount of income other Americans actually need to feel highly satisfied with their lives."
							replace comprehensioncheck = 3 if comprehensioncheck_str == "In fact, we found that 86% of the people we surveyed overestimated the amount of income people from low-income families actually need to feel highly satisfied with their lives."
							replace comprehensioncheck = 4 if comprehensioncheck_str == "In fact, we found that 85% of the people we surveyed overestimated the amount of income other Americans actually need to feel highly satisfied with their lives."
							replace comprehensioncheck = 5 if comprehensioncheck_str == "None of the above"

							label define compchecklbl ///
								1 "86% underestimated (low-income families)" ///
								2 "85% underestimated (other Americans)" ///
								3 "86% overestimated (low-income families)" ///
								4 "85% overestimated (other Americans)" ///
								5 "None of the above", replace

							label values comprehensioncheck compchecklbl
							label var comprehensioncheck "Comprehension check: which message did you see previously?"
							}

				drop *_str progress
				save "$data_path_final\Study`i'_clean.dta", replace
				*erase "$data_path_final\Study`i'_raw.dta"
				}

		*********************************************************
		*		3. Creating final dataset for analysis			*
		*********************************************************

			** Appending the three clean surveys **
			
				clear
				forvalues i=1(1)3 {
					append using "$data_path_final\Study`i'_clean.dta", force
					*erase "$data_path_final\Study`i'_clean.dta"
					}
				save "$data_path_final\Final_temp.dta", replace

				
			** Work on the final .dta **	

				use "$data_path_final\Final_temp.dta", clear

				* Some extra cleaning and tidying up *
				
					* Study ID *
					
						label define studylbl ///
							1 "Study 1 - Baseline" ///
							2 "Study 2 - Norm-correction treatment" ///
							3 "Study 3 - Norm-correction treatment with checks", replace
						label values study studylbl
						label var study "Study ID"

					* Gender ==> binary and 'other' (dimensionality-reduction) *

						gen gender_dv=gender
						recode gender_dv (4=3) (5=3)
						label define genderlbl2 1 "Male" 2 "Female" 3 "Other", replace
						label values gender_dv genderlbl2
						label variable gender_dv "Gender"
						
						tab gender_dv, gen(gen_d_)

					* Marital Status ==> Partnered (dimensionality-reduction) *
						
						gen partnered_dv = marital_status
						recode partnered_dv (1=0) (4=0) (5=0) (6=0) (7=0) (2=1) (3=1)
						label define maritallbl2 1 "Yes" 0 "No", replace
						label values partnered_dv maritallbl2
						label variable partnered_dv "Partnered"
						
					* From income bands to log eq Y (dimensionality-reduction + eq scale: sqrt fam size) *
						
						gen income_mid = .
						replace income_mid = 500    if income == 1   // Less than $1,000/month
						replace income_mid = 1333   if income == 2   // $1,000–$1,666
						replace income_mid = 2083   if income == 3   // $1,667–$2,499
						replace income_mid = 2916   if income == 4   // $2,500–$3,333
						replace income_mid = 3750   if income == 5   // $3,334–$4,166
						replace income_mid = 4583   if income == 6   // $4,167–$4,999
						replace income_mid = 5416   if income == 7   // $5,000–$5,833
						replace income_mid = 6250   if income == 8   // $5,834–$6,666
						replace income_mid = 7083   if income == 9   // $6,667–$7,499
						replace income_mid = 7916   if income == 10  // $7,500–$8,333
						replace income_mid = 10416  if income == 11  // $8,334–$12,499
						replace income_mid = 12500  if income == 12  // $12,500 or more (conservative lower bound)
						replace income_mid = . if income == 13
						label var income_mid "Monthly household income midpoint"
						
						gen eq_inc=income_mid/sqrt(hhsize)
						gen log_eq_inc=log(income_mid/sqrt(hhsize))
						label var log_eq_inc "Eq. HH Income"
						
						gen income_missing=(income==13)
						
						foreach v in eq_inc log_eq_inc {
						    su `v'
							replace `v'=r(mean) if income_missing==1
							}

					* Political affiliation ==> Dem, Rep, Other (dimensionality-reduction) *

						gen pol_aff_dv = politic_aff
						recode pol_aff_dv (1=1) (2=1) (4=2) (5=2) (3=3) (6=3) (7=3)
						label define politicallbl2 1 "Democrat" 2 "Republican" 3 "Other", replace
						label values pol_aff_dv politicallbl2
						label var pol_aff_dv "Political affiliation"
						
						tab pol_aff_dv, gen(pol_d_)
						
					* Education ==> Post-sec educ (dimensionality-reduction) *
					
						gen postsec_dv = education
						recode postsec_dv (1=0) (2=0) (3=1) (4=1) (5=1) (6=1) (7=0) (8=0)
						label define educationlbl2 1 "Yes" 0 "No", replace
						label values postsec_dv educationlbl2
						label var postsec_dv "Post-Secondary Education"
							
					* Average min monthly gross HH Y to be happy according to baseline respondents: $13592.22 *

						su personal_threshold if study==1
						gen mean_own=r(mean)
						label var mean_own "Average personal amount necessary (Baseline)"

					* Average min monthly gross HH Y to be happy according to baseline poor: $8832.47 *
					
						su personal_threshold if income<=3 & study==1
						gen mean_poor=r(mean)
						label var mean_poor "Average amount necessary coming from the poor themselves (Baseline)"

					* Average min monthly gross HH Y for average Americans to be happy according to baseline respondents: $11959.13 *

						su others_average if study==1
						gen mean_others=r(mean)
						label var mean_others "Average amount necessary for average American (Baseline)"

					* Average min monthly gross HH Y for similar respondents to be happy according to baseline respondents: $12347.86 *
						
						gen mean_similar=.
						forvalues i=1(1)13 {
						su similar_average if study==1 & income==`i'
						replace mean_similar=r(mean) if income==`i'
						}
						label var mean_similar "Average amount necessary for similar people (Baseline)"

					* Self-other belief gaps *

						gen gap_avg=others_average-personal_threshold
						label var gap_avg "Difference between own beliefs about myself and average"
						gen gap_low=poor_focused-personal_threshold
						label var gap_low "Difference between own beliefs about myself and poor"
						gen gap_like=similar_average-personal_threshold
						label var gap_like "Difference between own beliefs about myself and similar"

					* Measure of pluralistic ignorance *
					
						* Gap *
						
							gen norm_gap_avg = others_average-mean_own
							label var norm_gap_avg "Plura ignorance: Own belief about avg minus actual needed"
							gen norm_gap_low = poor_focused-mean_poor
							label var norm_gap_low "Plura ignorance: Own belief about poor minus actual poor needed"
							gen norm_gap_sim = similar_average-mean_own
							label var norm_gap_sim "Plura ignorance: Own belief about similar minus actual needed"

						* Share *
						
							gen norm_gap_avg_v3 = others_average/mean_own
							label var norm_gap_avg_v3 "Plura ignorance: Own belief about avg over actual needed"						
							gen norm_gap_sim_v3 = similar_average/mean_similar
							label var norm_gap_sim_v3 "Plura ignorance: Own belief about similar over actual needed"						
							gen norm_gap_low_v3 = poor_focused/mean_poor
							label var norm_gap_low_v3 "Plura ignorance: Own belief about poor over poor actual needed"
						
							egen gap_band = cut(norm_gap_avg_v3), at(0 0.5 0.75 0.999999 1.000001 2 10) icodes

							label define gapbandlbl ///
								0 "<50%" ///
								1 "50–75%" ///
								2 "75–100%" ///
								3 "Exactly 100%" ///
								4 "100–200%" ///
								5 ">200%", replace
							label values gap_band gapbandlbl
							label var gap_band "Pluralistic ignorance gap (Belief÷Actual)"

								  
							egen gap_low_band = cut(norm_gap_low_v3), at(0 0.5 0.75 0.999999 1.000001 2 10) icodes

							label define gapbandlbl ///
								0 "<50%" ///
								1 "50–75%" ///
								2 "75–100%" ///
								3 "Exactly 100%" ///
								4 "100–200%" ///
								5 ">200%", replace
							label values gap_low_band gapbandlbl
							label var gap_low_band "Pluralistic ignorance gap vs low-income (Belief÷Actual)"						
						
					* Log *
					
						foreach v in personal_threshold others_average similar_average poor_focused {
							gen log_`v'=log(`v')
							}
					

							  
						
						label define gapcatlbl -1 "Other < Personal" 0 "Other = Personal" 1 "Other > Personal", replace
						foreach v in gap_avg gap_like gap_low {
							gen `v'_cat = .
							replace `v'_cat = -1 if `v' < 0
							replace `v'_cat =  0 if `v' == 0
							replace `v'_cat =  1 if `v' > 0
							label values `v'_cat gapcatlbl
							label var `v'_cat "Gap category (`v')"
							}						
						
							foreach v in a_believe a_similar p_believe p_similar {
								gen `v' = ncorrect_`v'
								replace `v' = 0 if ncorrect_`v'==. & study==3
								gen `v'_d= 2 if inrange(`v',4,5) & !mi(`v')
								replace `v'_d= 1 if inrange(`v',1,3) & !mi(`v')
								replace `v'_d= 0 if `v'==0 & !mi(`v')	
								}

						egen joint_react=group(a_believe_d a_similar_d p_believe_d p_similar_d)
						recode joint_react (4=3) (8=7)	
								
					* Updating of beliefs, LS and political attitudes *
					
						rename similar_average_pos similar_average_post
						rename poor_focus_post poor_focused_post
						foreach var in life_ladder income_thresh others_average poor_focused similar_average  {
							gen delta_`var'=(`var'_post-`var')
							}
							
					* Redistribution Index *
					
						factor redis_tax_1 redis_tax_2 redis_tax_3 if study==1, pcf
						rotate, varimax
						predict redist_index

					* Money given *
					
						gen money_given=(10-bonus_4)/10
						
					* Absolute normative gaps *
					
							gen abs_norm_gap_avg = abs(others_average-mean_own)
							label var abs_norm_gap_avg "Plura ignorance: Own belief about avg minus actual needed"
							gen abs_norm_gap_low = abs(poor_focused-mean_poor)
							label var abs_norm_gap_low "Plura ignorance: Own belief about poor minus actual poor needed"
							gen abs_norm_gap_sim = abs(similar_average-mean_similar)
							label var abs_norm_gap_sim "Plura ignorance: Own belief about similar minus actual needed"
							
					* Absolute normative gaps *
					
							gen abs_norm_gap_avg_post = abs(others_average_post-mean_own)
							label var abs_norm_gap_avg "Plura ignorance: Own belief about avg minus actual needed"
							gen abs_norm_gap_low_post = abs(poor_focused_post-mean_poor)
							label var abs_norm_gap_low "Plura ignorance: Own belief about poor minus actual poor needed"
							gen abs_norm_gap_sim_post = abs(similar_average_post-mean_similar)
							label var abs_norm_gap_sim "Plura ignorance: Own belief about similar minus actual needed"		
							
							
					* Post normative gaps *
					
							gen norm_gap_avg_post = others_average_post-mean_own
							label var abs_norm_gap_avg "Plura ignorance: Own belief about avg minus actual needed"
							gen norm_gap_low_post = poor_focused_post-mean_poor
							label var abs_norm_gap_low "Plura ignorance: Own belief about poor minus actual poor needed"
							gen norm_gap_sim_post = similar_average_post-mean_similar
							label var abs_norm_gap_sim "Plura ignorance: Own belief about similar minus actual needed"									
							
							
							
					gen money=.
					replace money=1 if money_given==0
					replace money=2 if inrange(money_given,0.00001,2.5)
					replace money=3 if inrange(money_given,2.5001,4.9999)
					replace money=4 if money_given==5
					replace money=5 if inrange(money_given,5.0001,7.4999)
					replace money=6 if inrange(money_given,7.5,9.9999)
					replace money=7 if money_given==10
					
					label define moneylbl ///
						1 "$0" ///
						2 "$0 < x ≤ $2.50" ///
						3 "$2.50 < x < $5" ///
						4 "$5" ///
						5 "$5 < x < $7.50" ///
						6 "$7.50 ≤ x < $10" ///
						7 "$10" ///

					label values money moneylbl							
							
					* Additional variables *
						
						foreach var in eq_inc personal_threshold others_average similar_average poor_focused gap_avg gap_like gap_low norm_gap_avg norm_gap_sim norm_gap_low abs_norm_gap_avg abs_norm_gap_low abs_norm_gap_sim {
							gen `var'3=`var'/1000
							ihstrans `var'
							}							
							
gen treat_coll=treatment
recode treat_coll (1=1) (2=0) (3=0) (4=1)								
							
							
			** Ordering the final version of the .dta **	
						
				drop q_relevantidduplicate q_duplicaterespondent q_relevantidduplicatescore q_relevantidfraudscore q_relevantidlaststartdate consentform q15 prolific_pid status ipaddress distributionchannel userlanguage finished recordeddate responseid recipientlastname recipientfirstname recipientemail externalreference
							
				global original study pid age gender gender_dv residence citizen marital_status partnered_dv income income_mid eq_inc log_eq_inc income_missing education postsec_dv race race_white race_asian race_black race_hisp race_native race_pacific race_other race_pna politic_aff pol_aff_dv hhsize life_ladder personal_threshold others_average similar_average poor_focused confidence treatment tr_avg tr_ctrl_a tr_ctrl_p tr_lowinc ncorrect_a_believe ncorrect_a_similar ncorrect_p_believe ncorrect_p_similar life_ladder_post redis_tax_1 redis_tax_2 redis_tax_3 bonus_1 bonus_2 bonus_3 bonus_4 deservingness_1 deservingness_2 deservingness_3 income_thresh_post others_average_post similar_average_post poor_focus_post confidence_post comprehensioncheck
				global derived mean_own mean_poor mean_others mean_similar gap_avg gap_low gap_like norm_gap_avg norm_gap_low norm_gap_sim delta_*
				global metadata startdate enddate durationinseconds locationlatitude locationlongitude

				order $original $derived $metadata

			** Ordering the final version of the .dta **
			
				save "$data_path_final\Final.dta", replace
				
				local data Final_temp Study1_raw Study2_raw Study3_raw Study1_clean Study2_clean Study3_clean
				
				foreach var of local data {
				erase "$data_path_final\\`var'.dta"
				}