require_relative 'boot'

require 'rails/all'
require 'csv'
require 'Gmail'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Emailer
  class Application < Rails::Application

    config.load_defaults 5.1
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq
  end
end
