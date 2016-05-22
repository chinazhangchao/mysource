#源
1.RubyGems 镜像 - rubychina

https://gems.ruby-china.org/

gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

https://github.com/ruby-china/rubygems-mirror/wiki#%E5%85%B3%E4%BA%8E-windows-%E4%B8%8B%E8%AF%81%E4%B9%A6%E6%97%A0%E6%B3%95%E9%AA%8C%E8%AF%81%E9%97%AE%E9%A2%98-certificate-verify-failed

#encoding
每一个字符串都有一个 Encoding 对象，也就是说在创建字符串的时候就要为它指定一个 Encoding 对象。

Ruby1.9 的实现方法是，所有的源码都有一个 Encoding 对象，当你在源码中创建字符串时，源码的 Encoding 对象会自动赋予给字符串。

我们一般会在ruby源码文件头部声明编码格式： # encoding: utf-8

注意：这里声明只是告诉ruby解析器源码文件格式，并不是设置文件格式。
比方说你声明# encoding: gbk，然而文件格式却是utf-8，运行可是会出错的，
因为ruby解析器会用你告诉它的gbk编码解析文件，显然这个肯定是要乱码的， 出错是必然的。

如果要在内部修改字符串编码用encode!函数,如:

'日期'.encode!(Encoding::GBK)

字符串经常还可以通过另一种方法来创建：从 IO 对象读取。这时候我们就不能简单的将源码的 Encoding 对象赋值给字符串了，因为外码数据与源码无关。因此，IO 对象至少要附着一种 Encoding 对象。而 Ruby 为此提供了两种编码：外部编码和内部编码。

我们通过设置打开文件的模式来设定外部编码和内部编码，并通过 IO 对象的 external_encoding 和 internal_encoding 方法来访问外部编码和内部编码。

外部编码是数据在 IO 对象内所采用的编码，外部编码影响数据的读取；如果内部编码没有设定的话，返回数据也会采用外部编码的编码进行编码。

如果设置了内部编码，数据还是以外部编码读取，但是在创建字符串时会将其转到内部编码。这个程序带来了便利。

在写模式下，外部编码以相同的方式工作。但是，此时你就没有必要显示的指定一个内部编码了，Ruby 会自动将输出的字符串的编码设为内部编码，如果需要的话将数据转换为外部编码。

如果不设置它们，内部编码默认值是 nil 。外部编码默认值会从环境中去取得，类似于通过命令行设定源码的方式。

这两个 IO 相关的编码各自有一个全局性的设置方法：Encoding.default_external=() 和 Encoding.default_internal=() 。你可以把它们设定为 Encoding 对象或者所对应的字符串。

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
