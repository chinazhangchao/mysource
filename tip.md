#运算
##1.经典浮点误差示例：

10.03 * 100 = 1002.9999999999999

0.1 + 0.2 = 0.30000000000000004

#svn
##1.文件名中存在@时，svn提示does not exist，解决方法竟然是在文件名末尾再加一个@。（作者脑袋被驴踢）

如：

svn rm Images.xcassets/主页/prodCome.imageset/prodCome@2x.jpg@

svn add Images.xcassets/主页/prodCome.imageset/prodCome@2x.png@

#git

##1.修改配置后记得commit reset author

git config user.email yournewemail@example.org

git commit --amend --reset-author

#mysql
##1.mysql单表多timestamp的current_timestamp设置问题

一个表中出现多个timestamp并设置其中一个为current_timestamp的时候经常会遇到

"Incorrect table definition; there can be only one TIMESTAMP column with CURRENT_TIMESTAMP in DEFAULT or ON UPDATE clause"

原因是当你给一个timestamp设置为on update current_timestamp的时候，其他的timestamp字段需要显式设定default值。

但是如果你有两个timestamp字段，但是只把第一个设定为current_timestamp而第二个没有设定默认值，mysql也能成功建表, 但是反过来就不行...（够脑残~）
