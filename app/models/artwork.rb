# == Schema Information
#
# Table name: artworks
#
#  id                      :integer          not null, primary key
#  favorite_count          :integer          not null
#  in_reply_to_screen_name :string
#  lang                    :string           not null
#  media_type              :string           not null
#  media_url               :string           not null
#  possibly_sensitive      :boolean          not null
#  posted_at               :datetime         not null
#  retweet_count           :integer          not null
#  source                  :string           not null
#  text                    :string           not null
#  truncated               :boolean          not null
#  url                     :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  artist_id               :integer          not null
#  in_reply_to_status_id   :integer
#  in_reply_to_user_id     :bigint
#
# Indexes
#
#  index_artworks_on_artist_id   (artist_id)
#  index_artworks_on_lang        (lang)
#  index_artworks_on_media_type  (media_type)
#
class Artwork < ApplicationRecord
  belongs_to :artist

  def self.create_from_tweet!(tweet)
    artwork = find_or_initialize_by(id: tweet.id)

    # TODO: tweet.hashtags.map(&:text)

    artist = Artist.create_from_user!(tweet.user)

    artwork.assign_attributes(
      artist: artist,
      posted_at: tweet.created_at,
      text: tweet.text,
      url: tweet.url,
      truncated: tweet.truncated?,
      source: tweet.source,
      in_reply_to_status_id: tweet.in_reply_to_status_id,
      in_reply_to_user_id: tweet.in_reply_to_user_id,
      in_reply_to_screen_name: tweet.in_reply_to_screen_name,
      retweet_count: tweet.retweet_count,
      favorite_count: tweet.favorite_count,
      possibly_sensitive: tweet.possibly_sensitive?,
      lang: tweet.lang,
      media_url: media_url(tweet.media.first), # http://pbs.twimg.com/media/E0FEvXdVcAAQsB9.png
      media_type: tweet.media.first&.type, # photo / animated_gif / video
    )
    artwork.save!
  end

  def self.media_url(media)
    return if media.blank?

    if media.type == 'photo'
      media.media_url
    elsif media.type == 'animated_gif' || media.type == 'video'
      media.video_info.variants.first.url
    end
  end
end
