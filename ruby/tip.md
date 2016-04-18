#源
1.RubyGems 镜像 - 淘宝网

https://ruby.taobao.org/

#encoding
每一个字符串都有一个 Encoding 对象，也就是说在创建字符串的时候就要为它指定一个 Encoding 对象。

Ruby1.9 的实现方法是，所有的源码都有一个 Encoding 对象，当你在源码中创建字符串时，源码的 Encoding 对象会自动赋予给字符串。

我们一般会在ruby源码文件头部声明编码格式： # encoding: utf-8

注意：这里声明只是告诉ruby解析器源码文件格式，并不是设置文件格式。
比方说你声明# encoding: gbk，然而文件格式却是utf-8，运行可是会出错的，
因为ruby解析器会用你告诉它的gbk编码解析文件，显然这个肯定是要乱码的， 出错是必然的。

如果要在内部修改字符串编码用encode!函数,如:

'日期'.encode!(Encoding::GBK)

#mongoid
compound index校验：

```ruby
validates_uniqueness_of :visit_key_word, :scope => [:source, :date, :visit_number, :deal_key_word, :deal_number]
```

#rails

##1.devise
###Gemfile

gem "rails-i18n"

gem 'devise'

gem 'devise-i18n-views'

###development.rb

config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

###application.rb
config.time_zone = 'Beijing'
config.i18n.default_locale = 'zh-CN'

###命令

rails g devise:install

rails g devise user

rails g devise:views:i18n_templates

rake secret
