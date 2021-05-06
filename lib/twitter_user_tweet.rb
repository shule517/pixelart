class TwitterUserTweet
  def initialize(screen_name)
    @screen_name = screen_name
    @client = TwitterClient.pixel.client
  end

  def like_artworks
    user_likes
      .select { |tweet| !tweet.retweeted_tweet? && !tweet.user_mentions? }
      .select { |tweet| tweet.media.present? }
      .select do |tweet|
        tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
      end
  end

  def pixelart_artworks(query)
    tweets = pixelart_tweets(query)
      .map { |tweet| tweet.retweeted_tweet? ? tweet.retweeted_tweet : tweet }
      .select { |tweet| tweet.media.present? }
      .select do |tweet|
        tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
      end
    tweets
  end

  private

  def user_likes
    @client.favorites(@screen_name, count: 200)
  end

  def pixelart_tweets(query)
    @client.search(query, result_type: :recent).first(500)
  end
end
