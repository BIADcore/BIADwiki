#-----------------------------------------------------------------
# Timeslice maps of various data sets
#-----------------------------------------------------------------
require(BIADconnect)
conn <- init.conn()
height <- 8
folder <- '../tools/plots'
prefix <- 'timeslice.map'
#-----------------------------------------------------------------
# common functions
#-----------------------------------------------------------------
common.plotter <- function(dd, tablename, file, height = 8){
	require(maps)
	require(svglite)
	xlim <- range(dd$Longitude)
	ylim <- range(dd$Latitude)
	width <- cos(mean(ylim)/180*(pi)) * height * diff(xlim)/diff(ylim)
	zposts <- choose.zposts(dd)
	N <- length(zposts)-1
	ncol <- 3
	nrow <- ceiling(N/ncol)
	svglite(file=file, width=width*2*ncol/nrow, height=2*height )
	par(mfrow=c(nrow,ncol), mar=c(1,1,1,1))
	for(n in 1:N){
		i <- dd$date<=zposts[n] & dd$date>zposts[n+1]
		data <- dd[i,]
		main <- paste0(n,': ',tablename,': ',zposts[n],' to ',zposts[n+1],' BP (',zposts[n]-zposts[n+1],' span)')
		plot(NULL,xlim=xlim,ylim=ylim,frame.plot=F,axes=F, xlab='',ylab='',main=main)
		map('world',xlim=xlim,ylim=ylim,col='grey90',add=T, fill=T, border='grey')
		points(data$Longitude, data$Latitude, col='steelblue', pch=16,cex=1)
		}
	dev.off()
	}

choose.zposts <- function(dd){
	ns <- 1 + floor(log(nrow(dd))*1.5)
	zposts <- round(rev(quantile(dd$date, prob=seq(0,1,length.out=ns+1))),-2)
	zposts <- unique(zposts)
return(zposts)}
#-----------------------------------------------------------------
# get chronology
#-----------------------------------------------------------------
sit <- query.database("SELECT * FROM `BIAD`.`Sites`", conn=conn)
pha <- query.database("SELECT * FROM `BIAD`.`Phases`", conn=conn)
d <- merge(pha,sit,by='SiteID')

d$reportedMidBP <- 1950 + (d$StartBCEreported + d$EndBCEreported)/2
d$date <- d$GMM
i <- !is.na(d$reportedMidBP)
d$date[i] <- d$reportedMidBP[i]

# remove those still with no chronology
d <- d[!is.na(d$date),]
#-----------------------------------------------------------------
# all phases
#-----------------------------------------------------------------
tablename='all'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=d, tablename=tablename, file=file)
#-----------------------------------------------------------------
# tables connected directly to phase
#-----------------------------------------------------------------
tables <- c('ABotIsotopes','ABotSamples','FaunalBiometrics','FaunalIsotopes','Graves','FaunalSpecies','MaterialCulture')
for(n in 1:length(tables)){
	tablename <- tables[n]
	tmp <- query.database(paste("SELECT * FROM `BIAD`.`",tablename,"`",sep=''), conn=conn)
	dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
	file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
	common.plotter(dd=dd, tablename=tablename, file=file)
	}
#-----------------------------------------------------------------
# More complicated relationships indirectly linked to Phases
#-----------------------------------------------------------------
t1 <- query.database("SELECT * FROM `BIAD`.`FaunalIsotopes`", conn=conn)
t2 <- query.database("SELECT * FROM `BIAD`.`FaunalIsotopeSequences`", conn=conn)
t2 <- subset(t2, !is.na(SampleID))
tmp <- merge(t2, t1, by='SampleID') 
dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
tablename <- 'FaunalIsotopeSequences'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=dd, tablename=tablename, file=file)
#--------------------------------------------------------------------------------------------------
t1 <- query.database("SELECT * FROM `BIAD`.`Graves`", conn=conn)
t2 <- query.database("SELECT * FROM `BIAD`.`GraveIndividuals`", conn=conn)
t2 <- subset(t2, !is.na(GraveID))
tmp <- merge(t2, t1, by='GraveID')
dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
tablename <- 'GraveIndividuals'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=dd, tablename=tablename, file=file)
#--------------------------------------------------------------------------------------------------
t1 <- query.database("SELECT * FROM `BIAD`.`Graves`", conn=conn)
t2 <- query.database("SELECT * FROM `BIAD`.`GraveIndividuals`", conn=conn)
t3 <- query.database("SELECT * FROM `BIAD`.`HumanIsotopes`", conn=conn)
tmp <- merge(t3, t2, by='IndividualID')
tmp <- merge(tmp, t1, by='GraveID')
dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
tablename <- 'HumanIsotopes'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=dd, tablename=tablename, file=file)
#--------------------------------------------------------------------------------------------------
t1 <- query.database("SELECT * FROM `BIAD`.`Graves`", conn=conn)
t2 <- query.database("SELECT * FROM `BIAD`.`GraveIndividuals`", conn=conn)
t3 <- query.database("SELECT * FROM `BIAD`.`Rites`", conn=conn)
tmp <- merge(t3, t2, by='IndividualID')
tmp <- merge(tmp, t1, by='GraveID')
dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
tablename <- 'Rites'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=dd, tablename=tablename, file=file)
#--------------------------------------------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`aDNAID`,`Phases`.`PhaseID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `Graves` ON `Phases`.`PhaseID`=`Graves`.`PhaseID`
INNER JOIN `GraveIndividuals` ON `GraveIndividuals`.`GraveID`=`Graves`.`GraveID`
WHERE `GraveIndividuals`.`aDNAID` IS NOT NULL;"
tmp <- query.database(sql.command, conn=conn)
dd <- subset(d, PhaseID%in%unique(tmp$PhaseID))
tablename <- 'aDNA'
file <- paste0(folder,'/',prefix,'.',tablename,'.svg')
common.plotter(dd=dd, tablename=tablename, file=file)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------
