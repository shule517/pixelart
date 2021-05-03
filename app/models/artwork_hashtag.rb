# == Schema Information
#
# Table name: artwork_hashtags
#
#  id         :integer          not null, primary key
#  artwork_id :integer          not null
#  hashtag_id :integer          not null
#
class ArtworkHashtag < ApplicationRecord
  belongs_to :artwork
  belongs_to :hashtag
end
