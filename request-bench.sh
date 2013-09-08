#!/bin/bash

#
# [...]
#

function usage()
{
	echo -e "Usage:\n\trequest-bench <number_of_app> <num_of_req> <concurrency>"
}

function getRemoteName()
{
	local APP_NAME=$1
	local N=$2
	echo dk-"$APP_NAME$N"
}

REPORT_DIR="/tmp/dokku-bench"
REPORT_EXT=".txt"

[[ -z $1 ]] && usage && exit 1

[[ ! -d $REPORT_DIR ]] && mkdir $REPORT_DIR

N_DEPLOY=$1
APP_NAME="sieve" # $(pwd | rev | cut -d'/' -f1 | rev)

echo "Start adding remotes..."

for I in $(seq 1 $N_DEPLOY); do
	CUR_APP_NAME="$APP_NAME$I"
	APP_URL="http://"$CUR_APP_NAME".dokku-paas.org/"
	echo "ab -n$2 -c$3 $APP_URL" > $REPORT_DIR/$CUR_APP_NAME$REPORT_EXT &
	PIDS="$PIDS $!"
done

for PID in $PIDS; do
	wait $PID
done

echo "Benchmark finished..."
