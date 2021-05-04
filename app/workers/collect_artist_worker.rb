class CollectArtistWorker
  include Sidekiq::Worker

  def perform(screen_name)
    # Userのmax_id / since_id
    # Userの最終チェック日時を保存して、何時間以内は収集しないなどをする
    # → Hashタグにも対応する
    artworks = TwitterUserTweet.new(screen_name).user_artworks#.sort_by {|artwork| artwork.favorite_count }.reverse.first(5)
    artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
  end
end
