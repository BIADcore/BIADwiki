#------------------------------------------------------------------
# Runs all R scripts beginning with 'auto.make.'
#------------------------------------------------------------------
library(BIADconnect)
source('../../BIADadmin/R/functions.R')
run.scripts.in.this.folder(pattern='auto.make')
#------------------------------------------------------------------
