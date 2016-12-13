#!/bin/ksh

# Script to fetch the KXCI radio show Electric Feel from last Friday
# Written by David Sidi.

function write_line {
   TERMINAL_WIDTH=$(stty size | cut -d' ' -f2)
   for ((j=0; j<$TERMINAL_WIDTH; j++)); do
      echo -n "o"
   done
   echo
}

function display_banner {
   write_line; write_line
   echo Getting
   figlet -t "ELECTRIC FEEL"
   echo for $(date -d "${DATE_TO_GET}" +%F)
   write_line; write_line
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
SAVEDIR="${HOME}/Music/electric_feel/${MONTHNAME}_${DAY}_${YEAR}"
SUCCESSES=0

if mkdir -p ${SAVEDIR} 2> /dev/null; then
   cd $SAVEDIR
   display_banner
else
   echo "Directory $SAVEDIR already exists. Exiting..."
   exit 1 
fi
for SEQ_NUM in 030000 034500 040000 041500 043000 044500 050000 051500 053000 \
   054500 060000 061500 063000 064500 070000 071500 073000 074500; do
   FILENAME="kxci_${YEAR}${MONTH}${DAY}-${SEQ_NUM}.mp3"
   if curl "https://s3-us-west-1.amazonaws.com/rfa-archive-dev/${FILENAME}" \
      -o ${FILENAME}; then

         ((SUCCESSES += 1))
         mid3v2 \
            --artist="Tobey Roberts, Corbin Dooley" \
            --album="Electric Feel" \
            --genre="NuSmoothcore, Call-and-Response" \
            --date=${YEAR}-${MONTH}-${DAY} \
            --comment="Shout out as always to Belly Bear and Gogmagog" \
            ${FILENAME}

   fi
done

echo "Downloaded $SUCCESSES files successfully."

