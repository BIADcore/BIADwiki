#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# Determining the % of contribution towards data collection in BIAD
# Example: radiocarbon dates
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# https://biadwiki.org/en/connectR
# ensure you have installed BIADconnect
# devtools::install_github("BIADcore/BIADconnect")
#--------------------------------------------------------------------------------------
require(BIADconnect)
conn  <-  init.conn()
#--------------------------------------------------------------------------------------# query the requested dataset
sql.command <- "SELECT *
FROM C14Samples
INNER JOIN `Sites` ON `C14Samples`.`SiteID` = `Sites`.`SiteID`
INNER JOIN `Phases` ON `C14Samples`.`PhaseID` = `Phases`.`PhaseID`
WHERE `Phases`.`Culture1` IS NOT NULL AND `Sites`.`Country` = 'Sweden' OR `Phases`.`Culture1` IS NOT NULL AND `Sites`.`Country` = 'Denmark'"
query <- query.database(sql.command, conn=conn)

# generate a dataframe with the added and updated information
added <- data.frame(query$user_added, "added")
colnames(added)[1] = "author"
colnames(added)[2] = "type"
updated <- data.frame(query$user_last_update, "updated")
colnames(updated)[1] = "author"
colnames(updated)[2] = "type"
contribution <- rbind(added, updated)

# generate the proportions for each of the columns
prop.table(table(contribution$author)) # contribution by authors
prop.table(table(contribution)) # comparison of both values

# barplot code
counts <- table(contribution$type, contribution$author)
barplot(counts, col = c("darkblue","red"), legend = rownames(counts))
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------