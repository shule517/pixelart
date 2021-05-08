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

  desc 'おすすめ作品をRTする'
  task rt: :environment do

    # pixel_halがいいねしたアーティストが好きな作品をRTしていく
    hal = Artist.find_by!(screen_name: :pixel_hal)
    artist = hal.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(10).map(&:artist).sample
    artwork = artist.favorite_artworks.where(pixel_retweeted: false).first

    return if artwork.blank?
    TwitterClient.pixel.client.retweet(artwork.id)
    artwork.update!(pixel_retweeted: true)

    # TODO: シュールが好きなドット絵を流す
    # 8割: 絶対好きなやつ
    # 6 いいねしたアーティストが好きな作品
    # 1 いいねしたアーティストの最新作品
    # 1 #indie_animeの人気作品
    # 1 #dotpictの人気作品
    #
    # 1割
    # 0.5 jaの人気な作品
    # 0.5 enの人気な作品
  end

  desc 'おすすめ作品をRTする'
  task rt_test: :environment do
    20.times.each do
      # pixel_halがいいねしたアーティストが好きな作品をRTしていく
      hal = Artist.find_by!(screen_name: :pixel_hal)
      artist = hal.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(10).map(&:artist).sample

      if rand(9) <= 7
        # 人気のドット絵をRT
        artwork = artist.artworks.where(pixel_retweeted: false).order(favorite_count: :desc).first
      else
        # いいねしたドット絵をRT
        artwork = artist.favorite_artworks.where(pixel_retweeted: false).first
      end

      return if artwork.blank?
      TwitterClient.pixel.client.retweet(artwork.id)
      artwork.update!(pixel_retweeted: true)
    end
  end
end
