///   Wallace_cohorthu_stata_data
///     Self-report versus electronic medical record recorded 
///     healthcare utilisation in older community-dwelling adults: 
///     comparison of two prospective cohort studies
///     https://github.com/frankmoriarty/cohorthu

clear
clear matrix
clear mata
set more off
set maxvar 10000

cd "/*Specify working directory where dataset file is*/"

import delimited "wallace_cohorthu_synth_data.csv", clear 

label data "Synthetic dataset for Wallace et al 2018 created using R/synthpop"

gen edvisit=hu007
recode edvisit 1/50=1

gen anygp=hu005
recode anygp 1/250=1

/*Private health insurance*/
label define insur 1 "Yes" 0 "No"
label values hipmt_1 insur
label variable hipmt_1 "Private health insurance status"
/*Age variable*/
recode agew1 70/74=0 75/79=1 80/115=2, gen(agenew)
label define agenew 0 "<=75" 1 "76-80" 2 ">80"
label values agenew agenew
label variable agew1 "Age at baseline in years"
label variable agenew "Age group at baseline in years"
/*Social class - indicates skilled (versus unknown, never worked, or unskilled*/
label define new_csoscn 1 "Unskilled" 2 "Skilled"
label values new_csoscn new_csoscn
label variable new_csoscn "Social class"
/*Gender*/
label define gender 1 "Male" 2 "Female"
label values gender gender
label variable gender "Gender"
/*Education binary - indicates secondary education or higher*/
label define edunew 1 "Basic education" 2 "Upper and post-secondary"
label values educcn edunew
label variable educcn "Highest level of educational attainment"
/*Living arrangements*/
label define lives 1 "Husband/wife/partner" 2 "Family/relatives" 3 "Lives alone" 4 "Other"
label values new_wlwn_1 lives
label variable new_wlwn_1 "Living arrangements"
/*Marital status*/
label define cmarsn_1 1 "Married" 2 "Separated/divorced" 3 "Widowed" 4 "Never married/single"
label values cmarsn_1 cmarsn_1
label variable cmarsn_1 "Marital status"

label variable hu005 "Number of GP visits in previous 12 months"
label variable hu007 "Number of ED visits in previous 12 months"
label variable hu008 "Number of OPD visits in previous 12 months"
label variable edvisit "Any ED visit in previous 12 months"
label variable anygp "Any GP visit in previous 12 months"
label define yesno 0 "No" 1 "Yes"
label values anygp yesno
label values edvisit yesno
label variable ndrugs_1 "Number of medications"

/*Number of medications*/
recode ndrugs_1 0/4=0 5/9=1 10/20=2, gen(ndrugs4_1)
label variable ndrugs4_1 "Number of medications (categorised)"
label define ndrugs4_1 0 "0-4 medications" 1 "5-9 medications" 2 "10 or more medications"
label values ndrugs4_1 ndrugs4_1

label variable tilda "Cohort status"
label define cohort 0 "CPCR cohort (EMR data)" 1 "TILDA cohort (self-report data)"
label values tilda cohort
/***********************SUMMARISING VARIABLES****************************/
forvalues k=0/1 {
sum agew1 if tilda==`k', d
sum ndrugs_1 if tilda==`k', d
/*Summarise covariates*/
foreach covar in agenew gender cmarsn_1 new_wlwn_1 educcn new_csoscn ndrugs4_1 hipmt_1 {
tab `covar' if tilda==`k', mis
}
/*Summarise healthcare utilisation*/
foreach var in hu005 hu007 hu008 {
sum `var' if tilda==`k', d
}
foreach var in hu005 hu007 hu008 anygp edvisit {
tab `var' if tilda==`k'
}
/*Summarise healthcare utilisation by covariates*/
foreach var in hu005 hu007 hu008 {
foreach covar in agenew gender cmarsn_1 new_wlwn_1 educcn new_csoscn  ndrugs4_1 hipmt_1 {
by `covar', sort: sum `var' if tilda==`k', d
}
}
foreach var in hu005 hu007 hu008 {
foreach covar in agenew gender cmarsn_1 new_wlwn_1 educcn new_csoscn  ndrugs4_1 hipmt_1 {
median `var' if tilda==`k', by(`covar') exact
}
}
foreach var in edvisit anygp {
foreach covar in agenew gender cmarsn_1 new_wlwn_1 educcn new_csoscn  ndrugs4_1 hipmt_1 {
tab `covar' `var' if tilda==`k', chi
}
}
}



/*Analysis by cohort*/
foreach var in hu005 hu007 hu008 {
foreach covar in agenew gender cmarsn_1 new_wlwn_1 educcn new_csoscn ndrugs4_1 hipmt_1 {
by tilda, sort: anova `var' `covar'
}
}
foreach var in hu005 hu007 hu008 {
foreach covar in  gender educcn new_csoscn  hipmt_1 {
by tilda, sort: ttest `var', by(`covar')
}
}
tab tilda anygp, r chi
tab tilda edvisit, r chi

/*Regression analysis by cohort*/
nbreg hu005 tilda , irr
nbreg hu007 tilda , irr
nbreg hu008 tilda , irr
logistic edvisit tilda 
logistic anygp tilda 
glm edvisit tilda , fam(poisson) link(log) nolog vce(robust) eform
glm anygp tilda , fam(poisson) link(log) nolog vce(robust) eform


nbreg hu005 tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, irr
nbreg hu007 tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, irr
nbreg hu008 tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, irr
logistic edvisit tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1
logistic anygp tilda 

glm edvisit tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, fam(poisson) link(log) nolog vce(robust) eform
glm anygp tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, fam(poisson) link(log) nolog vce(robust) eform

/*Interactions*/
nbreg hu008 c.agew1##tilda gender i.cmarsn_1 i.new_wlwn_1 educcn new_csoscn c.ndrugs_1 hipmt_1, irr
margins tilda, at(agew1=(70(5)90))

marginsplot, xlabel(70(5)90) title("") legend(order(1 "CPCR cohort" 2 "TILDA") region(lw(vvthin))) ytitle("Predicted number of OPD visits") xtitle("Baseline age (years)") ylabel(, angle(0)) xscale(titlegap(*+5)) graphregion(color(gs15)) bgcolor(ltbluishgray)
graph export "OPD age.tif", as(tif) width(2100) replace
nbreg hu005 tilda c.agew1 gender i.cmarsn_1 i.new_wlwn_1##tilda educcn new_csoscn c.ndrugs_1 hipmt_1##tilda, irr
margins i.new_wlwn_1#tilda
marginsplot, recast(scatter) title("") legend(order(1 "CPCR cohort" 2 "TILDA") region(lw(vvthin))) ytitle("Predicted number of GP visits") xtitle("Living arrangements") ylabel(, angle(0)) xscale(titlegap(*+5)) graphregion(color(gs15)) bgcolor(ltbluishgray)
graph export "GP living arrangements.tif", as(tif) width(2100) replace
margins hipmt_1#tilda
marginsplot, recast(scatter) title("") legend(order(1 "CPCR cohort" 2 "TILDA") region(lw(vvthin))) ytitle("Predicted number of GP visits") xtitle("Private health insurance") ylabel(, angle(0)) xtick(-1 0 0.5 1 2)  xscale(titlegap(*+5)) graphregion(color(gs15)) bgcolor(ltbluishgray)
graph export "GP health insurance.tif", as(tif) width(2100) replace
