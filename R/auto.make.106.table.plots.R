#-------------------------------------------------------------------------------
# Generate a bunch of examples of tables as images, for embedding in wiki
#-------------------------------------------------------------------------------
library(gridExtra)
library(svglite)
tables <- c('Citations','PhaseCitation','Phases','PhaseTypes','Sites','zoptions_Types')
conn <- init.conn()

theme <- ttheme_minimal(
	core = list(fg_params = list(hjust = 0, x = 0.1, fontsize = 18, col='blue')),
	colhead = list(fg_params = list(hjust = 0, x = 0.1, fontsize = 12, col='black'))
	)
#-------------------------------------------------------------------------------
for(table in tables){

	sql.command <- paste("SELECT * FROM BIAD.",table,sep='')
    d <- query.database(sql.command = sql.command, conn=conn)[1:5,]
	d[is.na(d)] <- '\\N'
	d$time_added <- '\\N'
	d$user_added <- '\\N'
	d$time_last_update <- '\\N'
	d$user_last_update <- '\\N'

	nc <- 25
	for(n in 1:ncol(d)){
		i <- nchar(d[,n])>nc
		d[i,n] <- paste(substr(d[i,n],1,nc),'...',sep='')
		}
	d <- d[,colSums(d=='\\N')<4]

	path <- paste('../tools/plots/',table,'.svg',sep='')
	svglite(path,width=36, height=3)
	grid.table(d, theme=theme,rows=rep('',5))
	dev.off()
	}
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
