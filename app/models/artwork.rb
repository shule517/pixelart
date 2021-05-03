# == Schema Information
#
# Table name: artworks
#
#  id                      :integer          not null, primary key
#  favorite_count          :integer
#  in_reply_to_screen_name :string
#  lang                    :string
#  media_type              :string
#  media_url               :string
#  possibly_sensitive      :boolean
#  posted_at               :datetime
#  retweet_count           :integer
#  source                  :string
#  text                    :string
#  truncated               :boolean
#  url                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  in_reply_to_status_id   :bigint
#  in_reply_to_user_id     :integer
#
class Artwork < ApplicationRecord
  def self.create_from_tweet!(tweet)
    artwork = find_or_initialize_by(id: tweet.id)

    artwork.assign_attributes(
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
      media.video_info.variants.first[:url]
    end
  end
end
