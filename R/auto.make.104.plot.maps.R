#------------------------------------------------------------------
# maps of various data types, simply showing the density of data
#-----------------------------------------------------------------
require(BIADconnect)
conn <- init.conn()
folder <- '../tools/plots'
#-----------------------------------------------------------------
# common plot function
#-----------------------------------------------------------------
common.map.plot.function <- function(d, file, width=13){
	require(maps)
	require(svglite)

	res <- summary_maker(d)
	x <- res$summary$Longitude
	y <- res$summary$Latitude
	xlim <- range(d$Longitude)
	ylim <- range(d$Latitude)
	height <- width /(cos(mean(ylim)/180*(pi)) * diff(xlim)/diff(ylim))
	svglite(file=file, width=width, height=height)
	plot(NULL, xlim=xlim, ylim=ylim, frame.plot=FALSE, axes=FALSE, xlab='', ylab='')
	map('world', xlim=xlim, ylim=ylim, col='grey90', add=TRUE, fill=TRUE, border='grey')
	points(x, y, col=res$summary$col, pch=16,cex=0.8)
	legend('topleft', res$legend, bty='n', col=res$cols, pch=16, cex=0.7)
	dev.off()
	}
#-----------------------------------------------------------------
# aDNA
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`aDNAID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `Graves` ON `Phases`.`PhaseID`=`Graves`.`PhaseID`
INNER JOIN `GraveIndividuals` ON `GraveIndividuals`.`GraveID`=`Graves`.`GraveID`
WHERE `GraveIndividuals`.`aDNAID` IS NOT NULL;"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.ancient_dna.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# grave individuals
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`IndividualID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `Graves` ON `Phases`.`PhaseID`=`Graves`.`PhaseID`
INNER JOIN `GraveIndividuals` ON `GraveIndividuals`.`GraveID`=`Graves`.`GraveID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.grave_individuals.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# Faunal species
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`FaunalSpeciesID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `FaunalSpecies` ON `Phases`.`PhaseID`=`FaunalSpecies`.`PhaseID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.faunal_species.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# Botanical species
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`SampleID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `ABotSamples` ON `Phases`.`PhaseID`=`ABotSamples`.`PhaseID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.archaeobotanical_species.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# C14
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`C14ID` FROM `Sites`
INNER JOIN `C14Samples` ON `Sites`.`SiteID`=`C14Samples`.`SiteID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.radiocarbon_samples.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# human isotopes
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`HumanIsoID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `Graves` ON `Phases`.`PhaseID`=`Graves`.`PhaseID`
INNER JOIN `GraveIndividuals` ON `GraveIndividuals`.`GraveID`=`Graves`.`GraveID`
INNER JOIN `HumanIsotopes` ON `HumanIsotopes`.`IndividualID`=`GraveIndividuals`.`IndividualID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.human_isotopes.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# Faunal isotopes
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`FaunIsoID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `FaunalIsotopes` ON `FaunalIsotopes`.`PhaseID`=`Phases`.`PhaseID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.faunal_isotopes.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# health
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`Trait` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `Graves` ON `Phases`.`PhaseID`=`Graves`.`PhaseID`
INNER JOIN `GraveIndividuals` ON `GraveIndividuals`.`GraveID`=`Graves`.`GraveID`
INNER JOIN `Health` ON `Health`.`IndividualID`=`GraveIndividuals`.`IndividualID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.human_health_indicators.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
# material culture
#-----------------------------------------------------------------
sql.command <- "SELECT `Sites`.`SiteID`,`Longitude`,`Latitude`,`MaterialCultureID` FROM `Sites`
INNER JOIN `Phases` ON `Sites`.`SiteID`=`Phases`.`SiteID`
INNER JOIN `MaterialCulture` ON `Phases`.`PhaseID`=`MaterialCulture`.`PhaseID`"

d <- query.database(sql.command = sql.command, conn=conn)
file <- paste0(folder,'/map.material_culture.svg')
common.map.plot.function(d, file)
#-----------------------------------------------------------------
disconnect()
#-----------------------------------------------------------------