#!/usr/bin/env bash

echo "测试： "$1

cd ./ios_version/$1

pwd

rm -rf ./IPADir/UIDS.app

pwd
ls
pwd

mv ./build/UIDS.xcarchive/Products/Applications/UIDS.app ./IPADir

pwd

cd ./IPADir

rm -rf UIDS

mkdir UIDS

mkdir UIDS/Payload

cp -r UIDS.app UIDS/Payload/UIDS.app

cp Icon.png UIDS/iTunesArtwork

cd UIDS

zip -r UIDS_bai.ipa Payload


exit 0
