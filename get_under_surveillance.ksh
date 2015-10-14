#!/bin/ksh

# Script to fetch Under Surveillance from last Friday
# Written by David Sidi.


function display_banner {
   echo "----------------------------------------------------------------------------------------------------------"
   echo "----------------------------------------------------------------------------------------------------------"
   echo Getting
   figlet -t "UNDER SURVEILLANCE"
   echo for $(date -d "${DATE_TO_GET}" +%F)
   echo "----------------------------------------------------------------------------------------------------------"
   echo "----------------------------------------------------------------------------------------------------------"
}


# MAIN FUNCTION
if [[ $(date +%A) = "Saturday" ]]; then
   DATE_TO_GET="now" 
else
   DATE_TO_GET="last saturday"
fi
YEAR=$(date -d "${DATE_TO_GET}" +%Y)      # full year (e.g., 2015)
MONTHNAME=$(date -d "${DATE_TO_GET}" +%b) # month abbrev. name (e.g., Oct)
MONTH=$(date -d "${DATE_TO_GET}" +%m)     # month number (e.g., 10)
DAY=$(date -d "${DATE_TO_GET}" +%d)       # day, with 2 digits (e.g., 31)
SAVEDIR="${HOME}/Music/under_surveillance/${MONTHNAME}_${DAY}_${YEAR}"
SUCCESSES=0

if mkdir ${SAVEDIR}; then
   cd $SAVEDIR
   display_banner
else
   echo "Directory $SAVEDIR already exists. Exiting..."
   exit 1 
fi

for SEQ_NUM in 050000 051500 054500 060000; do
   FILENAME="kxci_${YEAR}${MONTH}${DAY}-${SEQ_NUM}.mp3"
   if curl "https://s3-us-west-1.amazonaws.com/rfa-archive-dev/${FILENAME}" -o ${FILENAME}; then
      ((SUCCESSES += 1))
   fi
done

echo "Downloaded $SUCCESSES files successfully."

