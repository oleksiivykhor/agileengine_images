# frozen_string_literal: true

class PopulateImageWorker
  include Sidekiq::Worker

  def perform(image_id)
    client = Agileengine::Client.new
    redis = Redis.current
    image = client.image(image_id)
    images = JSON.parse(redis.get(:images) || [].to_json)
    images << image
    redis.set(:images, images.to_json)
  end
end
