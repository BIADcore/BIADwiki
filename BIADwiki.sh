#!/bin/sh
PATH="$PATH:/usr/local/bin/"

# BIADwiki controller

echo -e "Running BIADwiki controller"
echo "$PWD"
echo `date`
 
# server pulls the latest from the github repository (including the latest version of this file)
# server runs this file only
git status
git pull

DATE=$(date +%Y%m%d)

# run R scripts
echo -e "Starting BIADwiki/controller.R"
cd R
Rscript controller.R > ${LOGS_FOLDER}/BIADwiki.controller.Rout_$DATE
cd ..
echo -e "Ending BIADwiki/controller.R"

# this should be changed and use a symlink to the last, but this will need adjustmenet depending on the docker
echo -e "upload biadwiki log todocker"
scp -P 2222 ${LOGS_FOLDER}/BIADwiki.controller.Rout_$DATE tunnel@biad.cloud:/media/biad/BIADwiki.controller_last.txt
echo -e "upload biadwiki log todocker"

# backup files in droplet scp tunnel
for fold in templates summary_stats table_comments ;
do
    rsync -avz -e "ssh -p 2222" tools/$fold tunnel@biad.cloud:/media/biad/
done
#-------------------------------------------------------------------------------------------
