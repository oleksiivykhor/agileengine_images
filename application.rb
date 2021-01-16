# frozen_string_literal: true

require 'dotenv/load'
require 'grape'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'faraday'

Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/services/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/exceptions/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/workers/**/*.rb"].each { |f| require f }

Application = Rack::Builder.new do
  map '/' do
    run Images::API
  end

  map '/sidekiq' do
    run Sidekiq::Web
  end
end
