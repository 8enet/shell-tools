#!/bin/bash 

#需要借助aapt查看包名等信息,aapt命令在android sdk/build-tools/xxx-version/aapt
#最好将这个文件夹加入到环境变量


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