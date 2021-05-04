class ArtistsController < ApplicationController
  def show
    artworks = TwitterUserTweet.new(params[:screen_name]).user_artworks.sort_by {|artwork| artwork.favorite_count }.reverse.first(5)
    @like_artworks = TwitterUserTweet.new(params[:screen_name]).like_artworks.sort_by {|artwork| artwork.favorite_count }.reverse

    # TODO
    artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
    @like_artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
    # TODO

    @artist = Artist.find_by!(screen_name: params[:screen_name])
    @artworks = @artist.artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
  end
end
