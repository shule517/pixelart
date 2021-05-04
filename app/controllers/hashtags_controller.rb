class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all.joins(:artworks).group(:id).select("hashtags.name, count(artwork_id) as artwork_count").order("artwork_count desc")
  end

  def show
    @hashtag = Hashtag.find_by!(name: params[:id])
    @artworks = @hashtag.artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
  end
end
