##运算
1.经典浮点误差示例：

10.03*100 => 1002.9999999999999

##svn
1.文件名中存在@时，svn提示does not exist，解决方法竟然是在文件名末尾再加一个@。（作者脑袋被驴踢）

如：

svn rm Images.xcassets/主页/prodCome.imageset/prodCome@2x.jpg@

svn add Images.xcassets/主页/prodCome.imageset/prodCome@2x.png@

