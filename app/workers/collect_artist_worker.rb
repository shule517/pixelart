class CollectArtistWorker
  include Sidekiq::Worker

  def perform(screen_name)
    # TODO: Userのmax_id / since_id
    # Userの最終チェック日時を保存して、何時間以内は収集しないなどをする
    # → Hashタグにも対応する

    # アーティストの作品を収集
    TwitterUserTweet.new(screen_name).collect_artworks!

    # アーティストがいいねした作品を収集
    artist = Artist.find_by(screen_name: screen_name)
    return if artist.blank?

    like_artworks = TwitterUserTweet.new(screen_name).like_artworks
    like_artworks.each do |artwork|
      artwork = Artwork.create_from_tweet!(artwork)
      Favorite.find_or_create_by!(artist: artist, artwork: artwork)
    end
  end

  private

  # TODO: 不要なら消す
  # def collect_artworks(screen_name)
  #   max_id = nil
  #   ActiveRecord::Base.transaction do
  #     artworks, first_tweet_id, last_tweet_id = TwitterUserTweet.new(screen_name).user_artworks(max_id: max_id)
  #     max_id = last_tweet_id
  #     artworks.each do |artwork|
  #       artwork = Artwork.create_from_tweet!(artwork)
  #       artwork.artist.update!(collect_tweet_oldest_id: last_tweet_id)
  #     end
  #     # statuses/user_timeline.jsonは、1秒間に1回まで
  #     sleep(1)
  #   end
  # end
end
