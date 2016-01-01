#!/bin/bash
# 用法  $:./decompile.sh [apk(路径,必须)] -[j(加此参数同时会将dex反编译为jar,可选)]

#反编译之后文件保存的路径
decompile_save_path=~/tools/apk_decompile
#apktool 根目录
apktool_path=~/tools/apk
#dex2jar 根目录
dex2jar_path=~/tools/apk/dex2jar-0.0.9.15

if [ $# -lt 1 ]; then
    echo "至少需要apk文件路径"
    exit 1
fi

if [[ $1 = "h" ]]; then

     echo "第一个参数apk文件路径"
     echo "j (可选,同时会将dex反编译为jar)"
    exit 0
fi

curPath=$1
if [[ $curPath =~ ^//* ]]; then	
curPath=$1
else
 curPath=`pwd`"/"$1
fi

#检测文件是否存在
if [ ! -f ${curPath} ];then
    echo "apk文件不存在"
    exit 1
fi
echo "文件验证通过,开始反编译..."
apk=`basename $curPath`  #通过路径获取apk文件名
apk=${apk%.*}    #截取.apk前的文件名


d_dir=$decompile_save_path"/"$apk  #反编译之后的路径 已apk文件名区分
if [ -e $d_dir ]; then
echo "删除旧文件..."
     rm -rf $d_dir
fi
mkdir $d_dir
cd $apktool_path
#echo `./apktool if framework-res.apk`
./apktool d -f $curPath -o $d_dir  #执行apktool的反编译

#下面开始将用dex2jar 反编译dex文件
if [[ $2 = "j" ]]; then
echo "开始反编译classes.dex文件..."
cd $d_dir
cls=classes.dex
unzip $curPath $cls -d $d_dir  #解压apk中的dex文件到工作目录

cp -f $cls $dex2jar_path
cd $dex2jar_path

./d2j-dex2jar.sh --force $cls   #开始dex反编译为jar
mv -f $dex2jar_path"/classes-dex2jar.jar" $d_dir  
#ls -l $d_dir
#if [[ $3 = "o" ]]; then

#fi
fi

echo "反编译 $apk.apk 成功!"
echo "文件保存在 $d_dir"

# mac osx open finder
open $d_dir
