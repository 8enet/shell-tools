#!/bin/bash
#最后生成的签名apk在传入传入文件夹的dist/xxx_rebuild_signed.apk

#apktool 根目录,可选配置，如果环境变量中有apktool可以不用配置
apktool_path=~/tools/android/apktool

#keystore 目录，必须配置，用于签名文件
key_store=~/tools/android/demo.keystore
key_store_pwd="123456"
key_alias="mytestkey"
key_alias_pwd="123456"


# 判断apktool,优先使用手动配置的，如果没有就提取环境变量中的
if [ ! -x ${apktool_path} ]; then
	apktool_path=$(command -v apktool) 
	if [ ! -x ${apktool_path} ];then
	    echo '没有找到apktool ! 需要先配置'
	    exit 1
	else
		echo '使用环境变量中的apktool'
    fi
fi

# 判断签名文件是否存在
if [ ! -f ${key_store} ];then
    echo "keystore 签名文件不存在!"
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "输入要重新编译的文件夹路径"
    exit 1
fi

build_dir=$1

unsign_apk_dir=$build_dir"/dist" #生成未签名 apk 的文件夹路径

echo "删除 build、dist文件夹"
rm -rf $build_dir"/build"
rm -rf $build_dir"/dist"

echo "assamble apk"
$apktool_path b  $build_dir

cd $unsign_apk_dir

find . -type f -name *.apk -print |

while read myline
do

compress "$myline" 

unsign_apk_filename=`basename "$myline"` #未签名apk 文件名

unsign_apk=$unsign_apk_dir"/"$unsign_apk_filename  #未签名apk路径

sign_apk_file=$unsign_apk_dir"/"${unsign_apk_filename%.*}"_rebuild_signed.apk" #签名后生成apk的路径

#echo "${unsign_apk_filename%.*}" #截取文件名，不要后缀的

echo "开始签名apk"

#签名 apk
jarsigner -keystore $key_store -storepass $key_store_pwd  -keypass $key_alias_pwd -digestalg SHA1 -sigalg sha1withrsa -signedjar $sign_apk_file $unsign_apk $key_alias

jarsigner -verify $sign_apk_file  #验证签名

echo "signed apk file: $sign_apk_file"

#用finder打开文件夹，可选
open $unsign_apk_dir

done




