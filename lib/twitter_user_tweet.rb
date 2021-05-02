class TwitterUserTweet
  def initialize(screen_name)
    @screen_name = screen_name
    @client = TwitterClient.pixel.client
  end

  def exec
    tweets = @client.user_tweets(@screen_name)

    # if tweet.retweeted_tweet?
    #   # RTの場合
    #   tweet.retweeted_tweet を Artに登録する
    #   userのretweetに tweet.retweeted_tweet を登録する
    # elsif tweet.user_mentions? && !tweet.retweeted_tweet?
    #   # メンションの場合
    #
    # else
    #   # 自分の投稿の場合
    #   tweet を Artに登録する
    # end
  end

  def user_artworks
    user_tweets
      .select { |tweet| !tweet.retweeted_tweet? && !tweet.user_mentions? }
      .select { |tweet| tweet.media.present? }
      .select do |tweet|
        tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
      end
  end

  def user_tweets
    @client.user_timeline(@screen_name, count: 200)
  end

  def like_artworks
    user_likes
      .select { |tweet| !tweet.retweeted_tweet? && !tweet.user_mentions? }
      .select { |tweet| tweet.media.present? }
      .select do |tweet|
      tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
    end
  end

  def user_likes
    @client.favorites(@screen_name, count: 200)
  end
end
