namespace :twitter do
  desc "ドット絵をTwitterから検索する"
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
end
