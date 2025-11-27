#--------------------------------------------------------------------------------------
# Move this example to biadwiki.org and delete file
#--------------------------------------------------------------------------------------
require(BIADconnect)
conn  <-  init.conn()
#--------------------------------------------------------------------------------------
# get all C14 dates associated with bell beakersql.command <- "SELECT *
FROM C14Samples
INNER JOIN `Phases` ON `C14Samples`.`PhaseID` = `Phases`.`PhaseID`
WHERE `Phases`.`Culture1` = 'Bell Beaker'"
x <- query.database(sql.command)
head(x)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------