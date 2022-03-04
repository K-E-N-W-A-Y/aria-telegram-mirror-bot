#!/bin/bash

if [[ -n $DYNO ]]; then

	if [[ -n $GIT_USER && -n $GIT_TOKEN && -n $GIT_REPO ]]; then
		echo "Usage of Service Accounts Detected, Clonning git"
		git clone https://"$GIT_TOKEN"@github.com/"$GIT_USER"/"$GIT_REPO" /bot/accounts
		rm -rf /bot/accounts/.git
	elif [[ -n $CLIENT_SECRET && -n $CREDENTIALS ]]; then
		echo "Usage of token detected"
		wget -q $CREDENTIALS -O /bot/credentials.json
		wget -q $CLIENT_SECRET -O /bot/client_secret.json
	else
		echo "Neither Service Accounts Nor Token Provided. Exiting..."
		exit 0
	fi

	if [[ -n $CONSTANTS_URL ]]; then
		wget -q $CONSTANTS_URL -O /bot/out/.constants.js
	else
		echo "Provide constants.js to Run the bot. Exiting..."
		exit 0
	fi
fi


if [[ -n $MAX_CONCURRENT_DOWNLOADS ]]; then
	sed -i'' -e "/max-concurrent-downloads/d" $(pwd)/data.conf
	echo -e "max-concurrent-downloads=$MAX_CONCURRENT_DOWNLOADS" >> $(pwd)/data.conf
fi

sed -i'' -e "/bt-tracker=/d" $(pwd)/data.conf
tracker_list=`curl -Ns https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt | awk '$1' | tr '\n' ',' | cat`
echo -e "bt-tracker=$tracker_list" >> $(pwd)/data.conf

test -f $(pwd)/data.conf-e && rm $(pwd)/data.conf-e

aria2c --conf-path=data.conf
echo "daemon started"

if [[ -n $DYNO ]]; then
	npm start
fi
