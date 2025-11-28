#----------------------------------------------------------------------------------
# script to plot database relationships
#----------------------------------------------------------------------------------
require(rsvg)
require(DiagrammeRsvg)
require(BIADconnect)
#----------------------------------------------------------------------------------
# Pull all foreign keys
conn <- init.conn()
sql.command <- "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='BIAD';"	
d.tables <- query.database(sql.command = sql.command, conn=conn)$TABLE_NAME
disconnect()

zprivate <- d.tables[grepl('zprivate', d.tables)]
zoptions <- d.tables[grepl('zoptions', d.tables)]
copy <- d.tables[grepl('copy', d.tables)]
standard <- d.tables[!d.tables%in%c(zoptions,zprivate,copy)]
#------------------------------------------------------------------
# all relationships
#------------------------------------------------------------------
d.tables <- paste(standard, collapse='; ')
image <- database.relationship.plotter(d.tables, include.look.ups=FALSE, conn=conn)
svg <- export_svg(image)
writeLines(svg, '../tools/plots/database.relationships.plot.svg')
#------------------------------------------------------------------
# cohort 1
# move to a non-auto make plot etc
#
#d.tables <- paste(c('Phases','C14Samples','C14Ghosts','Citations','FaunalBiometrics','FaunalSpecies','Graves','MaterialCulture','Metallurgy','Monuments','PhaseCitation'), collapse='; ')
#image <- database.relationship.plotter(d.tables, include.look.ups=FALSE, conn = conn)
#
#svg <- export_svg(image)
#writeLines(svg, '../tools/plots/database.relationships.plot.sub.1.svg')
#--------------------------------------------------------------------------------------

