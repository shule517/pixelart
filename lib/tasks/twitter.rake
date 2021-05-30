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

  desc 'はるのTwitter情報を取得'
  task search_artworks_from_hal: :environment do
    CollectArtistWorker.perform_async('pixel_hal')
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
      artist = hal.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").sample.artist

      value = rand
      if value <= 0.1
        # 10%(安定&挑戦): 直近3日間のTOP絵
        artworks = Artwork.where('? < posted_at', (Time.zone.now - 3.days)).where(lang: :ja)

        # if rand(1) == 0
        #   # 今日のTOP絵
        #   artworks = Artwork.where('? < posted_at', (Time.zone.now - 1.day)).where(lang: :ja)
        # else
        #   # 今週のTOP絵
        #   artworks = Artwork.where('? < posted_at', (Time.zone.today - 1.week)).where(lang: :ja)
        # end
        # TODO: indie_animeの人気ドット絵
      elsif value <= 0.2
        # 10%(挑戦): 意外なおすすめをRT
        # 海外の人気ドット絵
        artworks = Artwork.where(lang: :en)

        # if rand(1) == 0
        #   # 海外の人気ドット絵
        #   artworks = Artwork.where(lang: :en)
        # else
        #   # 日本の人気ドット絵
        #   artworks = Artwork.where(lang: :ja)
        # end
      elsif value <= 0.4
        # 20%(安定): お気に入りアーティスト の 人気のドット絵をRT
        artworks = artist.artworks.where(lang: :ja)
      else
        # 60%(まあ安定): お気に入りアーティスト の いいねしたドット絵をRT
        artworks = artist.favorite_artworks.where(lang: :ja)
      end

      artwork = artworks.where.not(id: hal.favorite_artworks).where(pixel_retweeted: false).order(favorite_count: :desc).first

      next if artwork.blank?
      TwitterClient.pixel.client.retweet(artwork.id)
      artwork.update!(pixel_retweeted: true)
    end

    # 20.times.each do
    #   # pixel_halがいいねしたアーティストが好きな作品をRTしていく
    #   hal = Artist.find_by!(screen_name: :pixel_hal)
    #   artist = hal.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(10).map(&:artist).sample
    #
    #   if rand(9) <= 1
    #     # お気に入りアーティスト の 人気のドット絵をRT
    #     artwork = artist.artworks.where(pixel_retweeted: false).order(favorite_count: :desc).first
    #   else
    #     # お気に入りアーティスト の いいねしたドット絵をRT
    #     artwork = artist.favorite_artworks.where(pixel_retweeted: false).first
    #   end
    #
    #   next if artwork.blank?
    #   TwitterClient.pixel.client.retweet(artwork.id)
    #   artwork.update!(pixel_retweeted: true)
    # end
  end
end
