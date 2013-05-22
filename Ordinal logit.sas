* Import Stata data;
proc import datafile="c:\ordwarm2" out=ordwarm dbms = dta replace;
run;

* Examine the data set;
proc contents data=ordwarm;
run;

proc logistic data=ordwarm descending;
model warm = yr89 male white age ed prst;
run;

proc logistic data=ordwarm;
model warm = yr89 male white age ed prst;
run;
