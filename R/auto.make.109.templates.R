#-----------------------------------------------------------------------------------------
# Generates various .csv files as templates for each table, to be downloaded from the biadwiki.org.
# The csv files are stored as assets on biadwiki.org.
# Currently displaying these .csv using iframes, which is a dodgy hack for wiki.js
# It works, but if an editor changes the preferred edit mode from raw html to one of the the other options, these iframes are lost.
# A better solution is required, which is likely to come in time from wiki.js development
#-----------------------------------------------------------------------------------------
require(BIADconnect)
conn <- init.conn()
sql.command <- "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='BIAD'"
d <- query.database(sql.command = sql.command, conn=conn)
sql.command <- "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema='BIAD';"	
d.cols <- query.database(sql.command = sql.command, conn=conn)
#-----------------------------------------------------------------------------------------
all <- d$TABLE_NAME
zprivate <- all[grepl('zprivate', all)]
zoptions <- all[grepl('zoptions', all)]
copy <- all[grepl('_copy', all)]
standard <- all[!all%in%c(zprivate,zoptions,copy)]
lookup <- zoptions[!zoptions%in%copy]

standard <- subset(d, TABLE_NAME%in%standard)
standard <- subset(standard, TABLE_ROWS>10)
#-----------------------------------------------------------------------------------------
# folder for all csv files
folder <- '../tools/templates'
#-----------------------------------------------------------------------------------------
# create new templates
#-----------------------------------------------------------------------------------------
N <- nrow(standard)
for(n in 1:N){

	table <- standard$TABLE_NAME[n]
	d.table <- query.database(conn = conn, sql.command= paste("SELECT * FROM `",table,"`",sep=''))

	# a blank example
	example <- d.table[1,]
	example[1,] <- NA

	# populate iteratively with a mix of true entries
	for(iter in 1:5){
		i <- is.na(example[1,])
		rs <- rowSums(!is.na(d.table[,i,drop=FALSE]))
		w <- which(rs==max(rs, na.rm=T))[1]
		example[,i] <- d.table[w,i]
		}

	# replace NULL where required
	sub <- subset(d.cols, TABLE_NAME==table)
	i <- grepl('do not manually add value',tolower(sub$COLUMN_COMMENT))
	example[1,i] <- NA
	# ensure a BOM is included!
	write.csv.utf8.BOM(df = example, filename = paste(folder,'/',table,'.csv', sep=''))
	}
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
