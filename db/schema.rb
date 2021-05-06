# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "screen_name", null: false
    t.string "location"
    t.string "description"
    t.string "url", null: false
    t.boolean "protected", null: false
    t.integer "followers_count", null: false
    t.integer "friends_count", null: false
    t.integer "listed_count", null: false
    t.datetime "registerd_at", null: false
    t.integer "favourites_count", null: false
    t.string "utc_offset"
    t.string "time_zone"
    t.boolean "geo_enabled", null: false
    t.boolean "verified", null: false
    t.integer "statuses_count", null: false
    t.string "lang"
    t.boolean "contributors_enabled", null: false
    t.boolean "is_translator", null: false
    t.boolean "is_translation_enabled", null: false
    t.string "profile_background_color", null: false
    t.string "profile_background_image_url"
    t.boolean "profile_background_tile", null: false
    t.string "profile_image_url", null: false
    t.string "profile_banner_url"
    t.string "profile_link_color", null: false
    t.string "profile_sidebar_border_color", null: false
    t.string "profile_sidebar_fill_color", null: false
    t.string "profile_text_color", null: false
    t.boolean "profile_use_background_image", null: false
    t.boolean "default_profile", null: false
    t.boolean "default_profile_image", null: false
    t.integer "collect_tweet_oldest_id"
    t.integer "collect_tweet_latest_id"
    t.integer "oldest_tweet_collected", default: 0, null: false
    t.index ["lang"], name: "index_artists_on_lang"
    t.index ["screen_name"], name: "index_artists_on_screen_name", unique: true
  end

  create_table "artwork_hashtags", force: :cascade do |t|
    t.bigint "artwork_id", null: false
    t.integer "hashtag_id", null: false
    t.index ["artwork_id", "hashtag_id"], name: "index_artwork_hashtags_on_artwork_id_and_hashtag_id", unique: true
  end

  create_table "artworks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "posted_at", null: false
    t.string "text", null: false
    t.boolean "truncated", null: false
    t.string "source", null: false
    t.bigint "in_reply_to_status_id"
    t.integer "in_reply_to_user_id"
    t.string "in_reply_to_screen_name"
    t.integer "retweet_count", null: false
    t.integer "favorite_count", null: false
    t.boolean "possibly_sensitive", null: false
    t.string "lang", null: false
    t.string "media_url", null: false
    t.string "media_type", null: false
    t.string "url", null: false
    t.integer "artist_id", null: false
    t.index ["artist_id"], name: "index_artworks_on_artist_id"
    t.index ["lang"], name: "index_artworks_on_lang"
    t.index ["media_type"], name: "index_artworks_on_media_type"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "artwork_id", null: false
    t.index ["artist_id", "artwork_id"], name: "index_favorites_on_artist_id_and_artwork_id", unique: true
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_hashtags_on_name", unique: true
  end

end
