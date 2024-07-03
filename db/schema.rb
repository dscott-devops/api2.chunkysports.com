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

ActiveRecord::Schema.define(version: 2023_11_25_124926) do

    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
  
    create_table "active_storage_attachments", force: :cascade do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end
  
    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.string "service_name", null: false
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end
  
    create_table "active_storage_variant_records", force: :cascade do |t|
      t.bigint "blob_id", null: false
      t.string "variation_digest", null: false
      t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    end
  
    create_table "chunks", force: :cascade do |t|
      t.text "body"
      t.text "preview"
      t.string "title"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end
  
    create_table "clicks", force: :cascade do |t|
      t.integer "lump_id"
      t.integer "user_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["created_at"], name: "index_clicks_on_created_at"
      t.index ["lump_id"], name: "index_clicks_on_lump_id"
    end
  
    create_table "comments", force: :cascade do |t|
      t.text "body"
      t.integer "lump_id"
      t.integer "parent_id"
      t.integer "user_id"
      t.integer "likes_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "image"
      t.string "displayname"
      t.bigint "source_id"
      t.index ["created_at"], name: "index_comments_on_created_at"
      t.index ["lump_id"], name: "index_comments_on_lump_id"
      t.index ["parent_id"], name: "index_comments_on_parent_id"
      t.index ["source_id"], name: "index_comments_on_source_id"
      t.index ["user_id"], name: "index_comments_on_user_id"
    end
  
    create_table "gamedetails", force: :cascade do |t|
      t.string "conference"
      t.string "category"
      t.string "subcategory"
      t.string "teamapi"
      t.bigint "source_id"
      t.string "home"
      t.string "away"
      t.string "gameid"
      t.integer "apoints", default: 0
      t.integer "hpoints", default: 0
      t.integer "afgm", default: 0
      t.integer "hfgm", default: 0
      t.integer "afga", default: 0
      t.integer "hfga", default: 0
      t.string "afgp", default: ""
      t.string "hfgp", default: ""
      t.integer "afta", default: 0
      t.integer "hfta", default: 0
      t.string "aftp", default: ""
      t.string "hftp", default: ""
      t.integer "atpm", default: 0
      t.integer "htpm", default: 0
      t.integer "atpa", default: 0
      t.integer "htpa", default: 0
      t.string "atpp", default: ""
      t.string "htpp", default: ""
      t.integer "aoffReb", default: 0
      t.integer "hoffReb", default: 0
      t.integer "adefReb", default: 0
      t.integer "hdefReb", default: 0
      t.integer "atotReb", default: 0
      t.integer "htotReb", default: 0
      t.integer "aassists", default: 0
      t.integer "hassists", default: 0
      t.integer "apFouls", default: 0
      t.integer "hpFouls", default: 0
      t.integer "asteals", default: 0
      t.integer "hsteals", default: 0
      t.integer "aturnovers", default: 0
      t.integer "hturnovers", default: 0
      t.integer "ablocks", default: 0
      t.integer "hblocks", default: 0
      t.string "aplusMinus", default: ""
      t.string "hplusMinus", default: ""
      t.integer "afdtotal", default: 0
      t.integer "hfdtotal", default: 0
      t.integer "afdpassing", default: 0
      t.integer "hfdpassing", default: 0
      t.integer "afdrushing", default: 0
      t.integer "hfdrushing", default: 0
      t.integer "afdpenalty", default: 0
      t.integer "hfdpenalty", default: 0
      t.string "afd3efficiency", default: ""
      t.string "hfd3efficiency", default: ""
      t.string "afd4efficiency", default: ""
      t.string "hfd4efficiency", default: ""
      t.integer "aplays", default: 0
      t.integer "hplays", default: 0
      t.integer "ayardstotal", default: 0
      t.integer "hyardstotal", default: 0
      t.string "ayardsperplay", default: ""
      t.string "hyardsperplay", default: ""
      t.string "ayardstdrives", default: ""
      t.string "hyardstdrives", default: ""
      t.integer "apassingtotal", default: 0
      t.integer "hpassingtotal", default: 0
      t.string "apassingcomp", default: ""
      t.string "hpassingcomp", default: ""
      t.string "apassingypp", default: ""
      t.string "hpassingypp", default: ""
      t.integer "apassingint", default: 0
      t.integer "hpassingint", default: 0
      t.string "apassingsyl", default: ""
      t.string "hpassingsyl", default: ""
      t.integer "arushingtotal", default: 0
      t.integer "hrushingtotal", default: 0
      t.integer "arushingattemps", default: 0
      t.integer "hrushingattemps", default: 0
      t.string "arushingypa", default: ""
      t.string "hrushingypa", default: ""
      t.string "aredzone", default: ""
      t.string "hredzone", default: ""
      t.string "apenaltytotal", default: ""
      t.string "hpenaltytotal", default: ""
      t.integer "atototal", default: 0
      t.integer "htototal", default: 0
      t.integer "atofumbles", default: 0
      t.integer "htofumbles", default: 0
      t.integer "atoints", default: 0
      t.integer "htoints", default: 0
      t.string "apossesion", default: ""
      t.string "hpossesion", default: ""
      t.integer "aints", default: 0
      t.integer "hints", default: 0
      t.integer "afumbles", default: 0
      t.integer "hfumbles", default: 0
      t.integer "asacks", default: 0
      t.integer "hsacks", default: 0
      t.integer "asafeties", default: 0
      t.integer "hsafeties", default: 0
      t.integer "aintstd", default: 0
      t.integer "hintstd", default: 0
      t.integer "apoints_against", default: 0
      t.integer "hpoints_against", default: 0
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "game_id"
      t.bigint "hsource_id"
      t.bigint "asource_id"
      t.integer "hftm", default: 0
      t.integer "aftm", default: 0
      t.index ["category"], name: "index_gamedetails_on_category"
      t.index ["gameid"], name: "index_gamedetails_on_gameid"
    end
  
    create_table "games", force: :cascade do |t|
      t.string "hometeam"
      t.string "awayteam"
      t.integer "hometeamscore"
      t.integer "awayteamscore"
      t.datetime "gametime"
      t.string "video"
      t.string "gameindex"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "eventname"
      t.integer "round"
      t.string "gamename"
      t.bigint "source_id"
      t.string "teamname"
      t.string "eventid"
      t.string "eventtime"
      t.string "eventdate"
      t.string "eventthumb"
      t.bigint "timestamp"
      t.string "week"
      t.integer "season"
      t.integer "gameid"
      t.boolean "active", default: false
      t.index ["gameindex"], name: "index_games_on_gameindex", unique: true
      t.index ["gametime"], name: "index_games_on_gametime"
      t.index ["source_id"], name: "index_games_on_source_id"
    end
  
    create_table "imagefiles", force: :cascade do |t|
      t.string "imageurl"
      t.string "key"
      t.boolean "profilePic", default: false
      t.string "imageOriginal"
      t.string "image30Pixels"
      t.string "image50Pixels"
      t.text "description"
      t.boolean "lumpImage", default: false
      t.bigint "lump_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "user_id"
      t.string "filename"
      t.index ["key"], name: "index_imagefiles_on_key", unique: true
      t.index ["lump_id"], name: "index_imagefiles_on_lump_id"
    end
  
    create_table "lumps", force: :cascade do |t|
      t.text "body"
      t.text "preview"
      t.string "title"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "source_id"
      t.string "link"
      t.string "image"
      t.string "description"
      t.string "lumpindex"
      t.boolean "youtube", default: false
      t.string "videoid"
      t.string "category"
      t.string "username"
      t.string "name"
      t.string "videodata"
      t.integer "views", default: 0
      t.index ["category"], name: "index_lumps_on_category"
      t.index ["created_at"], name: "index_lumps_on_created_at"
      t.index ["lumpindex"], name: "index_lumps_on_lumpindex", unique: true
      t.index ["source_id"], name: "index_lumps_on_source_id"
    end
  
    create_table "sources", force: :cascade do |t|
      t.string "title"
      t.string "description"
      t.string "image"
      t.string "sourcetype"
      t.string "subcategory"
      t.string "username"
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.boolean "source"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "category"
      t.string "conference"
      t.string "logo30"
      t.string "logo50"
      t.text "playlists"
      t.string "logo"
      t.string "logo150"
      t.string "teamid"
      t.string "stadium"
      t.string "stadiumthumb"
      t.text "stadiumdescription"
      t.string "stadiumlocation"
      t.integer "stadiumcapacity"
      t.string "facebook"
      t.string "twitter"
      t.string "instagram"
      t.string "website"
      t.string "teamapi"
    end
  
    create_table "standings", force: :cascade do |t|
      t.string "conference"
      t.string "category"
      t.string "subcategory"
      t.string "teamapi"
      t.bigint "source_id"
      t.string "home"
      t.string "road"
      t.string "confrecord"
      t.string "division"
      t.string "teamid"
      t.integer "season"
      t.integer "won"
      t.integer "lost"
      t.integer "ties"
      t.integer "points_for"
      t.integer "points_against"
      t.string "streak"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "position"
      t.string "title"
      t.index ["category"], name: "index_standings_on_category"
      t.index ["season"], name: "index_standings_on_season"
      t.index ["source_id"], name: "index_standings_on_source_id"
      t.index ["subcategory"], name: "index_standings_on_subcategory"
      t.index ["teamapi"], name: "index_standings_on_teamapi"
      t.index ["teamid"], name: "index_standings_on_teamid"
    end
  
    create_table "urls", force: :cascade do |t|
      t.string "url"
      t.text "urldata"
      t.string "urltype"
      t.string "urltype2"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "source_id", null: false
      t.string "ignore"
      t.boolean "youtube", default: false
      t.string "channel"
      t.boolean "dismiss", default: false
      t.index ["source_id"], name: "index_urls_on_source_id"
      t.index ["url"], name: "index_urls_on_url", unique: true
    end
  
    create_table "user_sources", force: :cascade do |t|
      t.integer "user_id"
      t.integer "source_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end
  
    create_table "users", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "firstname", default: ""
      t.string "lastname", default: ""
      t.string "username"
      t.string "displayname", default: ""
      t.string "slogan"
      t.string "image", default: ""
      t.text "bio", default: ""
      t.string "mobile"
      t.string "authentication_token", limit: 30
      t.boolean "admin", default: false
      t.string "privacy", default: "1"
      t.boolean "gravatar", default: false
      t.string "favorite"
      t.string "image_key"
      t.string "image150"
      t.string "image300"
      t.boolean "imageresized", default: false
      t.string "image600"
      t.string "gravatar_email"
      t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
  
    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
    add_foreign_key "lumps", "sources"
    add_foreign_key "urls", "sources"
  end
  