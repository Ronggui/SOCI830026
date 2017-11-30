* lowbirth2.dta
clogit low lwt smoke ptd ht ui i.race, group(pairid) nolog

clogit union age grade not_smsa south black, group(idcode)

xtset idcode
xtlogit union age grade not_smsa south black, fe

xtlogit union age grade not_smsa south black, re

