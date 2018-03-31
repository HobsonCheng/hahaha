#!/usr/bin/env bash

echo "参数1："$1"参数2："$2

cd ./ios_version/$2

cd ./IPADir

pwd

#上传app 到云服务

scp ./UIDS/UIDS_bai.ipa root@47.93.3.19:/www/dist/apps/UIMaster_$1.ipa

scp ../UIDS/Assets.xcassets/AppIcon.appiconset/Icon-58.png root@47.93.3.19:/www/dist/apps/$1_29@2x.png

scp ./downApp_$1.plist root@47.93.3.19:/www/dist/apps/downApp_$1.plist


rm -rf ./UIDS
rm -rf ./UIDS.app

exit 0
