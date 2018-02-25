#翻墙

https://github.com/getlantern/lantern/releases/tag/latest

#运算
##1.经典浮点误差示例：

10.03 * 100 = 1002.9999999999999

0.1 + 0.2 = 0.30000000000000004

0.65 - 0.6 = 0.050000000000000044

#svn
##1.文件名中存在@时，svn提示does not exist，解决方法竟然是在文件名末尾再加一个@。（作者脑袋被驴踢）

如：

svn rm Images.xcassets/主页/prodCome.imageset/prodCome@2x.jpg@

svn add Images.xcassets/主页/prodCome.imageset/prodCome@2x.png@

#npm
##淘宝镜像

npm install chromedriver --chromedriver_cdnurl=http://cdn.npm.taobao.org/dist/chromedriver

npm install --registry=http://registry.npm.taobao.org

npm config set registry https://registry.npm.taobao.org

--ignore-scripts

yarn config set registry https://registry.yarnpkg.com

yarn config set registry https://registry.npm.taobao.org --global

yarn config set disturl https://npm.taobao.org/dist --global

npm config set registry https://registry.npm.taobao.org --global

npm config set disturl https://npm.taobao.org/dist --global

#git

##1.修改配置后记得commit reset author

git config user.email yournewemail@example.org

git commit --amend --reset-author

##2.文件大小写重命名
git mv FileNameCase filenamecase

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

#Ubuntu
##1.程序安装

sudo apt-get install -y build-essential

sudo add-apt-repository ppa:git-core/ppa

sudo apt-get update

sudo apt-get install git

sudo add-apt-repository ppa:webupd8team/sublime-text-2

sudo apt-get update

sudo apt-get install sublime-text

https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora

sudo apt-get update

sudo apt-get install firefox

sudo apt-get install -f libxss1 libappindicator1 libindicator7

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome*.deb

#vagrant

vagrant box add dev-box package.box
vagrant init dev-box

VBoxManage setextradata ruby-dev-machine VBoxInternal2/SharedFoldersEnableSymlinksCreate/projects 1
vagrant up

vagrant plugin install vagrant-vbguest

wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O .ssh/authorized_keys

chmod 700 .ssh

chmod 600 .ssh/authorized_keys

chown -R vagrant:vagrant .ssh