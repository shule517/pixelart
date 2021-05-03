class HomeController < ApplicationController
  def index
    @artworks = Artwork.where(lang: 'ja').order(favorite_count: :desc).first(20)
  end
end
