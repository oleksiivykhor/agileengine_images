# frozen_string_literal: true

module Agileengine
  class Client
    def images(page = 1)
      body = {}
      with_authentication do
        response = get("/images?page=#{page}")
        body = JSON.parse(response.body, symbolize_names: true)
      end

      body
    end

    def image(image_id)
      body = {}
      with_authentication do
        response = get("/images/#{image_id}")
        body = JSON.parse(response.body, symbolize_names: true)
      end

      body
    end

    def get(endpoint)
      connection.headers[:authorization] = "Bearer #{token}"
      response = connection.get(endpoint)
      raise UnauthorizedError, response.body if response.status == 401

      response
    end

    private

    def with_authentication(attempts = 3)
      raise UnauthorizedError unless token

      yield
    rescue UnauthorizedError => e
      raise e if attempts.zero?

      authenticate
      with_authentication(attempts - 1) { yield }
    end

    def token
      redis.get(:auth_token)
    end

    def authenticate
      response = connection.post('/auth', { apiKey: ENV['API_KEY'] }.to_json)
      body = JSON.parse(response.body, symbolize_names: true)
      redis.set(:auth_token, body[:token])
    end

    def connection
      @connection ||= Faraday.new('http://interview.agileengine.com', headers: { content_type: 'application/json' })
    end

    def redis
      @redis ||= Redis.current
    end
  end
end
