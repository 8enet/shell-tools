# APK 工具

* [apkinfo.sh](apkinfo.sh) 查看apk包名、版本和签名信息，依赖aapt和jdk   
  ```
  ./apkinfo.sh xxx.apk
  ```
  
* [decompile.sh](decompile.sh)  快速反编译apk和生成jar，依赖apktool,dex2jar   
  ```
  ./decompile.sh xxx.apk j #最后的j表示同时使用dex2jar生成jar文件
  ```
  
* [rebuild.sh](rebuild.sh)  快速重新打包并签名，需要配置keystore，依赖apktool和jarsigner   
  ```
  ./rebuild.sh xxx.apk 
  ```
   
