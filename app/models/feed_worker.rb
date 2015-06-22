require 'sidekiq'
require 'open-uri'
require 'logger'


# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"], :namespace => 'souly4good', :size => 1 }
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"], :namespace => 'souly4good' }
end


class FeedWorker
  include Sidekiq::Worker

  def perform()


  end
end