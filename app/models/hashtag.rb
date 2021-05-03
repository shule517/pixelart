# == Schema Information
#
# Table name: hashtags
#
#  id   :integer          not null, primary key
#  name :string           not null
#
# Indexes
#
#  index_hashtags_on_name  (name) UNIQUE
#
class Hashtag < ApplicationRecord
  has_many :artwork_hashtags
  has_many :artworks, through: :artwork_hashtags
end
