# == Schema Information
#
# Table name: artwork_hashtags
#
#  id         :integer          not null, primary key
#  artwork_id :bigint           not null
#  hashtag_id :integer          not null
#
# Indexes
#
#  index_artwork_hashtags_on_artwork_id_and_hashtag_id  (artwork_id,hashtag_id) UNIQUE
#
class ArtworkHashtag < ApplicationRecord
  belongs_to :artwork
  belongs_to :hashtag
end
