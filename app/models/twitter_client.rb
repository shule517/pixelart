class TwitterClient
  attr_reader :client

  class << self
    def shule
      TwitterClient.new(consumer_key:        ENV['SHULE_TWITTER_CONSUMER_KEY'],
                        consumer_secret:     ENV['SHULE_TWITTER_CONSUMER_SECRET'],
                        access_token:        ENV['SHULE_TWITTER_ACCESS_TOKEN'],
                        access_token_secret: ENV['SHULE_TWITTER_ACCESS_TOKEN_SECRET'])
    end

    def pixel
      TwitterClient.new(consumer_key:        ENV['PIXEL_TWITTER_CONSUMER_KEY'],
                        consumer_secret:     ENV['PIXEL_TWITTER_CONSUMER_SECRET'],
                        access_token:        ENV['PIXEL_TWITTER_ACCESS_TOKEN'],
                        access_token_secret: ENV['PIXEL_TWITTER_ACCESS_TOKEN_SECRET'])
    end
  end

  def initialize(consumer_key:, consumer_secret:, access_token:, access_token_secret:)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end
end
