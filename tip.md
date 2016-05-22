#翻墙

https://github.com/getlantern/lantern/releases/tag/latest

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

#Mac

##1.Mac终端里神秘的bogon及解决方法
如题，Mac下的终端经常有时候前面的计算机名会错误的显示成 bogon. 这是因为终端会先向 DNS 请求查询当前 IP 的反向域名解析的结果，如果查询不到再显示我们设置的计算机名。而由于我们的 DNS 错误地将保留地址反向的 NS 查询结果返回了 bogon. 其中 bogon 本应该用来指虚假的 IP 地址，而非保留 IP 地址。因此就出现了会时不时地打印 bogon 这种奇怪名字作为计算机名的现象了。那么如何让终端只显示我们想要的计算机名而不总是从 DNS 返回结果呢？

解决方案：

在终端中执行以下命令即可（需要输入一次管理员密码）

sudo hostname your-desired-host-name

sudo scutil --set LocalHostName $(hostname)

sudo scutil --set HostName $(hostname)
