
	**************************************************************************
	**																		**
	**					  		WHAT OTHERS NEED							**
	**				 Authors: N. Powdthavee and A. Lepinteur				**
	**						Stata Version MP 19.0							**
	**						Date: December 2025								**
	**																		**
	**************************************************************************

		*************************
		*		1. Setup		*
		*************************

			*Uncomment if not yet installed. 
 			/*
			ssc install blindschemes
			ssc install estout
			ssc install coefplot
			*/		

		*****************************************
		*		2. Set globals and paths			*
		*****************************************

			** Setting user **
			
				if "`c(username)'"=="nattavudhpowdthavee" global path "/Users/nattavudhpowdthavee/Library/CloudStorage/Dropbox/Pluralistic ignorance project"
				if "`c(username)'"=="anthony.lepinteur"  global path "C:\Users\anthony.lepinteur\Dropbox\Pluralistic ignorance project\Replication package"

			** Paths **
			
				global data_path			"$path/Data"
				global data_path_study1 	"$path/Data/Study 1 - baseline"
				global data_path_study2 	"$path/Data/Study 2 - norm-correction"
				global data_path_study3 	"$path/Data/Study 3 - norm-correction with checks"
				global data_path_final 		"$path/Data/Processed data"

				global dopath 				"$path/Programs"
				global results 				"$path/Results" 

			** Set plot scheme **				

				set scheme plottig				
				
		*****************************************************
		*		3. Reproduce output of the paper			*
		*****************************************************
				
			do "$dopath/1. Cleaning.do" // Clean the raw studies, derive variables and prepare a clean .dta for analysis
			do "$dopath/2. Analysis pre-reg and exp.do" // Run the empirical tests and produce output reported in paper