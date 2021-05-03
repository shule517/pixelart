create_table :artworks, id: :bigint, unsigned: true, force: :cascade do |t|
  t.bigint :artist_id, null: false
  t.datetime :posted_at, null: false
  t.string :text, null: false
  t.string :url, null: false
  t.boolean :truncated, null: false
  t.string :source, null: false
  t.bigint :in_reply_to_status_id
  t.bigint :in_reply_to_user_id
  t.string :in_reply_to_screen_name
  t.integer :retweet_count, null: false
  t.integer :favorite_count, null: false
  t.boolean :possibly_sensitive, null: false
  t.string :lang, null: false
  t.string :media_url, null: false  # http://pbs.twimg.com/media/E0FEvXdVcAAQsB9.png
  t.string :media_type, null: false # photo / animated_gif / video
  t.timestamps

  # 追加しなかった情報
  # geo
  # coordinates
  # place
  # contributors
end
add_index :artworks, :lang
add_index :artworks, :media_type
add_index :artworks, :artist_id

create_table :artwork_hashtags, id: :bigint, unsigned: true, force: :cascade do |t|
  t.bigint :artwork_id, null: false
  t.bigint :hashtag_id, null: false
end

create_table :hashtags, id: :bigint, unsigned: true,  force: :cascade do |t|
  t.string :name, null: false
end
add_index :hashtags, :name, unique: true

create_table :artists, id: :bigint, unsigned: true,  force: :cascade do |t|
  t.string :name, null: false
  t.string :screen_name, null: false
  t.string :location
  t.string :description
  t.string :url, null: false
  t.boolean :protected, null: false
  t.integer :followers_count, null: false
  t.integer :friends_count, null: false
  t.integer :listed_count, null: false
  t.datetime :registerd_at, null: false
  t.integer :favourites_count, null: false
  t.string :utc_offset

  t.string :time_zone

  t.boolean :geo_enabled, null: false
  t.boolean :verified, null: false
  t.integer :statuses_count, null: false
  t.string :lang
  t.boolean :contributors_enabled, null: false
  t.boolean :is_translator, null: false
  t.boolean :is_translation_enabled, null: false
  t.string :profile_background_color, null: false
  t.string :profile_background_image_url
  # t.string :profile_background_image_url_https
  t.boolean :profile_background_tile, null: false
  t.string :profile_image_url, null: false
  # t.string :profile_image_url_https
  t.string :profile_banner_url
  t.string :profile_link_color, null: false
  t.string :profile_sidebar_border_color, null: false
  t.string :profile_sidebar_fill_color, null: false
  t.string :profile_text_color, null: false
  t.boolean :profile_use_background_image, null: false
  # t.boolean :has_extended_profile
  t.boolean :default_profile, null: false
  t.boolean :default_profile_image, null: false

  # 追加しなかった情報
  # following
  # follow_request_sent
  # notifications
  # translator_type
  # withheld_in_countries
end
add_index :artists, :screen_name, unique: true
add_index :artists, :lang




# create_table :users, force: :cascade do |t|
#   t.string   :uid, null: false
#   t.string   :name, null: false
#   t.text     :photo_url, null: false
#   t.timestamps
# end
# add_index :users, :uid, unique: true
#
# create_table :user_devices, force: :cascade do |t|
#   t.string   :user_id, null: false
#   t.string   :token, null: false
#   t.timestamps
# end
# add_index :user_devices, :user_id
#
# create_table :private_channels, force: :cascade do |t|
#   t.string   :name, null: false
#   t.integer  :status, null: false, default: 0
#   t.timestamps
# end
# add_index :private_channels, :name, unique: true
# add_index :private_channels, :status
#
# create_table :favorites, force: :cascade do |t|
#   t.string   :user_id, null: false
#   t.string   :channel_name, null: false
#   t.timestamps
# end
# add_index :favorites, :user_id
# add_index :favorites, %i(user_id channel_name), unique: true
#
# create_table :channel_histories, force: :cascade do |t|
#   t.string   :stream_id, null: false
#   t.string   :name, null: false
#   t.string   :yellow_page, null: false
#   t.string   :tracker
#   t.string   :contact_url
#   t.string   :genre
#   t.string   :description
#   t.string   :comment
#   t.integer  :bitrate, null: false
#   t.string   :content_type
#   t.string   :track_title
#   t.string   :album
#   t.string   :creator
#   t.string   :track_url
#   t.integer  :listeners, null: false
#   t.integer  :relays, null: false
#   t.integer  :uptime, null: false
#   t.datetime :latest_lived_at, null: false
#   t.timestamps
# end
# add_index :channel_histories, :stream_id, unique: true
