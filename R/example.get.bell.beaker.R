#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# get all C14 dates associated with bell beaker
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
sql.command <- "SELECT *
FROM C14Samples
INNER JOIN `Phases` ON `C14Samples`.`PhaseID` = `Phases`.`PhaseID`
WHERE `Phases`.`Culture1` = 'Bell Beaker'"
x <- query.database(sql.command)
head(x)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------