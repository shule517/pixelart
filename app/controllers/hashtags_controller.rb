class HashtagsController < ApplicationController
  def show
    @hashtag = Hashtag.find_by(name: params[:id])
    @artworks = @hashtag.artworks.sort_by { |artwork| artwork.favorite_count }.reverse.first(20)
  end
end
