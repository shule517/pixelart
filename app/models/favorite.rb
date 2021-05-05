# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  artist_id  :bigint           not null
#  artwork_id :bigint           not null
#
# Indexes
#
#  index_favorites_on_artist_id_and_artwork_id  (artist_id,artwork_id) UNIQUE
#
class Favorite < ApplicationRecord
  belongs_to :artist
  belongs_to :artwork
end
