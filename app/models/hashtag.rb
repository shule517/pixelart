# == Schema Information
#
# Table name: hashtags
#
#  id    :integer          not null, primary key
#  title :string           not null
#
# Indexes
#
#  index_hashtags_on_title  (title) UNIQUE
#
class Hashtag < ApplicationRecord
end
