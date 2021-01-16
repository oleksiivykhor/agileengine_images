# frozen_string_literal: true

class PopulateImagesWorker
  include Sidekiq::Worker

  def perform
    client = Agileengine::Client.new
    redis = Redis.current
    redis.del(:images)
    has_more = true
    page = 1
    while has_more do
      body = client.images(page)
      body[:pictures].each do |picture|
        PopulateImageWorker.perform_async(picture[:id])
      end
      has_more = body[:hasMore]
      page = body[:page].to_i + 1
    end
  end
end
