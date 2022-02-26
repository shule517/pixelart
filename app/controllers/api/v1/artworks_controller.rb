class Api::V1::ArtworksController < ApplicationController
  def index
    if params['artist_id'].present?
      # http://pixel-museum.herokuapp.com/api/v1/artists/yuki77mi/artworks
      artist_artworks_index
    else
      # http://pixel-museum.herokuapp.com/api/v1/artworks
      artworks_index
    end
  end

  private

  def artist_artworks_index
    @artist = Artist.find_by(screen_name: params['artist_id'])

    @artworks = @artist.artworks.photo.limit(15)
    @like_artworks = @artist.favorite_artworks.photo.limit(15)

    if param_order == :favorite_count
      @artworks = @artworks.order(favorite_count: :desc)
      @like_artworks = @like_artworks.order(favorite_count: :desc)
    elsif param_order == :posted_at
      @artworks = @artworks.order(posted_at: :desc)
      @like_artworks = @like_artworks.order(posted_at: :desc)
    end

    @like_artists = @artist.favorite_artworks.group(:artist_id).select("artworks.artist_id, count(artworks.artist_id) as artist_count").order("artist_count desc").limit(3).map(&:artist)

    render json: {
      artist: @artist,
      artworks: @artworks.map { |artwork| { artwork: artwork, artist: artwork.artist } },
      like_artwokrs: @like_artworks.map { |artwork| { artwork: artwork, artist: artwork.artist } },
      like_artists: @like_artists.map { |artist| { artist: artist, artwork: artist.most_popular_photo_artwork } },
    }
  end

  def artworks_index
    @artworks = Artwork.photo.order(posted_at: :desc).limit(15)

    render json: {
      artworks: @artworks.map { |artwork| { artwork: artwork, artist: artwork.artist } },
    }
  end

  def param_order
    (params['order'].presence || :posted_at).to_sym
  end
end
