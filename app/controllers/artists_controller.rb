class ArtistsController < ApplicationController
  def show
    CollectArtistWorker.perform_async(params[:screen_name])

    # TODO いいねをDB保存する
    like_artworks = TwitterUserTweet.new(params[:screen_name]).like_artworks.sort_by {|artwork| artwork.favorite_count }.reverse
    like_artworks.each do |artwork|
      Artwork.create_from_tweet!(artwork)
    end
    # TODO JOB化する

    @artist = Artist.find_by!(screen_name: params[:screen_name])
    @artworks = @artist.artworks.order(favorite_count: :desc).limit(20).preload(:hashtags, :artist)
    @like_artworks = Artwork.where(id: like_artworks.map(&:id)).order(favorite_count: :desc).preload(:hashtags, :artist)
  end
end
