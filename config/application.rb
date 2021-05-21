require_relative 'boot'
require 'rails/all'
require 'openssl'
require 'base64'
require 'net/http/post/multipart'
require 'irb'
require 'json'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TangoLibrary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.assets.paths << Rails.root.join('app', 'assets', 'img')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += %W[#{config.root}/lib]

    config.active_job.queue_adapter = :sidekiq
  end
end
