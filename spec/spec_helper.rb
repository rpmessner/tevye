# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'rails/mongoid'
require 'factory_girl'
require 'database_cleaner'

# Requires support files used in locomotive engine tests
Dir[Rails.root.join("vendor/gems/engine/spec/support/**/*.rb")].each {|f| require f}

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include(Spec::Helpers)
  config.include(Locomotive::RSpec::Matchers)

  config.mock_with :mocha

  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    Locomotive.configure_for_test(true)
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end

  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.before(:each) do
    Mongoid::IdentityMap.clear
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end
