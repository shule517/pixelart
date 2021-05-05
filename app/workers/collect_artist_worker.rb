class CollectArtistWorker
  include Sidekiq::Worker

  def perform(screen_name)
    # TODO: Userのmax_id / since_id
    # Userの最終チェック日時を保存して、何時間以内は収集しないなどをする
    # → Hashタグにも対応する

    # アーティストの作品を収集
    artworks = TwitterUserTweet.new(screen_name).user_artworks
    artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end

    # アーティストがいいねした作品を収集
    artist = Artist.find_by(screen_name: screen_name)
    return if artist.blank?

    like_artworks = TwitterUserTweet.new(screen_name).like_artworks
    like_artworks.each do |artwork|
      artwork = Artwork.create_from_tweet!(artwork)
      Favorite.find_or_create_by!(artist: artist, artwork: artwork)
    end
  end
end
