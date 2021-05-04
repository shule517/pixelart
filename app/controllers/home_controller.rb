class HomeController < ApplicationController
  def index
    @artworks = Artwork.all
    @artworks = @artworks.where(lang: params[:lang]) if params[:lang].present?
    @artworks = @artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
  end
end
