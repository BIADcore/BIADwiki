#!/bin/sh
PATH="$PATH:/usr/local/bin/"

# git pull first
git status
git pull

DATE=$(date +%Y%m%d)
#
# run R scripts
cd R
Rscript controller.R > controller.Rout_$DATE
## this should be changed and use a symlink to the last, but this will need adjustmenet depending on the docker
scp -P 2222 controller.Rout_$DATE tunnel@biad.cloud:/media/biad/controller_last.txt
mv controller.Rout_$DATE $LOGS_FOLDER
cd ..

# backup files in dropplet scp tunnel
for fold in templates summary_stats table_comments ;
do
    rsync -avz -e "ssh -p 2222" tools/$fold tunnel@biad.cloud:/media/biad/
done

# one last pull, then push the changes
git status
git pull
git add -A tools/table_comments/
git add -A tools/templates/
git commit -m "auto update from server"
git push
git status
