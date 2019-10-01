# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_22_170621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "alert_jobs", id: :serial, force: :cascade do |t|
    t.integer "trackable_id", null: false
    t.string "trackable_type", limit: 255, null: false
    t.integer "notification_type_id", null: false
    t.integer "user_id", null: false
    t.integer "alert_id"
    t.string "jid", limit: 255, null: false
    t.integer "accumulated_count", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alerts", id: :serial, force: :cascade do |t|
    t.integer "notification_id", null: false
    t.integer "user_id"
    t.boolean "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checked_at"
    t.hstore "properties", default: {}, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "trackable_id"
    t.string "trackable_type", limit: 255
    t.index ["checked"], name: "index_alerts_on_checked"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "announcements", id: :serial, force: :cascade do |t|
    t.text "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "area_participations", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_area_id", null: false
    t.integer "area_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "area_proposals", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "group_area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "area_roles", id: :serial, force: :cascade do |t|
    t.integer "group_area_id"
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "view_proposals", default: false, null: false
    t.boolean "participate_proposals", default: false, null: false
    t.boolean "insert_proposals", default: false, null: false
    t.boolean "vote_proposals", default: false, null: false
    t.boolean "choose_date_proposals", default: false, null: false
  end

  create_table "authentications", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", limit: 255
    t.string "token", limit: 255
    t.string "uid", limit: 100
  end

  create_table "available_authors", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["proposal_id", "user_id"], name: "index_available_authors_on_proposal_id_and_user_id", unique: true
  end

  create_table "banned_emails", id: :serial, force: :cascade do |t|
    t.string "email", limit: 200, null: false
    t.datetime "created_at", null: false
    t.index ["email"], name: "index_banned_emails_on_email", unique: true
  end

  create_table "blocked_alerts", id: :serial, force: :cascade do |t|
    t.integer "notification_type_id"
    t.integer "user_id"
  end

  create_table "blocked_emails", id: :serial, force: :cascade do |t|
    t.integer "notification_type_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocked_proposal_alerts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_id"
    t.integer "user_id"
    t.boolean "updates", default: false
    t.boolean "contributes", default: false
    t.boolean "state", default: false
    t.boolean "authors", default: false
    t.boolean "valutations", default: false
  end

  create_table "blog_comments", id: :serial, force: :cascade do |t|
    t.integer "parent_blog_comment_id"
    t.integer "blog_post_id"
    t.integer "user_id"
    t.string "user_ip", limit: 255
    t.string "user_agent", limit: 255
    t.string "referrer", limit: 255
    t.string "name", limit: 255
    t.string "site_url", limit: 255
    t.string "email", limit: 255
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_post_tags", id: :serial, force: :cascade do |t|
    t.integer "blog_post_id"
    t.integer "tag_id", null: false
    t.index ["blog_post_id", "tag_id"], name: "index_blog_post_tags_on_blog_post_id_and_tag_id", unique: true
  end

  create_table "blog_post_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_blog_post_versions_on_item_type_and_item_id"
  end

  create_table "blog_posts", id: :serial, force: :cascade do |t|
    t.integer "blog_id"
    t.string "title", limit: 255, null: false
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.integer "user_id"
    t.string "status", limit: 1, default: "P", null: false
    t.integer "blog_comments_count", default: 0, null: false
  end

  create_table "blogs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.index ["slug"], name: "index_blogs_on_slug"
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", limit: 255, null: false
    t.string "data_content_type", limit: 255
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "configurations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "value", limit: 255, null: false
  end

  create_table "continent_translations", id: :serial, force: :cascade do |t|
    t.integer "continent_id"
    t.string "locale", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["continent_id"], name: "index_continent_translations_on_continent_id"
    t.index ["locale"], name: "index_continent_translations_on_locale"
  end

  create_table "continents", id: :serial, force: :cascade do |t|
    t.integer "geoname_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.integer "continent_id", null: false
    t.string "sigla", limit: 255, null: false
    t.string "sigla_ext", limit: 3
    t.integer "geoname_id"
  end

  create_table "country_translations", id: :serial, force: :cascade do |t|
    t.integer "country_id"
    t.string "locale", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_translations_on_country_id"
    t.index ["locale"], name: "index_country_translations_on_locale"
  end

  create_table "districts", id: :serial, force: :cascade do |t|
    t.integer "municipality_id"
    t.string "description", limit: 100
    t.integer "province_id"
    t.integer "region_id"
    t.integer "country_id"
    t.integer "continent_id"
    t.integer "geoname_id"
    t.index ["continent_id"], name: "index_districts_on_continent_id"
    t.index ["country_id"], name: "index_districts_on_country_id"
    t.index ["province_id"], name: "index_districts_on_province_id"
    t.index ["region_id"], name: "index_districts_on_region_id"
  end

  create_table "email_jobs", id: :serial, force: :cascade do |t|
    t.integer "alert_id", null: false
    t.string "jid", limit: 255, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_comment_likes", id: :serial, force: :cascade do |t|
    t.integer "event_comment_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_comment_id", "user_id"], name: "index_event_comment_likes_on_event_comment_id_and_user_id", unique: true
    t.index ["event_comment_id"], name: "index_event_comment_likes_on_event_comment_id"
    t.index ["user_id"], name: "index_event_comment_likes_on_user_id"
  end

  create_table "event_comments", id: :serial, force: :cascade do |t|
    t.integer "parent_event_comment_id"
    t.integer "event_id", null: false
    t.integer "user_id", null: false
    t.integer "user_ip"
    t.string "user_agent", limit: 255
    t.string "referrer", limit: 255
    t.string "body", limit: 2500, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_comments_on_event_id"
    t.index ["parent_event_comment_id"], name: "index_event_comments_on_parent_event_comment_id"
    t.index ["user_id"], name: "index_event_comments_on_user_id"
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "color", limit: 10
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean "all_day", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.integer "event_type_id", null: false
    t.boolean "private", default: false, null: false
    t.integer "user_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "frm_categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "slug", limit: 255
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_outside", default: true
    t.index ["group_id", "slug"], name: "index_frm_categories_on_group_id_and_slug", unique: true
    t.index ["slug"], name: "index_frm_categories_on_slug"
  end

  create_table "frm_category_tags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frm_category_id"
    t.integer "tag_id"
  end

  create_table "frm_forum_tags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frm_forum_id"
    t.integer "tag_id"
  end

  create_table "frm_forums", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "category_id"
    t.integer "group_id"
    t.integer "views_count", default: 0
    t.string "slug", limit: 255
    t.boolean "visible_outside", default: true
    t.index ["group_id", "slug"], name: "index_frm_forums_on_group_id_and_slug", unique: true
    t.index ["group_id"], name: "index_frm_forums_on_group_id"
    t.index ["slug"], name: "index_frm_forums_on_slug"
  end

  create_table "frm_memberships", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "member_id"
    t.index ["group_id"], name: "index_frm_memberships_on_group_id"
  end

  create_table "frm_moderator_groups", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "group_id"
    t.index ["forum_id"], name: "index_frm_moderator_groups_on_forum_id"
  end

  create_table "frm_mods", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "group_id"
    t.index ["name"], name: "index_frm_mods_on_name"
  end

  create_table "frm_posts", id: :serial, force: :cascade do |t|
    t.integer "topic_id"
    t.text "text"
    t.integer "user_id"
    t.integer "reply_to_id"
    t.string "state", limit: 255, default: "pending_review"
    t.boolean "notified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", limit: 255
    t.index ["reply_to_id"], name: "index_frm_posts_on_reply_to_id"
    t.index ["state"], name: "index_frm_posts_on_state"
    t.index ["token"], name: "index_frm_posts_on_token", unique: true
    t.index ["topic_id"], name: "index_frm_posts_on_topic_id"
    t.index ["user_id"], name: "index_frm_posts_on_user_id"
  end

  create_table "frm_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "frm_topic_proposals", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
    t.integer "proposal_id"
    t.integer "user_id"
  end

  create_table "frm_topic_tags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frm_topic_id"
    t.integer "tag_id"
  end

  create_table "frm_topics", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.string "subject", limit: 255
    t.boolean "locked", default: false, null: false
    t.boolean "pinned", default: false, null: false
    t.boolean "hidden", default: false
    t.string "state", limit: 255, default: "pending_review"
    t.datetime "last_post_at"
    t.integer "views_count", default: 0
    t.string "slug", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", limit: 255
    t.index ["created_at"], name: "index_frm_topics_on_created_at"
    t.index ["forum_id", "slug"], name: "index_frm_topics_on_forum_id_and_slug", unique: true
    t.index ["forum_id"], name: "index_frm_topics_on_forum_id"
    t.index ["slug"], name: "index_frm_topics_on_slug"
    t.index ["state"], name: "index_frm_topics_on_state"
    t.index ["token"], name: "index_frm_topics_on_token", unique: true
    t.index ["user_id"], name: "index_frm_topics_on_user_id"
  end

  create_table "frm_views", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "viewable_id"
    t.string "viewable_type", limit: 255
    t.integer "count", default: 0
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_frm_views_on_updated_at"
    t.index ["user_id"], name: "index_frm_views_on_user_id"
    t.index ["viewable_id"], name: "index_frm_views_on_viewable_id"
    t.index ["viewable_type"], name: "index_frm_views_on_viewable_type"
  end

  create_table "generic_borders", id: :serial, force: :cascade do |t|
    t.string "description", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.integer "seq"
  end

  create_table "geometry_columns", id: false, force: :cascade do |t|
    t.string "f_table_catalog", limit: 256, null: false
    t.string "f_table_schema", limit: 256, null: false
    t.string "f_table_name", limit: 256, null: false
    t.string "f_geometry_column", limit: 256, null: false
    t.integer "coord_dimension", null: false
    t.integer "srid", null: false
    t.string "type", limit: 30, null: false
  end

  create_table "group_areas", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 2000
    t.integer "area_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "group_follows", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
  end

  create_table "group_invitation_emails", id: :serial, force: :cascade do |t|
    t.string "email", limit: 200, null: false
    t.string "accepted", limit: 1, default: "W", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", limit: 32
    t.boolean "consumed", default: false
    t.integer "user_id"
    t.integer "group_invitation_id"
  end

  create_table "group_invitations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "inviter_id", null: false
    t.boolean "consumed", default: false, null: false
    t.string "testo", limit: 4000
    t.integer "group_id"
  end

  create_table "group_participation_request_statuses", id: :serial, force: :cascade do |t|
    t.string "description", limit: 200, null: false
  end

  create_table "group_participation_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.integer "group_participation_request_status_id", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "group_id"], name: "unique", unique: true
  end

  create_table "group_participations", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.integer "participation_role_id", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "acceptor_id"
    t.index ["group_id"], name: "index_group_participations_on_group_id"
    t.index ["user_id", "group_id"], name: "only_once_per_group", unique: true
    t.index ["user_id"], name: "index_group_participations_on_user_id"
  end

  create_table "group_proposals", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["proposal_id", "group_id"], name: "index_group_proposals_on_proposal_id_and_group_id", unique: true
  end

  create_table "group_quorums", id: :serial, force: :cascade do |t|
    t.integer "quorum_id", null: false
    t.integer "group_id"
    t.index ["quorum_id", "group_id"], name: "index_group_quorums_on_quorum_id_and_group_id", unique: true
    t.index ["quorum_id"], name: "index_group_quorums_on_quorum_id", unique: true
  end

  create_table "group_statistics", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.float "good_score"
    t.float "vote_good_score"
    t.float "valutations"
    t.float "vote_valutations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_tags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "tag_id"
  end

  create_table "group_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_group_versions_on_item_type_and_item_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 200
    t.string "description", limit: 2500
    t.string "accept_requests", limit: 255, default: "p", null: false
    t.integer "interest_border_id"
    t.string "facebook_page_url", limit: 255
    t.integer "image_id"
    t.string "title_bar", limit: 255
    t.string "old_image_url", limit: 255
    t.integer "participation_role_id", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "change_advanced_options", default: true, null: false
    t.boolean "default_anonima", default: true, null: false
    t.boolean "default_visible_outside", default: false, null: false
    t.boolean "default_secret_vote", default: true, null: false
    t.integer "max_storage_size", default: 51200, null: false
    t.integer "actual_storage_size", default: 0, null: false
    t.boolean "enable_areas", default: false, null: false
    t.integer "group_participations_count", default: 0, null: false
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "admin_title", limit: 200
    t.boolean "private", default: false
    t.string "rule_book", limit: 40000
    t.string "status", limit: 255, default: "active", null: false
    t.datetime "status_changed_at"
    t.string "slug", limit: 255
    t.boolean "disable_participation_requests", default: false
    t.boolean "disable_forums", default: false
    t.boolean "disable_documents", default: false
    t.integer "proposals_count", default: 0
    t.integer "meeting_organizations_count", default: 0, null: false
    t.string "interest_border_token"
    t.string "derived_interest_borders_tokens", default: [], array: true
    t.index ["slug"], name: "index_groups_on_slug"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrated_contributes", id: :serial, force: :cascade do |t|
    t.integer "proposal_revision_id", null: false
    t.integer "proposal_comment_id", null: false
    t.index ["proposal_revision_id", "proposal_comment_id"], name: "unique_contributes", unique: true
  end

  create_table "interest_borders", id: :serial, force: :cascade do |t|
    t.integer "territory_id", null: false
    t.string "territory_type", limit: 255, null: false
  end

  create_table "meeting_organizations", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "event_id"
  end

  create_table "meeting_participations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "meeting_id"
    t.string "comment", limit: 255
    t.integer "guests", default: 0, null: false
    t.string "response", limit: 1
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.integer "place_id"
    t.integer "event_id"
  end

  create_table "municipalities", id: :serial, force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.integer "province_id", null: false
    t.integer "region_id", null: false
    t.integer "population"
    t.string "codistat", limit: 4
    t.string "cap", limit: 5
    t.integer "country_id"
    t.integer "continent_id"
    t.integer "geoname_id"
    t.index ["continent_id"], name: "index_municipalities_on_continent_id"
    t.index ["country_id"], name: "index_municipalities_on_country_id"
    t.index ["region_id"], name: "index_municipalities_on_region_id"
  end

  create_table "newsletters", id: :serial, force: :cascade do |t|
    t.string "subject", limit: 255
    t.text "body"
  end

  create_table "notification_categories", id: :serial, force: :cascade do |t|
    t.integer "seq"
    t.string "short", limit: 8
  end

  create_table "notification_data", id: :serial, force: :cascade do |t|
    t.integer "notification_id", null: false
    t.string "name", limit: 100, null: false
    t.string "value", limit: 4000
    t.index ["notification_id", "name"], name: "index_notification_data_on_notification_id_and_name", unique: true
  end

  create_table "notification_types", id: :serial, force: :cascade do |t|
    t.integer "notification_category_id", null: false
    t.string "name", limit: 255
    t.integer "email_delay", null: false
    t.integer "alert_delay", null: false
    t.boolean "cumulable", default: false, null: false
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "notification_type_id", null: false
    t.string "message", limit: 1000
    t.string "url", limit: 400
    t.hstore "properties", default: {}, null: false
  end

  create_table "old_proposal_presentations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_life_id"
    t.integer "user_id"
  end

  create_table "paragraph_histories", id: :serial, force: :cascade do |t|
    t.integer "section_history_id", null: false
    t.string "content", limit: 40000
    t.integer "seq", null: false
    t.integer "proposal_id", null: false
    t.index ["proposal_id"], name: "index_paragraph_histories_on_proposal_id"
  end

  create_table "paragraphs", id: :serial, force: :cascade do |t|
    t.integer "section_id", null: false
    t.string "content", limit: 40000
    t.integer "seq", null: false
  end

  create_table "participation_roles", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "name", limit: 200
    t.string "description", limit: 2000
    t.boolean "write_to_wall", default: false, null: false
    t.boolean "create_events", default: false, null: false
    t.boolean "support_proposals", default: false, null: false
    t.boolean "accept_participation_requests", default: false, null: false
    t.boolean "view_proposals", default: false, null: false
    t.boolean "participate_proposals", default: false, null: false
    t.boolean "insert_proposals", default: false, null: false
    t.boolean "vote_proposals", default: false, null: false
    t.boolean "choose_date_proposals", default: false, null: false
    t.boolean "view_documents", default: false, null: false
    t.boolean "manage_documents", default: false, null: false
  end

  create_table "periods", id: :serial, force: :cascade do |t|
    t.datetime "from", null: false
    t.datetime "to", null: false
    t.index ["from", "to"], name: "from_to_unique", unique: true
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.integer "municipality_id"
    t.string "frazione", limit: 200
    t.string "address", limit: 200
    t.string "civic_number", limit: 10
    t.string "cap", limit: 5
    t.float "latitude_original"
    t.float "longitude_original"
    t.float "latitude_center"
    t.float "longitude_center"
    t.integer "zoom"
  end

  create_table "post_publishings", id: :serial, force: :cascade do |t|
    t.integer "blog_post_id"
    t.integer "group_id"
    t.boolean "featured", default: false, null: false
  end

  create_table "proposal_borders", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "interest_border_id", null: false
    t.integer "created_at"
    t.index ["proposal_id"], name: "_idx_proposal_borderds_proposal_id"
  end

  create_table "proposal_categories", id: :serial, force: :cascade do |t|
    t.integer "parent_proposal_category_id"
    t.string "name", limit: 255
    t.integer "seq"
  end

  create_table "proposal_comment_rankings", id: :serial, force: :cascade do |t|
    t.integer "proposal_comment_id", null: false
    t.integer "user_id", null: false
    t.integer "ranking_type_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["proposal_comment_id", "user_id"], name: "user_comment", unique: true
  end

  create_table "proposal_comment_report_types", id: :serial, force: :cascade do |t|
    t.string "description", limit: 255, null: false
    t.integer "severity", default: 0, null: false
    t.integer "seq"
  end

  create_table "proposal_comment_reports", id: :serial, force: :cascade do |t|
    t.integer "proposal_comment_id", null: false
    t.integer "user_id", null: false
    t.integer "proposal_comment_report_type_id", null: false
    t.index ["proposal_comment_id", "user_id"], name: "reports_index", unique: true
  end

  create_table "proposal_comment_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_proposal_comment_versions_on_item_type_and_item_id"
  end

  create_table "proposal_comments", id: :serial, force: :cascade do |t|
    t.integer "parent_proposal_comment_id"
    t.integer "user_id"
    t.integer "proposal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "user_ip", limit: 255
    t.string "user_agent", limit: 255
    t.string "referrer", limit: 255
    t.boolean "deleted", default: false, null: false
    t.integer "deleted_user_id"
    t.datetime "deleted_at"
    t.string "content", limit: 2500
    t.integer "rank", default: 0, null: false
    t.integer "valutations", default: 0, null: false
    t.integer "paragraph_id"
    t.decimal "j_value", default: "0.0", null: false
    t.boolean "integrated", default: false, null: false
    t.integer "grave_reports_count", default: 0, null: false
    t.integer "soft_reports_count", default: 0, null: false
    t.boolean "noise", default: false
  end

  create_table "proposal_lives", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_id"
    t.integer "quorum_id"
    t.integer "valutations"
    t.integer "rank"
    t.integer "seq"
  end

  create_table "proposal_nicknames", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "user_id", null: false
    t.string "nickname", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nickname"], name: "index_proposal_nicknames_on_nickname"
    t.index ["proposal_id", "nickname"], name: "index_proposal_nicknames_on_proposal_id_and_nickname", unique: true
    t.index ["proposal_id", "user_id"], name: "index_proposal_nicknames_on_proposal_id_and_user_id", unique: true
  end

  create_table "proposal_presentations", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "acceptor_id"
    t.index ["proposal_id"], name: "_idx_proposal_presentations_proposal_id"
    t.index ["user_id", "proposal_id"], name: "index_proposal_presentations_on_user_id_and_proposal_id", unique: true
    t.index ["user_id"], name: "_idx_proposal_presentations_user_id"
  end

  create_table "proposal_rankings", id: :serial, force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "user_id"
    t.integer "ranking_type_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["proposal_id", "user_id"], name: "proposal_user", unique: true
  end

  create_table "proposal_revisions", id: :serial, force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "user_id"
    t.integer "valutations"
    t.integer "rank"
    t.integer "seq", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_proposal_revisions_on_proposal_id"
  end

  create_table "proposal_schulze_votes", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.string "preferences", limit: 255, null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proposal_sections", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "section_id", null: false
    t.index ["section_id"], name: "index_proposal_sections_on_section_id", unique: true
  end

  create_table "proposal_states", id: :serial, force: :cascade do |t|
    t.string "description", limit: 200
  end

  create_table "proposal_supports", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposal_tags", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["proposal_id", "tag_id"], name: "index_proposal_tags_on_proposal_id_and_tag_id", unique: true
  end

  create_table "proposal_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 10, null: false
    t.integer "seq", default: 0
    t.boolean "active", default: false
    t.string "color", limit: 10
    t.boolean "groups_available", default: true
    t.boolean "open_space_available", default: false
  end

  create_table "proposal_votation_types", id: :serial, force: :cascade do |t|
    t.string "short_name", limit: 10, null: false
    t.string "description", limit: 255, null: false
  end

  create_table "proposal_votes", id: :serial, force: :cascade do |t|
    t.bigint "proposal_id"
    t.integer "positive"
    t.integer "negative"
    t.integer "neutral"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", id: :serial, force: :cascade do |t|
    t.integer "proposal_state_id"
    t.integer "proposal_category_id", default: 5, null: false
    t.string "title", limit: 255, null: false
    t.string "content", limit: 20000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "valutations", default: 0
    t.integer "vote_period_id"
    t.integer "proposal_comments_count", default: 0
    t.integer "rank", default: 0, null: false
    t.boolean "show_comment_authors", default: true, null: false
    t.boolean "private", default: false, null: false
    t.integer "quorum_id"
    t.boolean "anonima", default: true, null: false
    t.boolean "visible_outside", default: false, null: false
    t.boolean "secret_vote", default: true, null: false
    t.integer "proposal_type_id", default: 1, null: false
    t.integer "proposal_votation_type_id", default: 1, null: false
    t.boolean "vote_defined", default: false
    t.datetime "vote_starts_at"
    t.datetime "vote_ends_at"
    t.integer "vote_event_id"
    t.integer "signatures"
    t.integer "views_count", default: 0, null: false
    t.boolean "area_private", default: false, null: false
    t.integer "user_votes_count"
    t.text "short_content"
    t.integer "proposal_contributes_count", default: 0, null: false
    t.string "interest_borders_tokens", default: [], array: true
    t.string "derived_interest_borders_tokens", default: [], array: true
    t.index ["proposal_category_id"], name: "_idx_proposals_proposal_category_id"
    t.index ["proposal_state_id"], name: "_idx_proposals_proposal_state_id"
    t.index ["quorum_id"], name: "index_proposals_on_quorum_id", unique: true
    t.index ["updated_at"], name: "index_proposals_on_updated_at"
    t.index ["vote_period_id"], name: "_idx_proposals_vote_period_id"
  end

  create_table "provinces", id: :serial, force: :cascade do |t|
    t.string "description", limit: 100
    t.integer "region_id", null: false
    t.string "sigla", limit: 5
    t.integer "country_id"
    t.integer "population"
    t.integer "continent_id"
    t.integer "geoname_id"
    t.index ["continent_id"], name: "index_provinces_on_continent_id"
    t.index ["country_id"], name: "index_provinces_on_country_id"
  end

  create_table "quorums", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description", limit: 4000
    t.integer "percentage"
    t.integer "valutations"
    t.integer "minutes"
    t.string "condition", limit: 5
    t.integer "bad_score", null: false
    t.integer "good_score", null: false
    t.boolean "active", default: true, null: false
    t.boolean "public", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "ends_at"
    t.integer "seq"
    t.integer "quorum_id"
    t.integer "vote_minutes"
    t.integer "vote_percentage"
    t.integer "vote_valutations"
    t.integer "vote_good_score"
    t.datetime "vote_start_at"
    t.datetime "vote_ends_at"
    t.string "t_percentage", limit: 1
    t.string "t_minutes", limit: 1
    t.string "t_good_score", limit: 1
    t.string "t_vote_percentage", limit: 1
    t.string "t_vote_minutes", limit: 1
    t.string "t_vote_good_score", limit: 1
    t.string "type", limit: 255
    t.boolean "removed", default: false
    t.integer "old_bad_score"
    t.string "old_condition", limit: 5
    t.boolean "assigned", default: false
  end

  create_table "ranking_types", id: :serial, force: :cascade do |t|
    t.string "description", limit: 200, null: false
  end

  create_table "received_emails", id: :serial, force: :cascade do |t|
    t.string "subject", limit: 255
    t.text "body"
    t.string "from", limit: 255
    t.string "to", limit: 255
    t.string "token", limit: 255
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "description", limit: 100
    t.integer "country_id", null: false
    t.integer "continent_id"
    t.integer "geoname_id"
    t.index ["continent_id"], name: "index_regions_on_continent_id"
  end

  create_table "request_vote_types", id: :serial, force: :cascade do |t|
    t.string "description", limit: 10, null: false
  end

  create_table "request_votes", id: :serial, force: :cascade do |t|
    t.integer "group_participation_request_id", null: false
    t.integer "user_id", null: false
    t.integer "request_vote_type_id", null: false
    t.string "comment", limit: 200
  end

  create_table "revision_section_histories", id: :serial, force: :cascade do |t|
    t.integer "proposal_revision_id", null: false
    t.integer "section_history_id", null: false
    t.index ["proposal_revision_id"], name: "index_revision_section_histories_on_proposal_revision_id"
    t.index ["section_history_id"], name: "index_revision_section_histories_on_section_history_id"
  end

  create_table "search_participants", id: :serial, force: :cascade do |t|
    t.integer "role_id"
    t.integer "status_id"
    t.string "keywords", limit: 255
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_proposals", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "group_id"
    t.integer "proposal_category_id"
    t.integer "group_area_id"
    t.integer "proposal_type_id"
    t.integer "proposal_state_id"
    t.integer "tag_id"
    t.integer "interest_border_id"
    t.datetime "created_at_from"
    t.datetime "created_at_to"
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.string "q", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "section_histories", id: :serial, force: :cascade do |t|
    t.integer "section_id"
    t.string "title", limit: 100, null: false
    t.integer "seq", null: false
    t.boolean "added"
    t.boolean "removed"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.integer "seq", null: false
    t.string "question", limit: 20000
  end

  create_table "sent_feedbacks", id: :serial, force: :cascade do |t|
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.text "message"
    t.string "email", limit: 255
    t.text "stack"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "solution_histories", id: :serial, force: :cascade do |t|
    t.integer "proposal_revision_id", null: false
    t.integer "seq", null: false
    t.string "title", limit: 255
    t.boolean "added"
    t.boolean "removed"
    t.index ["proposal_revision_id"], name: "index_solution_histories_on_proposal_revision_id"
  end

  create_table "solution_section_histories", id: :serial, force: :cascade do |t|
    t.integer "solution_history_id", null: false
    t.integer "section_history_id", null: false
    t.index ["section_history_id"], name: "index_solution_section_histories_on_section_history_id"
    t.index ["solution_history_id"], name: "index_solution_section_histories_on_solution_history_id"
  end

  create_table "solution_sections", id: :serial, force: :cascade do |t|
    t.integer "solution_id", null: false
    t.integer "section_id", null: false
    t.index ["section_id"], name: "index_solution_sections_on_section_id", unique: true
  end

  create_table "solutions", id: :serial, force: :cascade do |t|
    t.integer "proposal_id", null: false
    t.integer "seq", null: false
    t.integer "schulze_score"
    t.string "title", limit: 255
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :serial, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
  end

  create_table "stat_num_proposals", id: :serial, force: :cascade do |t|
    t.date "date"
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "value"
  end

  create_table "steps", id: :serial, force: :cascade do |t|
    t.integer "tutorial_id", null: false
    t.integer "index", default: 0, null: false
    t.string "title", limit: 255
    t.text "content"
    t.boolean "required", default: false
    t.text "fragment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "format", limit: 255, default: "html"
  end

  create_table "sys_locales", id: :serial, force: :cascade do |t|
    t.string "key", limit: 255
    t.string "host", limit: 255
    t.string "lang", limit: 255
    t.string "territory_type", limit: 255
    t.integer "territory_id"
    t.boolean "default", default: false
  end

  create_table "sys_payment_notifications", id: :serial, force: :cascade do |t|
    t.text "params"
    t.string "status", limit: 255
    t.string "transaction_id", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "payment_fee"
    t.decimal "payment_gross"
    t.string "first_name", limit: 4000
    t.string "last_name", limit: 4000
    t.integer "payable_id"
    t.string "payable_type", limit: 255
    t.index ["transaction_id"], name: "index_sys_payment_notifications_on_transaction_id", unique: true
  end

  create_table "tag_counters", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "territory_id", null: false
    t.string "territory_type", limit: 255, null: false
    t.integer "proposals_count", default: 0, null: false
    t.integer "blog_posts_count", default: 0, null: false
    t.integer "groups_count", default: 0, null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "text", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "frm_categories_count", default: 0, null: false
    t.integer "frm_forums_count", default: 0, null: false
    t.integer "frm_topics_count", default: 0, null: false
    t.index ["text"], name: "index_tags_on_text", unique: true
  end

  create_table "tutorial_assignees", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tutorial_id", null: false
    t.boolean "completed", default: false, null: false
    t.integer "index", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutorial_progresses", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "step_id", null: false
    t.string "status", limit: 255, default: "N", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutorials", id: :serial, force: :cascade do |t|
    t.string "action", limit: 255
    t.string "controller", limit: 255, null: false
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_borders", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "interest_border_id", null: false
    t.integer "created_at"
    t.index ["user_id"], name: "_idx_user_borders_user_id"
  end

  create_table "user_follows", id: :serial, force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "followed_id"], name: "user_follows_unique", unique: true
  end

  create_table "user_likes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "likeable_id", null: false
    t.string "likeable_type", limit: 255, null: false
  end

  create_table "user_tracings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "sign_in_at"
    t.datetime "sign_out_at"
    t.string "ip", limit: 255
    t.text "user_agent"
    t.index ["user_id"], name: "index_user_tracings_on_user_id"
  end

  create_table "user_types", id: :serial, force: :cascade do |t|
    t.string "description", limit: 200
    t.text "short_name"
    t.index ["short_name"], name: "srt_name_unq", unique: true
  end

  create_table "user_votes", id: :serial, force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "vote_type_id"
    t.string "vote_schulze", limit: 255
    t.string "vote_schulze_desc", limit: 2000
    t.text "comment"
    t.index ["proposal_id", "user_id"], name: "onlyvoteuser", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "user_type_id", default: 3, null: false
    t.string "name", limit: 100
    t.string "surname", limit: 100
    t.string "email", limit: 100
    t.string "sex", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_salt", limit: 40
    t.datetime "remember_token_expires_at"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "deleted_at"
    t.text "state"
    t.string "reset_password_token", limit: 255
    t.string "encrypted_password", limit: 128, null: false
    t.string "blog_image_url", limit: 1000
    t.integer "image_id"
    t.integer "rank"
    t.integer "fb_user_id"
    t.string "email_hash", limit: 255
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.integer "sign_in_count", default: 0
    t.string "account_type", limit: 255
    t.datetime "remember_created_at"
    t.datetime "confirmation_sent_at"
    t.boolean "banned", default: false, null: false
    t.boolean "receive_newsletter", default: false, null: false
    t.datetime "reset_password_sent_at"
    t.string "facebook_page_url", limit: 255
    t.boolean "blocked", default: false
    t.string "unconfirmed_email", limit: 100
    t.string "google_page_url", limit: 255
    t.boolean "show_tooltips", default: true
    t.boolean "show_urls", default: true
    t.boolean "receive_messages", default: true, null: false
    t.string "authentication_token", limit: 255
    t.string "rotp_secret", limit: 16
    t.boolean "rotp_enabled", default: false
    t.string "blocked_name", limit: 255
    t.string "blocked_surname", limit: 255
    t.integer "sys_locale_id", default: 1, null: false
    t.integer "original_sys_locale_id", default: 1, null: false
    t.string "time_zone", limit: 255, default: "Rome"
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "subdomain"
    t.string "derived_interest_borders_tokens", default: [], array: true
    t.index ["email"], name: "uniqueemail", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vote_types", id: :serial, force: :cascade do |t|
    t.string "short", limit: 255
  end

  add_foreign_key "alerts", "notifications", name: "user_alerts_notification_id_fk"
  add_foreign_key "alerts", "users", name: "user_alerts_user_id_fk"
  add_foreign_key "area_participations", "area_roles", name: "area_partecipations_area_role_id_fk"
  add_foreign_key "area_participations", "group_areas", name: "area_partecipations_group_area_id_fk"
  add_foreign_key "area_participations", "users", name: "area_partecipations_user_id_fk"
  add_foreign_key "area_proposals", "group_areas", name: "area_proposals_group_area_id_fk"
  add_foreign_key "area_proposals", "proposals", name: "area_proposals_proposal_id_fk"
  add_foreign_key "area_roles", "group_areas", name: "area_roles_group_area_id_fk"
  add_foreign_key "authentications", "users", name: "authentications_user_id_fk"
  add_foreign_key "available_authors", "proposals", name: "available_authors_proposal_id_fk"
  add_foreign_key "available_authors", "users", name: "available_authors_user_id_fk"
  add_foreign_key "blocked_alerts", "notification_types", name: "blocked_alerts_notification_type_id_fk"
  add_foreign_key "blocked_alerts", "users", name: "blocked_alerts_user_id_fk"
  add_foreign_key "blocked_emails", "notification_types", name: "blocked_emails_notification_type_id_fk"
  add_foreign_key "blocked_emails", "users", name: "blocked_emails_user_id_fk"
  add_foreign_key "blocked_proposal_alerts", "proposals", name: "blocked_proposal_alerts_proposal_id_fk"
  add_foreign_key "blocked_proposal_alerts", "users", name: "blocked_proposal_alerts_user_id_fk"
  add_foreign_key "blog_comments", "blog_comments", column: "parent_blog_comment_id", name: "blog_comments_parent_blog_comment_id_fk"
  add_foreign_key "blog_comments", "blog_posts", name: "blog_comments_blog_post_id_fk"
  add_foreign_key "blog_comments", "users", name: "blog_comments_user_id_fk"
  add_foreign_key "blog_post_tags", "blog_posts", name: "blog_post_tags_blog_post_id_fk"
  add_foreign_key "blog_post_tags", "tags", name: "blog_post_tags_tag_id_fk"
  add_foreign_key "blog_posts", "blogs", name: "blog_posts_blog_id_fk"
  add_foreign_key "blog_posts", "users", name: "blog_posts_user_id_fk"
  add_foreign_key "blogs", "users", name: "blogs_user_id_fk"
  add_foreign_key "countries", "continents", name: "statos_continente_id_fk"
  add_foreign_key "districts", "continents", name: "circoscriziones_continente_id_fk"
  add_foreign_key "districts", "countries", name: "circoscriziones_stato_id_fk"
  add_foreign_key "districts", "provinces", name: "circoscriziones_provincia_id_fk"
  add_foreign_key "districts", "regions", name: "circoscriziones_regione_id_fk"
  add_foreign_key "event_comment_likes", "event_comments", name: "event_comment_likes_event_comment_id_fk"
  add_foreign_key "event_comment_likes", "users", name: "event_comment_likes_user_id_fk"
  add_foreign_key "event_comments", "event_comments", column: "parent_event_comment_id", name: "event_comments_parent_event_comment_id_fk"
  add_foreign_key "event_comments", "events", name: "event_comments_event_id_fk"
  add_foreign_key "event_comments", "users", name: "event_comments_user_id_fk"
  add_foreign_key "events", "event_types", name: "events_event_type_id_fk"
  add_foreign_key "events", "users", name: "events_user_id_fk"
  add_foreign_key "frm_categories", "groups", name: "frm_categories_group_id_fk"
  add_foreign_key "frm_category_tags", "frm_categories", name: "frm_category_tags_frm_category_id_fk"
  add_foreign_key "frm_category_tags", "tags", name: "frm_category_tags_tag_id_fk"
  add_foreign_key "frm_forum_tags", "frm_forums", name: "frm_forum_tags_frm_forum_id_fk"
  add_foreign_key "frm_forum_tags", "tags", name: "frm_forum_tags_tag_id_fk"
  add_foreign_key "frm_forums", "groups", name: "frm_forums_group_id_fk"
  add_foreign_key "frm_mods", "groups", name: "frm_groups_group_id_fk"
  add_foreign_key "frm_topic_tags", "frm_topics", name: "frm_topic_tags_frm_topic_id_fk"
  add_foreign_key "frm_topic_tags", "tags", name: "frm_topic_tags_tag_id_fk"
  add_foreign_key "group_areas", "area_roles", name: "group_areas_area_role_id_fk"
  add_foreign_key "group_areas", "groups", name: "group_areas_group_id_fk"
  add_foreign_key "group_invitations", "users", column: "inviter_id", name: "group_invitations_inviter_id_fk"
  add_foreign_key "group_participation_requests", "group_participation_request_statuses", name: "parent_fk"
  add_foreign_key "group_participation_requests", "groups", name: "group_partecipation_requests_group_id_fk"
  add_foreign_key "group_participation_requests", "users", name: "group_partecipation_requests_user_id_fk"
  add_foreign_key "group_participations", "groups", name: "group_partecipations_group_id_fk"
  add_foreign_key "group_participations", "participation_roles", name: "group_partecipations_partecipation_role_id_fk"
  add_foreign_key "group_participations", "users", name: "group_partecipations_user_id_fk"
  add_foreign_key "group_proposals", "groups", name: "group_proposals_group_id_fk"
  add_foreign_key "group_proposals", "proposals", name: "group_proposals_proposal_id_fk"
  add_foreign_key "group_quorums", "groups", name: "group_quorums_group_id_fk"
  add_foreign_key "group_quorums", "quorums", name: "group_quorums_quorum_id_fk"
  add_foreign_key "group_tags", "groups", name: "group_tags_group_id_fk"
  add_foreign_key "group_tags", "tags", name: "group_tags_tag_id_fk"
  add_foreign_key "groups", "interest_borders", name: "groups_interest_border_id_fk"
  add_foreign_key "groups", "participation_roles", name: "groups_partecipation_role_id_fk"
  add_foreign_key "integrated_contributes", "proposal_comments", name: "integrated_contributes_proposal_comment_id_fk"
  add_foreign_key "integrated_contributes", "proposal_revisions", name: "integrated_contributes_proposal_revision_id_fk"
  add_foreign_key "meeting_organizations", "groups", name: "meeting_organizations_group_id_fk"
  add_foreign_key "meeting_participations", "meetings", name: "meeting_partecipations_meeting_id_fk"
  add_foreign_key "meeting_participations", "users", name: "meeting_partecipations_user_id_fk"
  add_foreign_key "meetings", "events", name: "meetings_event_id_fk"
  add_foreign_key "meetings", "places", name: "meetings_place_id_fk"
  add_foreign_key "municipalities", "continents", name: "comunes_continente_id_fk"
  add_foreign_key "municipalities", "countries", name: "comunes_stato_id_fk"
  add_foreign_key "municipalities", "regions", name: "comunes_regione_id_fk"
  add_foreign_key "notification_data", "notifications", name: "notification_data_notification_id_fk"
  add_foreign_key "notifications", "notification_types", name: "notifications_notification_type_id_fk"
  add_foreign_key "old_proposal_presentations", "proposal_lives", name: "old_proposal_presentations_proposal_life_id_fk"
  add_foreign_key "old_proposal_presentations", "users", name: "old_proposal_presentations_user_id_fk"
  add_foreign_key "paragraph_histories", "proposals", name: "paragraph_histories_proposal_id_fk"
  add_foreign_key "paragraphs", "sections", name: "paragraphs_section_id_fk"
  add_foreign_key "participation_roles", "groups", name: "partecipation_roles_group_id_fk"
  add_foreign_key "post_publishings", "blog_posts", name: "post_publishings_blog_post_id_fk"
  add_foreign_key "post_publishings", "groups", name: "post_publishings_group_id_fk"
  add_foreign_key "proposal_borders", "interest_borders", name: "proposal_borders_interest_border_id_fk"
  add_foreign_key "proposal_borders", "proposals", name: "proposal_borders_proposal_id_fk"
  add_foreign_key "proposal_categories", "proposal_categories", column: "parent_proposal_category_id", name: "proposal_categories_parent_proposal_category_id_fk"
  add_foreign_key "proposal_comment_rankings", "proposal_comments", name: "proposal_comment_rankings_proposal_comment_id_fk"
  add_foreign_key "proposal_comment_rankings", "ranking_types", name: "proposal_comment_rankings_ranking_type_id_fk"
  add_foreign_key "proposal_comment_rankings", "users", name: "proposal_comment_rankings_user_id_fk"
  add_foreign_key "proposal_comment_reports", "proposal_comment_report_types", name: "proposal_comment_reports_proposal_comment_report_type_id_fk"
  add_foreign_key "proposal_comments", "paragraphs", name: "proposal_comments_paragraph_id_fk"
  add_foreign_key "proposal_comments", "proposals", name: "proposal_comments_proposal_id_fk"
  add_foreign_key "proposal_comments", "users", name: "proposal_comments_deleted_user_id_fk"
  add_foreign_key "proposal_comments", "users", name: "proposal_comments_user_id_fk"
  add_foreign_key "proposal_lives", "proposals", name: "proposal_lives_proposal_id_fk"
  add_foreign_key "proposal_lives", "quorums", name: "proposal_lives_quorum_id_fk"
  add_foreign_key "proposal_nicknames", "proposals", name: "proposal_nicknames_proposal_id_fk"
  add_foreign_key "proposal_nicknames", "users", name: "proposal_nicknames_user_id_fk"
  add_foreign_key "proposal_presentations", "proposals", name: "proposal_presentations_proposal_id_fk"
  add_foreign_key "proposal_presentations", "users", name: "proposal_presentations_user_id_fk"
  add_foreign_key "proposal_rankings", "proposals", name: "proposal_rankings_proposal_id_fk"
  add_foreign_key "proposal_rankings", "users", name: "proposal_rankings_user_id_fk"
  add_foreign_key "proposal_revisions", "proposals", name: "proposal_revisions_proposal_id_fk"
  add_foreign_key "proposal_schulze_votes", "proposals", name: "proposal_schulze_votes_proposal_id_fk"
  add_foreign_key "proposal_sections", "proposals", name: "proposal_sections_proposal_id_fk"
  add_foreign_key "proposal_sections", "sections", name: "proposal_sections_section_id_fk"
  add_foreign_key "proposal_supports", "groups", name: "proposal_supports_group_id_fk"
  add_foreign_key "proposal_supports", "proposals", name: "proposal_supports_proposal_id_fk"
  add_foreign_key "proposal_tags", "proposals", name: "proposal_tags_proposal_id_fk"
  add_foreign_key "proposal_tags", "tags", name: "proposal_tags_tag_id_fk"
  add_foreign_key "proposal_votes", "proposals", name: "proposal_votes_proposal_id_fk"
  add_foreign_key "proposals", "events", column: "vote_event_id", name: "proposals_vote_event_id_fk"
  add_foreign_key "proposals", "events", column: "vote_period_id", name: "proposals_vote_period_id_fk"
  add_foreign_key "proposals", "proposal_categories", name: "proposals_proposal_category_id_fk"
  add_foreign_key "proposals", "proposal_states", name: "proposals_proposal_state_id_fk"
  add_foreign_key "proposals", "proposal_types", name: "proposals_proposal_type_id_fk"
  add_foreign_key "proposals", "proposal_votation_types", name: "proposals_proposal_votation_type_id_fk"
  add_foreign_key "proposals", "quorums", name: "proposals_quorum_id_fk"
  add_foreign_key "provinces", "continents", name: "provincias_continente_id_fk"
  add_foreign_key "provinces", "countries", name: "provincias_stato_id_fk"
  add_foreign_key "quorums", "quorums", name: "quorums_quorum_id_fk"
  add_foreign_key "regions", "continents", name: "regiones_continente_id_fk"
  add_foreign_key "regions", "countries", name: "regiones_stato_id_fk"
  add_foreign_key "revision_section_histories", "proposal_revisions", name: "revision_section_histories_proposal_revision_id_fk"
  add_foreign_key "revision_section_histories", "section_histories", name: "revision_section_histories_section_history_id_fk"
  add_foreign_key "solution_histories", "proposal_revisions", name: "solution_histories_proposal_revision_id_fk"
  add_foreign_key "solution_section_histories", "section_histories", name: "solution_section_histories_section_history_id_fk"
  add_foreign_key "solution_section_histories", "solution_histories", name: "solution_section_histories_solution_history_id_fk"
  add_foreign_key "solution_sections", "sections", name: "solution_sections_section_id_fk"
  add_foreign_key "solution_sections", "solutions", name: "solution_sections_solution_id_fk"
  add_foreign_key "solutions", "proposals", name: "solutions_proposal_id_fk"
  add_foreign_key "tutorial_assignees", "tutorials", name: "tutorial_assignees_tutorial_id_fk"
  add_foreign_key "tutorial_assignees", "users", name: "tutorial_assignees_user_id_fk"
  add_foreign_key "tutorial_progresses", "steps", name: "tutorial_progresses_step_id_fk"
  add_foreign_key "tutorial_progresses", "users", name: "tutorial_progresses_user_id_fk"
  add_foreign_key "user_borders", "interest_borders", name: "user_borders_interest_border_id_fk"
  add_foreign_key "user_borders", "users", name: "user_borders_user_id_fk"
  add_foreign_key "user_follows", "users", column: "followed_id", name: "user_follows_followed_id_fk"
  add_foreign_key "user_follows", "users", column: "follower_id", name: "user_follows_follower_id_fk"
  add_foreign_key "user_likes", "users", name: "user_likes_user_id_fk"
  add_foreign_key "user_votes", "users", name: "user_votes_user_id_fk"
  add_foreign_key "user_votes", "vote_types", name: "user_votes_vote_type_id_fk"
  add_foreign_key "users", "images", name: "users_image_id_fk"
  add_foreign_key "users", "user_types", name: "users_user_type_id_fk"
end
