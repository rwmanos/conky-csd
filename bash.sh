#! /bin/bash
//rwmaons
REPEATS=4

if [ -e ~/.conky_csd/cache/announcements.php ]; then
	rm -f ~/.conky_csd/cache/announcements
fi

mkdir -p ~/.conky_csd/cache

wget -q http://www.csd.auth.gr/announcements.php -O ~/.conky_csd/cache/announcements

# test if file announcements exists.
if [ ! -f ~/.conky_csd/cache/announcements ]; then
	echo "There is not internet connection"
	exit 1
fi

LOOP=1

ID=`tail -n 60 ~/.conky_csd/cache/announcements | grep "<ul><li><a href=\"" | awk '{ print $2 }' | cut -c 35-37`

if [ -f ~/.conky_csd/cache/last_announcementID ]; then
	if [ $ID -gt `cat ~/.conky_csd/cache/last_announcementID` ] ; then 
		echo `date +%j` > ~/.conky_csd/cache/last_announcementDate
		echo $ID > ~/.conky_csd/cache/last_announcementID
	fi
else 
	echo `date --date='11 days ago' +%j` > ~/.conky_csd/cache/last_announcementDate
	echo $ID > ~/.conky_csd/cache/last_announcementID
fi

COUNTER=1
while [  $LOOP -le $REPEATS ]; do
 	echo -n $LOOP": "
	let "LOOP+=1"

	VAR=`tail -n 60 ~/.conky_csd/cache/announcements | grep "<ul><li><a href=\""` 
	echo `echo $VAR | awk -v i=$COUNTER 'BEGIN {flag = "true"} { i++; while( match(flag,"true")) { if (match($i, "</a></li><li><a")) flag = "false"; print $i ; i++; if (i>100) flag="false" }}' ` | cut -c 40-1000 | sed 's/[a-z,<,/,>]*//g'
	#echo counter=$COUNTER
	COUNTER=`echo $VAR | awk -v i=$COUNTER 'BEGIN {flag = "true"} { i++; while( match(flag,"true")) { if (match($i, "</a></li><li><a")) flag = "false"; i++;} print i }'`
	let COUNTER=COUNTER-1 

done
echo
