#!/bin/bash

#apktool 根目录
apktool_path=~/tools/apk

#keystore 目录
key_store=~/tools/demo.keystore
key_store_pwd="123456"
key_alias="mytestkey"
key_alias_pwd="123456"


if [ $# -lt 1 ]; then
    echo "输入要重新编译的文件夹路径"
    exit 1
fi

build_dir=$1

unsign_apk_dir=$build_dir"/dist" #生成未签名 apk 的文件夹路径

echo "删除 build、dist文件夹"
rm -rf $build_dir"/build"
rm -rf $build_dir"/dist"


cd $apktool_path
echo "assamble apk"
./apktool b  $build_dir

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

open $unsign_apk_dir

done




