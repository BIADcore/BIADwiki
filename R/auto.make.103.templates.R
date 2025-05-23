#-----------------------------------------------------------------------------------------
# Pull table summaries from the database, and update github
#-----------------------------------------------------------------------------------------
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
# delete all existing templates
#-----------------------------------------------------------------------------------------
unlink("../tools/templates/*")
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
	# need to somehow include a BOM
	write.csv(example, file=paste('../tools/templates/',table,'.csv',sep=''))
	}
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
