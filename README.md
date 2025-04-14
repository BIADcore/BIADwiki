<a href="http://biadwiki.org/"><img src="tools/logos/BIAD.logo.net.png" alt="BIAD" height="150"/></a>
# BIAD
## Big Interdisciplinary Archaeological Database
This github repository supports the BIAD wiki [biadwiki.org](http://biadwiki.org/) by providing a single collaborative repository to develop R code ONLY for maintaining the wiki.


## Installation

To use the BIADwiki repository you may need to install some of the following packages, depending on which scripts you wish to run:

```r
install.package(
    c("ADMUR", #to automatically compute date based on C14 sample and phases proximities
      "httr",#to send  files to wiki.js
      "gridExtra",
      "rnaturalearth",
      "DiagrammeRsvg",
      "DiagrammeR",  # exports some nice data trees 
      "ggplot2",
      "svglite",
      "maps",
      "mapdata",
      "terra", #this is for rnaturalearth
      "sf",
      "gt", # to export tables
      "rsvg"
     )
)
```

!!! note that I (simon) had to install some as sudo (thus doing `sudo R`, before install) because weirdly `admin` can't write in `/tmp/` or whatever ; I don't understand anyway I couldn't compile stuff for `SF` so it failed, and same for `TERRA`, and same for `FS` & `SASS`, both some frontend stuff used by `gt`. very annoying this tmp problem, no time to solve it atm


These package needs some system wide dependencies: 

```bash
 apt install libcurl4-openssl-dev \ #for diagrammeRsvg; god knows why they use that... 
             librsvg2 \  #for rsvg (I personnally vote to rewrite auto.make... to NOT USE diagrammeRsvg 
             libudunits2-dev  \ # for units, used by sf
             libgdal-dev libgeos-dev libproj-dev \ #these are also used by sf ;
             libmysqlclient-dev # needed that for libgdal-dev to install, why throwing conflict with mariadb
```


### R scripts run only by the server
Various internal consistency checks, summary statistics and images are generated automatically from BIAD and used to populate the BIADwiki.
These R scripts are prefaced 'auto.make.xxxxxx.R and run on the hosting server daily. 
A single bash script BIADwiki.sh is run by the server's crontab schedule. 
BIADwiki.sh invokes R to run a single R script controller.R.
The R script controller.R runs the auto.make.xxx.R scripts.
Login credentials for the local server are stored in the .Rprofile and therefore are automatically invoked when the server runs R in admin.
These scripts will not work if you want to run them externally from the server as a standard user. To fix this issue it is necessary to first load the functions source("https://raw.githubusercontent.com/BIADwiki/BIADwiki/main/R/functions.R") and to replace the "query.database" function with "run.server.query(query.database(sql.command)".

### General example R scripts for users
All below is now deprecated! don't do that!

Files prefaced 'example.xxxxx.R' are generic example files for end users wishing to interact with BIAD via R, for example when building a script to both query and analyse data.
Get a github account, then clone the whole repository to your local machine to use the scripts. If you want to collaborate with coding (rather than just use it) you will need to request permission to push, from the database administrator.

### Personal R scipts
Files prefaced 'private.xxxxx.R' in your cloned repository will not be tracked or saved on Github, and will only exist on your machine.






