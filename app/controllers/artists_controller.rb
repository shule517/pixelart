class ArtistsController < ApplicationController
  def show
    @artist = Artist.find_by(screen_name: params[:screen_name])
    if @artist.present?
      CollectArtistWorker.perform_async(params[:screen_name]) # Jobに依頼
    else
      CollectArtistWorker.new.perform(params[:screen_name]) # 初回はその場で取得
      @artist = Artist.find_by!(screen_name: params[:screen_name])
    end
    @artworks = @artist.artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
    @like_artworks = @artist.favorite_artworks.order(favorite_count: :desc).preload(:hashtags, :artist)
  end
end
