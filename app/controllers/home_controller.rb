class HomeController < ApplicationController
  def index
    @artworks = Artwork.order(favorite_count: :desc).first(20)
  end
end
