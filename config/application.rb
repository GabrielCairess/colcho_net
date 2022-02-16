require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module ColchoNet
  class Application < Rails::Application
    config.load_defaults 7.0

    config.i18n.default_locale = :'pt-BR'
    config.time_zone = 'Brasilia'

    config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
  end
end
