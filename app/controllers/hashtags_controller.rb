class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all.joins(:artworks).group(:hashtag_id).order("count(artwork_id) desc")
  end

  def show
    @hashtag = Hashtag.find_by(name: params[:id])
    @artworks = @hashtag.artworks.sort_by { |artwork| artwork.favorite_count }.reverse.first(20)
  end
end
