# cohorthu

This repository provides analytical code and a simulated dataset relating to the following paper: 
"Wallace E, Moriarty F, McGarrigle C, Smith SM, Kenny RA, Fahey T. Self-report versus electronic medical record recorded healthcare utilisation in older community-dwelling adults: comparison of two prospective cohort studies"

This study longitudinally examines patient self-reported healthcare utilisation (GP, OPD, and ED visits) and GP electronic medical record (EMR) recorded healthcare utilisation in older community-dwelling people in Ireland. It includes data from two existing cohort studies - The Irish Longitudinal Study on Ageing (TILDA) and the HRB Centre for Primary Care Research (CPCR) cohort. The former uses self-report measures of healthcare utilisation and the latter uses manual extraction of healthcare utilisation from the GP EMR.

As TILDA had broader inclusion criteria compared to the CPCR cohort, a subsample of respondents from TILDA who would have been eligible for the CPCR cohort were included in this analysis. A total of 2,307 TILDA respondents were aged ≥70 years at baseline, 2,070 of whom (90%) were eligible for the GMS scheme. Those with a GP visit card were not included. At least one regular medication was reported by 1,808 of these respondents (87%). Follow-up at Wave 2 was completed by 1,377 (76%) of these respondents between February 2012 and January 2013, where a further interview was conducted (see Figure 1)

The following variables were considered in the analysis:
tilda "Cohort status" with values 0 "CPCR cohort (EMR data)" 1 "TILDA cohort (self-report data)"

gender "Gender" with values 1 "Male" and 2 "Female" 

educcn "Highest level of educational attainment" with values 1 "Basic education" 2 "Upper and post-secondary"

new_csoscn "Social class" with values 1 "Unskilled" 2 "Skilled"

new_wlwn_1 "Living arrangements" with values label define lives 1 "Husband/wife/partner" 2 "Family/relatives" 3 "Lives alone" 4 "Other"

cmarsn_1 "Marital status" with values 1 "Married" 2 "Separated/divorced" 3 "Widowed" 4 "Never married/single"

agew1 "Age at baseline in years"

hipmt_1 "Private health insurance status" with values 1 "Yes" 0 "No"

ndrugs_1 "Number of medications"

hu005 "Number of GP visits in previous 12 months"

hu007 "Number of ED visits in previous 12 months"

hu008 "Number of OPD visits in previous 12 months"

