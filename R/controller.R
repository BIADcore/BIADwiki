#------------------------------------------------------------------
# Runs all R scripts beginning with 'auto.make.'
#------------------------------------------------------------------
# install BIADconnect if required
if(!'BIADconnect'%in%installed.packages())install.packages("~/BIADconnect/", repos = NULL, type = "source")
require(BIADconnect)
source('../../BIADadmin/R/functions.R')
#------------------------------------------------------------------
conn  <-  init.conn()
cat(paste('BIAD check routine started on:\n',date(),'\n'))
cat(paste(' - BIAD size is of:',round(getSize(conn = conn)[1,2]*1000),'Mo\n'))
disconnect()

run.scripts.in.this.folder(pattern='auto.make')
#------------------------------------------------------------------
