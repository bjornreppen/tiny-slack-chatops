#!/bin/bash
read -r running</home/grunnkart/tiny-slack-chatops/script/version.txt
release=`curl --silent "https://api.github.com/repos/Artsdatabanken/ratatouille/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'`
if [ "$running" == "$release" ]
	then echo "The running version is the same as the current release"
else
	echo "The running version is $running, while the current release is $release"
fi
