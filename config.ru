# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/cron'
require File.expand_path('../application', __FILE__)

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq::Cron::Job.load_from_hash(YAML.load_file('config/schedule.yml'))

run Application
PopulateImagesWorker.perform_async
