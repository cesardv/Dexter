require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

# Auto-require default libraries and those for the current Rails environment. 
Bundler.require :default, Rails.env


if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Dexter
  class Application < Rails::Application
    # application specific requires
    require 'url_validator'

    # rails configuration
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.threadsafe!
  end
end
