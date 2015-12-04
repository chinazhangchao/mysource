#源
1.RubyGems 镜像 - 淘宝网

https://ruby.taobao.org/

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
