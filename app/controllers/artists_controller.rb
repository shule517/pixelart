class ArtistsController < ApplicationController
  def show
    @artworks = TwitterUserTweet.new(params[:screen_name]).user_artworks.sort_by {|artwork| artwork.favorite_count }.reverse.first(5)
    @like_artworks = TwitterUserTweet.new(params[:screen_name]).like_artworks.sort_by {|artwork| artwork.favorite_count }.reverse

    # TODO
    @artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
    @like_artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
    # TODO
  end
end
