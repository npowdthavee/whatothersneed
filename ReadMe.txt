README – Replication Package

Title: What Others Need: Misperceptions of Well-being Norms and Support for Redistribution
Authors: Anthony Lepinteur and Nattavudh Powdthavee
Final do-file version: December 2025
Software: Stata 19.5 MP


***********************************
	Overview
***********************************
This replication package contains all the raw data, cleaning scripts, and analysis code needed to reproduce the results in the paper “What Others Need: Misperceptions of Well-being Norms and Support for Redistribution.”

The workflow is fully automated. Running the file "0. Master.do" will clean the raw datasets, generate the analysis files, and produce all tables and figures reported in the paper.

Total expected running time: approximately 10 minutes on Stata 19.5 MP.



***************************************************
	Running the Replication
***************************************************

1. Open Stata.

2 Set the working directory to the replication folder in "0. Master.do"
The master file performs the following steps:

Calls "1. Cleaning.do" to clean all raw data and generate the final analysis dataset.

Calls "2. Analysis Pre-reg and exp.do" to run all analyses and export all results.



**********************************************
	Script Descriptions
**********************************************

"1. Cleaning.do"

Loads each raw dataset.
Performs data cleaning, recoding, and construction of all variables.
Saves the final cleaned dataset.

"2. Analysis Pre-reg and exp.do"

Runs all pre-registered and exploratory analyses.
Produces every table and figure referenced in the paper.
Saves all results in the folder "output".



******************************************
	Data Availability
******************************************

All raw data files required to run the replication package are included. No external downloads are needed.



********************************
	Contact
********************************

For any questions about the replication materials, please contact anthony.lepinteur@uni.lu