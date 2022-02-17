class Api::V1::ArtworksController < ApplicationController
  def index
    @artist = Artist.find_by(screen_name: params['artist_id'])
    @artworks = @artist.artworks.photo.order(favorite_count: :desc).limit(15)
    @like_artworks = @artist.favorite_artworks.photo.order(favorite_count: :desc).limit(15)
    @like_artists = @artist.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(3).map(&:artist)

    render json: {
      artist: @artist,
      artworks: @artworks.map { |artwork| { artwork: artwork, artist: artwork.artist } },
      like_artwokrs: @like_artworks.map { |artwork| { artwork: artwork, artist: artwork.artist } },
      like_artists: @like_artists.map { |artist| { artist: artist, artwork: artist.most_popular_photo_artwork } },
    }
  end
end
