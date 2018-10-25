#!/bin/bash
read -r running</home/grunnkart/tiny-slack-chatops/script/version.txt
release=`curl --silent "https://api.github.com/repos/Artsdatabanken/ratatouille/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'`
if [ "$running" == "$release" ]
	then echo "You are already running the latest release - exiting"
else
echo "Running version is outdated, updating from repository"
url="https://github.com/Artsdatabanken/ratatouille/releases/download/$release/bundle.tar.gz"
wget $url
tar -xzf bundle.tar.gz -C /home/grunnkart/statics
#curl -X POST --data-urlencode "payload={\"channel\": \"#grunnkart_botnet\", \"username\": \"anna\", \"text\": \"Pulled and deployed $release from ratatouille.\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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
rm bundle.tar.gz
echo $release > /home/grunnkart/tiny-slack-chatops/script/version.txt
echo "Updated running version of ratatouille to $release"
fi
