require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module HealthcareRubyOe41
  class Application < Rails::Application
    config.load_defaults 6.1

    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
  end
end
