require File.expand_path("../../../config/environment", __FILE__)
require 'locomotive/mounter'
require 'rails/commands/server'

namespace :fixtures do
  desc 'sets up database and exports as set of fixtures'
  task :export do
    cleanup do
      path = Rails.root.join 'test', 'fixtures', 'site'
      import_locomotive_site(path)
      site = Locomotive::Site.first
      path = Rails.root.join(OUTPUT_PATH, 'fixtures.js')
      render_fixtures_to_file(path, site: site)
    end
  end

  OUTPUT_PATH = 'test/javascripts/helpers'
  INPUT_PATH  = 'test/fixtures'
  ENDPOINT    = '0.0.0.0:3000/locomotive/api'

  ACCOUNT_ATTRIBUTES = {
    name:     'Admin',
    email:    'admin@locomotivecms.com',
    password: 'locomotive' }

  SITE_ATTRIBUTES = {
    name:      'LocomotiveCMS',
    domains:   %w(www.example.com),
    subdomain: 'locomotive' }

  CREDENTIALS = ACCOUNT_ATTRIBUTES.merge(uri: ENDPOINT).tap {|c| c.delete(:name)}

  def import_locomotive_site(path)
    initialize_empty_site
    start_server do
      mounting = mounting_point(path)
      write_site_to_server(mounting)
    end
  end

  def write_site_to_server(mounting)
    Locomotive::Mounter::EngineApi.set_token CREDENTIALS
    Locomotive::Mounter::Writer::Api.instance.run!({
      mounting_point: mounting,
      console:        false,
      data:           true,
      force:          true
    }.merge(CREDENTIALS))
  end

  def start_server
    server     = Rails::Server.new
    server.options[:server] = nil
    server_pid = fork { server.start }
    sleep 3
    yield if block_given?
    Process.kill(:INT, server_pid)
  end

  def initialize_empty_site
    Locomotive::Site.create(SITE_ATTRIBUTES) do |site|
      account = Locomotive::Account.create!(ACCOUNT_ATTRIBUTES)
      site.memberships.build account: account, role: 'admin'
    end.tap &:save!
  end

  def mounting_point(path)
    reader = Locomotive::Mounter::Reader::FileSystem.instance
    reader.run!(path: path)
  end

  def render_fixtures_to_file(path, assigns)
    template = Template.new Rails.root.join(INPUT_PATH)
    template.assign(assigns)
    file     = File.new(path, 'w')
    file.puts template.render(template: 'fixtures.coffee.erb')
    file.close
  end

  def cleanup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm      = 'mongoid'

    Mongoid::IdentityMap.clear

    DatabaseCleaner.start
    Mongoid.purge!

    yield if block_given?

    DatabaseCleaner.clean
  end

  class Template < ActionView::Base
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::TagHelper

    def render(*args)
      super(*args).gsub '\#{', '#{'
    end

    def render_json(root, object, overrides=nil)
      dump =
        case
        when object.kind_of?(Array)
          object.map {|obj| serialize_object(root, obj)}
        when object.kind_of?(Mongoid::Document)
          serialize_object(root, object).merge(overrides || {})
        else
          object
        end
      raw("\"#{escape_json MultiJson.dump({ root.to_s => dump })}\"")
    end

    private

    JSON_ESCAPE_MAP = {
      '\\'   => '\\\\',
      '</'   => '<\/',
      "\r\n" => '\n',
      "\n"   => '\n',
      '#{{'  => '#\{{',
      "\r"   => '\n',
      '"'    => '\\"' }

    def escape_json(json)
      json.gsub(/(#\{{|\\|<\/|\r\n|[\n\r"])/) { JSON_ESCAPE_MAP[$1] }
    end

    def serialize_object(root, obj)
      if obj.kind_of?(Mongoid::Document)
        serializer_class(root).new(obj).as_json(root: false)
      else
        obj
      end
    end

    def serializer_class(root)
      "Tevye::#{root.to_s.singularize.camelize}Serializer".constantize
    end
  end
end

module Sass::Rails::Helpers
  def resolver
    Sass::Rails::Resolver.new(CompassRails.context)
  end
end
