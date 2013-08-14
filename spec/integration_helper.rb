ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/firebug'
require 'factory_girl'
require 'database_cleaner'

# Requires support files used in locomotive engine tests
Dir[Rails.root.join("vendor/gems/engine/spec/support/**/*.rb")].each {|f| require f}

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

module CapybaraHelpers
  def wait_for(&test)
    start = Time.now
    while true
      break if test.call
      if Time.now > start + 5.seconds
        fail "Timeout waiting for something happen."
      end
      sleep 0.1
    end
  end
end

def ensure_host_resolution(app_host)
  hosts = Resolv::Hosts.new
  app_host_name = URI.parse(app_host).host
  begin
    hosts.getaddress(app_host_name)
  rescue Resolv::ResolvError
    raise "Unable to resolve ip address for #{app_host_name}. " +
          "Please consider adding an entry to '/etc/hosts' " +
          "that associates #{app_host_name} with '127.0.0.1'."
  end
end

CarrierWave.configure do |config|
  config.root = Rails.root.join('public', 'integration')
end

Capybara.configure do |config|
  config.ignore_hidden_elements = false

  config.default_selector   = :css
  config.server_port        = 9886
  config.app_host           = 'http://test.example.com:9886'

  ensure_host_resolution config.app_host
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include CapybaraHelpers, type: :request

  config.include Warden::Test::Helpers
  Warden.test_mode!

  config.before(:suite) do
    Locomotive.configure_for_test(true)
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
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
