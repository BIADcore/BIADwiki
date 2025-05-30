#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# Example R script to test if R connection to BIAD is working
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# Requirements first read:
# https://biadwiki.org/en/connectR
# 1. ensure you have opened a tunnel first (e.g. putty)
# 2. ensure you have installed BIADconnect
#--------------------------------------------------------------------------------------
if(!'BIADconnect'%in%installed.packages())devtools::install_github("BIADwiki/BIADconnect")
require(BIADconnect)
conn  <-  init.conn()
#--------------------------------------------------------------------------------------
query <- query.database("SELECT * FROM `Sites`", conn=conn)
plot(table(query$Country),las=2)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
