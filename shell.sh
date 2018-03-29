#!/usr/bin/env bash
#使用方法

pwd

cd ./UIDS

if [ ! -d ./IPADir ];
then
mkdir -p IPADir;
fi

pwd

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

#工程名 将XXX替换成自己的工程名
project_name='UIDS'

#scheme名 将XXX替换成自己的sheme名
scheme_name='UIDS'

#打包模式 Debug/Release
development_mode=Debug

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=${project_path}/exportTest.plist

#导出.ipa文件所在路径
exportIpaPath=${project_path}/IPADir/${development_mode}


echo "Place enter the number you want to export ? [ 1:app-store 2:ad-hoc] "

###
#read number
#while([[ $number != 1 ]] && [[ $number != 2 ]])
#do
#echo "Error! Should enter 1 or 2"
#echo "Place enter the number you want to export ? [ 1:app-store 2:ad-hoc] "
#read number
#done
#
#if [ $number == 1 ];then
#development_mode=Release
#exportOptionsPlistPath=${project_path}/exportAppstore.plist
#else
#development_mode=Debug
#exportOptionsPlistPath=${project_path}/exportTest.plist
#fi
development_mode=Debug
exportOptionsPlistPath=${project_path}/exportTest.plist

#echo '///-----------'
#echo '/// 正在清理工程'
#echo '///-----------'
#xcodebuild \
#clean -configuration ${development_mode} -quiet  || exit


echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo '///--------'
echo '/// 编译完成'
echo '///--------'
echo ''

echo '///-------------'
echo '/// 开始发布ipa包 '
echo '///-------------'


exit 0
