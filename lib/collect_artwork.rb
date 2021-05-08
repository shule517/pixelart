class CollectArtwork
  def initialize(screen_name)
    @screen_name = screen_name
    @client = TwitterClient.pixel.client
  end

  def exec
    return if collect_limited?
    collect_artworks!
  end

  private

  def collect_limited?
    # 収集は、1時間に1回まで
    artist = Artist.find_by(screen_name: @screen_name)
    return false if artist.blank?

    (Time.zone.now - 1.hour) < artist.tweet_collected_at
  end

  def collect_artworks!(max_id: nil)
    tweets = nil
    ActiveRecord::Base.transaction do
      tweets = user_tweets(max_id: max_id)
      puts "max_id: #{max_id} -> #{tweets.first&.id} - #{tweets.last&.id}"

      if tweets.blank?
        # 一番古いツイートまで収集完了！
        artist = Artist.find_by(screen_name: @screen_name)
        artist&.update!(oldest_tweet_collected: true)
        return
      end

      select_artworks(tweets).each do |artwork|
        artwork = Artwork.create_from_tweet!(artwork)
        artist = artwork.artist
        if artist.collect_tweet_latest_id.blank? || artist.collect_tweet_latest_id < tweets.first.id
          artist.collect_tweet_latest_id = tweets.first.id
        end
        artist.collect_tweet_oldest_id = tweets.last.id
        artist.tweet_collected_at = Time.zone.now
        artist.save!
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
end
