#!/bin/bash

#rx_poc.log will be your POC weather report log file, or a text file which contains a growing history of the daily weather data you will scrape. Each entry in the log file corresponds to a row as in Table 1.
touch rx_poc.log

#header should consist of the column names from Table 1, delimited by tabs.
header=$(echo -e "year\tmonth\tday\tobs_temp\tfc_temp")
echo $header>rx_poc.log

#Create a text file called rx_poc.sh and make it an executable Bash script and Include the Bash shebang on the first line of rx_poc.sh i.e #! /bin/bash

touch rx_poc.sh
echo "#! /bin/bash" >> rx_poc.sh

#Make your script executable by running the following in the terminal:
chmod u+x rx_poc.sh

echo "city=Casablanca" >> rx_poc.sh
# Obtain the weather information for Casablanca
echo "curl -s wttr.in/$city?T --output weather_report" >> rx_poc.sh

#Edit rx_poc.sh to extract the required data from the raw data file and assign them to variables obs_temp(Current temperature) and fc_temp(forecast temperature)
echo  "obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*')\necho "The current Temperature of $city: $obs_temp"" >> rx_poc.sh

# To extract the forecast tempearature for noon tomorrow
echo "fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')\necho "The forecasted temperature for noon tomorrow for $city : $fc_temp C"" >>rx_poc.sh

#Store the current hour, day, month, and year in corresponding shell variables
echo "hour=$(TZ='Morocco/Casablanca' date -u +%H)/n day=$(TZ='Morocco/Casablanca' date -u +%d)/n month=$(TZ='Morocco/Casablanca' date +%m)/nyear=$(TZ='Morocco/Casablanca' date +%Y)">>rx_poc.sh

#Merge the fields into a tab-delimited record, corresponding to a single row in Table 1
echo "record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")/necho $record>>rx_poc.log">> rx_poc.sh

#Schedule your Bash script rx_poc.sh to run every day at noon local time







