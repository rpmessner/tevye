source 'https://rubygems.org'

gem 'rails', '3.2.13'

group :production do
  # gem 'locomotive_cms', '~> 2.0.1'
end

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'compass-rails'
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails',
                              git: 'git://github.com/anjlab/bootstrap-rails.git',
                              branch: '3.0.0'
gem 'ember-rails'
gem 'ember-source', '1.0.0.rc5'
gem 'handlebars-source', '1.0.0.rc4'
gem 'emblem-source'
gem 'slim-rails'
gem 'active_model_serializers'

group :development, :test do
  gem 'susy'
  gem 'locomotivecms_mounter', path: 'vendor/gems/mounter'
  gem 'locomotive_cms', path: 'vendor/gems/engine'
  gem 'zeus'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rspec-rails'
  gem 'rspec-cells'
  gem 'mocha', '~> 0.13.0', require: false
  gem 'cucumber-rails', require: false
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'database_cleaner'
  gem 'qunit-rails'
  gem 'unicorn'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
end
