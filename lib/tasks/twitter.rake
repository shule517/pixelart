namespace :twitter do
  desc 'ドット絵をTwitterから検索する'
  task search: :environment do
    %w(#pixelart #ドット絵 #ドットピクト #dotpict #10分ドット #픽셀아트).each do |query|
      puts query
      pixelart_artworks = TwitterUserTweet.new(nil).pixelart_artworks(query)
      pixelart_artworks.each do |artwork|
        Artwork.create_from_tweet!(artwork)
      end

      anime_query = "#indie_anime #{query}"
      puts anime_query
      pixelart_artworks = TwitterUserTweet.new(nil).pixelart_artworks(anime_query)
      pixelart_artworks.each do |artwork|
        Artwork.create_from_tweet!(artwork)
      end
    end
  end

  desc 'ユーザーの作品情報を取得'
  task search_artworks_from_artits: :environment do
    # 1並列で順番に処理をしていく
    Artist.all.each do |artist|
      CollectArtistWorker.perform_async(artist.screen_name)
    end
  end
end
