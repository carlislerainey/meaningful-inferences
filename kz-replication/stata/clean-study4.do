use "/Users/kellymccaskey/Dropbox/Projects/meaningful-inferences/kz-replication/data/Study4.dta", clear

/*DV*/
gen jenkins1=.
replace jenkins1=mj1 if mj1!=.
replace jenkins1=mj2 if mj2!=.
replace jenkins1=mj3 if mj3!=.
replace jenkins1=mj4 if mj4!=.
replace jenkins1=mj5 if mj5!=.
replace jenkins1=mj6 if mj6!=.
replace jenkins1=mj7 if mj7!=.
tab jenkins1

gen griffin1=.
replace griffin1=bg1 if bg1!=.
replace griffin1=bg2 if bg2!=.
replace griffin1=bg3 if bg3!=.
replace griffin1=bg4 if bg4!=.
replace griffin1=bg5 if bg5!=.
replace griffin1=bg6 if bg6!=.
replace griffin1=bg7 if bg7!=.
tab griffin1

mvdecode jenkins1-griffin1, mv(-99)


/*ANALYSIS OF DATA*/
/*TREATMENT CONDITIONS*/
tab pickup
tab ppedir
drop if pickup~=1 /*eliminating bussers & walkers*/

gen treated = 0
replace treated = 1 if ppedir==2
tab treated

tab griffin1 treated, chi2 col /*RANKING, 0=FIRST, 1=SECOND, 2=THIRD*/

recode griffin1 (0 1 2 = 1)(else=0), gen(anygriffin)
recode jenkins1 (0 1 2 =1)(else=0), gen(anyjenkins)
tab anygriffin treated, chi2 col

outsheet anyjenkins anygriffin treated using kz.csv,comma

/*TABLE 3*/
prtest anygriffin, by(treated)
prtest anyjenkins, by(treated)

/*THIRD SET OF RESULTS*/
prtest anygriffin=anyjenkins if treated==1
prtest anygriffin=anyjenkins if treated==0


