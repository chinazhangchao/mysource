require 'fileutils'

gem "rails-i18n"

gem 'devise'

gem 'devise-i18n-views'

environment 'config.i18n.default_locale = \'zh-CN\''
environment 'config.time_zone = \'Beijing\''

environment 'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }', env: 'development'

generate(:controller, "index")
route "root 'index#index'"

generate(:"devise:install")
generate(:devise, "user")
rake "db:migrate"
generate(:"devise:views:i18n_templates")

src_dir = '/Users/zhangchao/github/mysource/ruby/'

app_layout = File.read("#{src_dir}application.html.erb")
app_layout.sub!('APP_NAME', app_name())
File.write('app/views/layouts/application.html.erb', app_layout)

devise_layout = File.read("#{src_dir}devise.html.erb")
devise_layout.sub!('APP_NAME', app_name())
File.write('app/views/layouts/devise.html.erb', devise_layout)

File.write('app/views/index/index.html.erb', '<h1>Perfect!<h1>')

# File.write('.gitignore', File.read("#{src_dir}rails.gitignore"))
FileUtils.cp("#{src_dir}rails.gitignore", '.gitignore')

FileUtils.cp("#{src_dir}devise.zh-CN.yml", 'config/locales')
FileUtils.cp("#{src_dir}devise-view-zh-CN.yml", 'config/locales')

bootstrap_dir = '/Users/zhangchao/jslib/bootstrap-3.3.5/dist/'

FileUtils.cp("#{bootstrap_dir}css/bootstrap.css", "vendor/assets/stylesheets")
FileUtils.cp("#{bootstrap_dir}css/bootstrap.min.css", "vendor/assets/stylesheets")
FileUtils.cp("#{bootstrap_dir}js/bootstrap.js", "vendor/assets/javascripts")
FileUtils.cp("#{bootstrap_dir}js/bootstrap.min.js", "vendor/assets/javascripts")

FileUtils.cp("/Users/zhangchao/jslib/angularjs1.2.8/angular.min.js", "vendor/assets/javascripts")

FileUtils.cp("/Users/zhangchao/github/bootstrap/ui-bootstrap-tpls-0.9.0.min.js", "vendor/assets/javascripts")

appjs_append = '
//= require bootstrap.min
//= require angular.min
//= require ui-bootstrap-tpls-0.9.0.min'

appjs_file = File.new('app/assets/javascripts/application.js', 'r+')
appjscontent = appjs_file.read + appjs_append + "\n"
appjs_file.write(appjscontent)
appjs_file.close

appcss_file = File.new('app/assets/stylesheets/application.css', 'r+')
appcss_file.seek(-3, IO::SEEK_END)
csstail = appcss_file.read
appcss_file.seek(-3, IO::SEEK_END)
appcss_file.write("*= require bootstrap.min\n" + csstail)
appcss_file.close
