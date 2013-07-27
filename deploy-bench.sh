#!/bin/bash

#
# This script creates N git remotes for concurrent deployments on Dokku.
# [...]
#

function usage()
{
	echo -e "Usage:\n\tdeploy-bench <number_of_deployments>"
}

function getRemoteName()
{
	local APP_NAME=$1
	local N=$2
	echo dk-"$APP_NAME$N"
}

[[ -z $1 ]] && usage && exit 1

N_DEPLOY=$1
APP_NAME="sieve" # $(pwd | rev | cut -d'/' -f1 | rev)

echo "Start adding remotes..."

for I in $(seq 1 $N_DEPLOY); do
	REMOTE_NAME=$(getRemoteName $APP_NAME $I)
	CUR_APP_NAME="$APP_NAME$I"
	git remote add $REMOTE_NAME "git@dokku-paas.org:$CUR_APP_NAME"
done

echo "All remotes added... start deployments..."

time (
	for I in $(seq 1 $N_DEPLOY); do
		REMOTE_NAME=$(getRemoteName $APP_NAME $I)
		git push --quiet $REMOTE_NAME master:master >/dev/null &
		PIDS="$PIDS $!"
	done

	for PID in $PIDS; do
		wait $PID
	done
);

echo "Deployments finished... Removing remotes..."

for I in $(seq 1 $N_DEPLOY); do
	REMOTE_NAME=$(getRemoteName $APP_NAME $I)
	git remote rm $REMOTE_NAME
done

echo "All remote removed... benchmark finished."
