# == Schema Information
#
# Table name: artists
#
#  id                           :integer          not null, primary key
#  contributors_enabled         :boolean          not null
#  default_profile              :boolean          not null
#  default_profile_image        :boolean          not null
#  description                  :string
#  favourites_count             :integer          not null
#  followers_count              :integer          not null
#  friends_count                :integer          not null
#  geo_enabled                  :boolean          not null
#  is_translation_enabled       :boolean          not null
#  is_translator                :boolean          not null
#  lang                         :string
#  listed_count                 :integer          not null
#  location                     :string
#  name                         :string           not null
#  oldest_tweet_collected       :bigint           default(0), not null
#  profile_background_color     :string           not null
#  profile_background_image_url :string
#  profile_background_tile      :boolean          not null
#  profile_banner_url           :string
#  profile_image_url            :string           not null
#  profile_link_color           :string           not null
#  profile_sidebar_border_color :string           not null
#  profile_sidebar_fill_color   :string           not null
#  profile_text_color           :string           not null
#  profile_use_background_image :boolean          not null
#  protected                    :boolean          not null
#  registerd_at                 :datetime         not null
#  screen_name                  :string           not null
#  statuses_count               :integer          not null
#  time_zone                    :string
#  tweet_collected_at           :datetime
#  url                          :string           not null
#  utc_offset                   :string
#  verified                     :boolean          not null
#  collect_tweet_latest_id      :integer
#  collect_tweet_oldest_id      :integer
#
# Indexes
#
#  index_artists_on_lang         (lang)
#  index_artists_on_screen_name  (screen_name) UNIQUE
#
class Artist < ApplicationRecord
  has_many :artworks
  has_many :favorites
  has_many :favorite_artworks, through: :favorites, source: :artwork
  has_many :favorite_artists, through: :favorite_artworks, source: :artist

  def most_popular_artwork
    artworks.order(favorite_count: :desc).first
  end

  def most_popular_photo_artwork
    artworks.photo.order(favorite_count: :desc).first
  end

  def self.create_from_user!(twitter_user)
    artist = find_or_initialize_by(id: twitter_user.id)

    artist.assign_attributes(
      name: twitter_user.name,
      screen_name: twitter_user.screen_name,
      location: twitter_user.location,
      description: twitter_user.description,
      url: twitter_user.url,
      protected: twitter_user.protected?,
      followers_count: twitter_user.followers_count,
      friends_count: twitter_user.friends_count,
      listed_count: twitter_user.listed_count,
      registerd_at: twitter_user.created_at,
      favourites_count: twitter_user.favourites_count,
      utc_offset: twitter_user.utc_offset,
      time_zone: twitter_user.time_zone,
      geo_enabled: twitter_user.geo_enabled?,
      verified: twitter_user.verified?,
      statuses_count: twitter_user.statuses_count,
      lang: twitter_user.lang,
      contributors_enabled: twitter_user.contributors_enabled?,
      is_translator: twitter_user.translator?,
      is_translation_enabled: twitter_user.translation_enabled?,
      profile_background_color: twitter_user.profile_background_color,
      profile_background_image_url: twitter_user.profile_background_image_url_https,
      # profile_background_image_url_https: twitter_user.profile_background_image_url_https,
      profile_background_tile: twitter_user.profile_background_tile?,
      profile_image_url: twitter_user.profile_image_url_https,
      # profile_image_url_https: twitter_user.profile_image_url_https,
      profile_banner_url: twitter_user&.to_h[:profile_banner_url],
      profile_link_color: twitter_user.profile_link_color,
      profile_sidebar_border_color: twitter_user.profile_sidebar_border_color,
      profile_sidebar_fill_color: twitter_user.profile_sidebar_fill_color,
      profile_text_color: twitter_user.profile_text_color,
      profile_use_background_image: twitter_user.profile_use_background_image?,
      # has_extended_profile: twitter_user.has_extended_profile?,
      default_profile: twitter_user.default_profile?,
      default_profile_image: twitter_user.default_profile_image?
    )
    artist.save!

    artist

    # artist.assign_attributes(
    #   posted_at: tweet.created_at,
    #   text: tweet.text,
    #   url: tweet.url,
    #   truncated: tweet.truncated?,
    #   source: tweet.source,
    #   in_reply_to_status_id: tweet.in_reply_to_status_id,
    #   in_reply_to_user_id: tweet.in_reply_to_user_id,
    #   in_reply_to_screen_name: tweet.in_reply_to_screen_name,
    #   retweet_count: tweet.retweet_count,
    #   favorite_count: tweet.favorite_count,
    #   possibly_sensitive: tweet.possibly_sensitive?,
    #   lang: tweet.lang,
    #   media_url: media_url(tweet.media.first), # http://pbs.twimg.com/media/E0FEvXdVcAAQsB9.png
    #   media_type: tweet.media.first&.type, # photo / animated_gif / video
    # )
    # artist.save!
  end
end
