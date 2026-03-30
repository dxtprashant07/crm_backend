require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module CrmApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.api_only = true

    config.autoload_lib(ignore: %w[assets tasks])
    config.time_zone = "UTC"
  end
end
