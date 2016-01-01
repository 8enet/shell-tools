#!/bin/bash 
tmpdir=".temp_for_certificate"
mkdir $tmpdir 
cd $tmpdir 
count=0 
while [ -n "$1" ] 
do 
count=$[$count+1] 

cd ../
curPath=$1
if [[ $curPath =~ ^//* ]]; then	
curPath=$1
else
 curPath=`pwd`"/"$1
fi
cd $tmpdir

echo $curPath

echo "(#$count) "`basename "$curPath"`":" 
echo "" 
aapt dump badging $curPath | grep versionCode   # 输出apk版本信息
echo "" 
path=`jar tf "$curPath" | grep RSA` #查找apk中RSA文件 
jar xf $curPath $path #把RSA文件解压出来 
keytool -printcert -file $path #查看指纹证书 
rm -r $path #删除之前解压的文件 
echo "--------------------------------------------" 

shift 
done 
cd .. 
rm -r $tmpdir