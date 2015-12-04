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

app_layout = File.read('/Users/zhangchao/github/mysource/ruby/application.html.erb')
app_layout.sub!('APP_NAME', app_name())
File.write('app/views/layouts/application.html.erb', app_layout)

devise_layout = File.read('/Users/zhangchao/github/mysource/ruby/devise.html.erb')
devise_layout.sub!('APP_NAME', app_name())
File.write('app/views/layouts/devise.html.erb', devise_layout)

File.write('app/views/index/index.html.erb', '<h1>Perfect!<h1>')

File.write('.gitignore', File.read('/Users/zhangchao/github/mysource/ruby/rails.gitignore'))
