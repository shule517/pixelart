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

  # TODO: CollectArtworkクラスを切り出す
  def collect_artworks!(max_id: nil)
    tweets = nil
    ActiveRecord::Base.transaction do
      tweets = user_tweets(max_id: max_id)
      puts "max_id: #{max_id} -> #{tweets.first&.id} - #{tweets.last&.id}"
      return if tweets.blank?

      select_artworks(tweets).each do |artwork|
        artwork = Artwork.create_from_tweet!(artwork)
        artwork.artist.update!(collect_tweet_oldest_id: tweets.last.id)
      end
      # statuses/user_timeline.jsonは、1秒間に1回まで
      sleep(1)
    end

    collect_artworks!(max_id: tweets.last.id)
  end

  def select_artworks(tweets)
    artworks = tweets
                 .select { |tweet| !tweet.retweeted_tweet? && !tweet.user_mentions? }
                 .select { |tweet| tweet.media.present? }
                 .select do |tweet|
      tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
    end
    artworks
  end

  # TODO: 不要なら消す
  # def user_artworks(since_id: nil, max_id: nil)
  #   tweets = user_tweets(since_id: since_id, max_id: max_id)
  #   artworks = tweets
  #     .select { |tweet| !tweet.retweeted_tweet? && !tweet.user_mentions? }
  #     .select { |tweet| tweet.media.present? }
  #     .select do |tweet|
  #       tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
  #   end
  #   [artworks, tweets.first&.id, tweets.last&.id]
  # end

  def user_tweets(since_id: nil, max_id: nil)
    params = { count: 200 }
    params[:since_id] = since_id if since_id.present?
    params[:max_id] = max_id if max_id.present?
    tweets = @client.user_timeline(@screen_name, params)
    if max_id.present?
      tweets = tweets.drop(1) # max_idを指定した場合、先頭の1つは前回取得したものと同じためスキップする
    end
    tweets
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

  def pixelart_artworks(query)
    tweets = pixelart_tweets(query)
      .map { |tweet| tweet.retweeted_tweet? ? tweet.retweeted_tweet : tweet }
      .select { |tweet| tweet.media.present? }
      .select do |tweet|
        tweet.hashtags.map(&:text).any? { |hashtag| %w(pixelart ドット絵 ドットピクト dotpict 10分ドット).include?(hashtag) }
      end
    tweets
  end

  def pixelart_tweets(query)
    @client.search(query, result_type: :recent).first(500)
  end
end
