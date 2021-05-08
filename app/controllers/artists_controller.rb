class ArtistsController < ApplicationController
  def show
    @artist = Artist.find_by(screen_name: params[:screen_name])
    if @artist.present?
      CollectArtistWorker.perform_async(params[:screen_name]) # Jobに依頼
      # TODO: 何分か以内にデータ取得した場合は、動かさない
    else
      CollectArtistWorker.new.perform(params[:screen_name]) # 初回はその場で取得
      # TODO: 直近200件しか取得しない
      @artist = Artist.find_by!(screen_name: params[:screen_name])
    end
    @artworks = @artist.artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
    @like_artworks = @artist.favorite_artworks.order(favorite_count: :desc).preload(:hashtags, :artist)
    @like_artists = @artist.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(20).map {|a| [a.artist, a.artist_count]}
  end
end
