# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120603214719) do

  create_table "action_abilitations", :force => true do |t|
    t.integer  "group_action_id"
    t.integer  "partecipation_role_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.string  "provider"
    t.string  "token"
    t.string  "uid",      :limit => 100
  end

  create_table "blocked_alerts", :force => true do |t|
    t.integer "notification_type_id"
    t.integer "user_id"
  end

  create_table "blog_comments", :force => true do |t|
    t.integer  "parent_blog_comment_id"
    t.integer  "blog_post_id"
    t.integer  "user_id"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.string   "name"
    t.string   "site_url"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_entries", :force => true do |t|
    t.integer "blog_id"
  end

  create_table "blog_post_images", :force => true do |t|
    t.integer "blog_post_id", :null => false
    t.integer "image_id",     :null => false
  end

  add_index "blog_post_images", ["blog_post_id", "image_id"], :name => "Constraint0", :unique => true

  create_table "blog_post_tags", :force => true do |t|
    t.integer "blog_post_id"
    t.integer "tag_id",       :null => false
  end

  add_index "blog_post_tags", ["blog_post_id", "tag_id"], :name => "index_blog_post_tags_on_blog_post_id_and_tag_id", :unique => true

  create_table "blog_posts", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title",                           :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",    :default => false, :null => false
    t.datetime "published_at"
    t.integer  "user_id"
  end

  create_table "blog_tags", :force => true do |t|
    t.integer "blog_id"
    t.integer "tag_id",  :null => false
  end

  add_index "blog_tags", ["blog_id", "tag_id"], :name => "index_blog_tags_on_blog_id_and_tag_id", :unique => true

  create_table "blogs", :force => true do |t|
    t.integer "user_id"
    t.string  "title"
  end

  create_table "candidates", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "election_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidates", ["user_id", "election_id"], :name => "index_candidates_on_user_id_and_election_id", :unique => true

  create_table "circoscriziones", :force => true do |t|
    t.integer "comune_id"
    t.string  "description", :limit => 100
  end

  create_table "circoscrizioni_groups", :id => false, :force => true do |t|
    t.integer "id",                                                  :null => false
    t.string  "name",               :limit => 200
    t.string  "description",        :limit => 2000
    t.string  "accept_requests",    :limit => 1,    :default => "v", :null => false
    t.integer "interest_border_id"
    t.integer "circoscrizione_id"
    t.string  "facebook_page_url"
    t.integer "image_id"
    t.string  "title_bar"
    t.string  "image_url"
  end

  create_table "comunali_groups", :id => false, :force => true do |t|
    t.integer "id",                                                  :null => false
    t.string  "name",               :limit => 200
    t.string  "description",        :limit => 2000
    t.string  "accept_requests",    :limit => 1,    :default => "v", :null => false
    t.integer "interest_border_id"
    t.integer "comune_id"
    t.string  "facebook_page_url"
    t.integer "image_id"
    t.string  "title_bar"
    t.string  "image_url"
  end

  create_table "comunes", :force => true do |t|
    t.string  "description",  :limit => 100, :null => false
    t.integer "provincia_id",                :null => false
    t.integer "regione_id",                  :null => false
    t.integer "population"
    t.string  "codistat",     :limit => 4
    t.string  "cap",          :limit => 5
  end

  create_table "election_votes", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "election_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "election_votes", ["user_id", "election_id"], :name => "index_election_votes_on_user_id_and_election_id", :unique => true

  create_table "elections", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "description",                          :null => false
    t.integer  "event_id",                             :null => false
    t.datetime "groups_end_time",                      :null => false
    t.datetime "candidates_end_time",                  :null => false
    t.string   "status",              :default => "1", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_series", :force => true do |t|
    t.integer  "frequency",  :default => 1
    t.string   "period",     :default => "months"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string "description", :limit => 200
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "event_series_id"
    t.integer  "event_type_id"
  end

  add_index "events", ["event_series_id"], :name => "index_events_on_event_series_id"

  create_table "group_actions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_affinities", :force => true do |t|
    t.integer  "group_id",                       :null => false
    t.integer  "user_id",                        :null => false
    t.integer  "value"
    t.boolean  "recalculate", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_elections", :force => true do |t|
    t.integer  "group_id",    :null => false
    t.integer  "election_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_elections", ["group_id", "election_id"], :name => "index_group_elections_on_group_id_and_election_id", :unique => true

  create_table "group_follows", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "group_id", :null => false
  end

  create_table "group_partecipation_request_statuses", :force => true do |t|
    t.string "description", :limit => 200, :null => false
  end

  create_table "group_partecipation_requests", :force => true do |t|
    t.integer "user_id",                                              :null => false
    t.integer "group_id",                                             :null => false
    t.integer "group_partecipation_request_status_id", :default => 1, :null => false
  end

  add_index "group_partecipation_requests", ["user_id", "group_id"], :name => "unique", :unique => true

  create_table "group_partecipations", :force => true do |t|
    t.integer "user_id",                              :null => false
    t.integer "group_id",                             :null => false
    t.integer "partecipation_role_id", :default => 1, :null => false
  end

  add_index "group_partecipations", ["user_id", "group_id"], :name => "only_once_per_group", :unique => true

  create_table "groups", :force => true do |t|
    t.string  "name",               :limit => 200
    t.string  "description",        :limit => 2000
    t.string  "accept_requests",    :limit => 1,    :default => "v", :null => false
    t.integer "interest_border_id"
    t.string  "facebook_page_url"
    t.integer "image_id"
    t.string  "title_bar"
    t.string  "image_url"
  end

  create_table "images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interest_borders", :force => true do |t|
    t.integer "territory_id",   :null => false
    t.string  "territory_type", :null => false
  end

  create_table "meeting_organizations", :force => true do |t|
    t.integer "group_id"
    t.integer "event_id"
  end

  create_table "meeting_partecipations", :force => true do |t|
    t.integer "user_id"
    t.integer "meeting_id"
    t.string  "comment"
    t.integer "guests",                  :default => 0, :null => false
    t.string  "response",   :limit => 1
  end

  create_table "meetings", :force => true do |t|
    t.integer "place_id"
    t.integer "event_id"
  end

  create_table "notification_categories", :force => true do |t|
    t.string "description"
  end

  create_table "notification_types", :force => true do |t|
    t.string  "description",              :null => false
    t.integer "notification_category_id", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notification_type_id",                 :null => false
    t.string   "message",              :limit => 1000
    t.string   "url"
  end

  create_table "partecipation_roles", :force => true do |t|
    t.integer "parent_partecipation_role_id"
    t.integer "group_id"
    t.string  "name",                         :limit => 200
    t.string  "description",                  :limit => 2000
  end

  create_table "periods", :force => true do |t|
    t.datetime "from", :null => false
    t.datetime "to",   :null => false
  end

  add_index "periods", ["from", "to"], :name => "from_to_unique", :unique => true

  create_table "places", :force => true do |t|
    t.integer "comune_id"
    t.string  "frazione",           :limit => 200
    t.string  "address",            :limit => 200
    t.string  "civic_number",       :limit => 10
    t.string  "cap",                :limit => 5
    t.float   "latitude_original"
    t.float   "longitude_original"
    t.float   "latitude_center"
    t.float   "longitude_center"
    t.integer "zoom"
  end

  create_table "post_publishings", :force => true do |t|
    t.integer "blog_post_id"
    t.integer "group_id"
  end

  create_table "proposal_borders", :force => true do |t|
    t.integer "proposal_id",        :null => false
    t.integer "interest_border_id", :null => false
    t.integer "created_at"
  end

  add_index "proposal_borders", ["proposal_id"], :name => "_idx_proposal_borderds_proposal_id"

  create_table "proposal_categories", :force => true do |t|
    t.integer "parent_proposal_category_id"
    t.string  "description",                 :limit => 200
  end

  create_table "proposal_comment_rankings", :force => true do |t|
    t.integer  "proposal_comment_id", :null => false
    t.integer  "user_id",             :null => false
    t.integer  "ranking_type_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_comment_rankings", ["proposal_comment_id", "user_id"], :name => "user_comment", :unique => true

  create_table "proposal_comments", :force => true do |t|
    t.integer  "parent_proposal_comment_id"
    t.integer  "user_id"
    t.integer  "proposal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "deleted",                                    :default => false, :null => false
    t.integer  "deleted_user_id"
    t.datetime "deleted_at"
    t.string   "content",                    :limit => 2000
  end

  create_table "proposal_histories", :force => true do |t|
    t.integer  "proposal_id",                  :null => false
    t.integer  "user_id",                      :null => false
    t.string   "content",     :limit => 20000, :null => false
    t.string   "problem",     :limit => 20000
    t.integer  "valutations",                  :null => false
    t.integer  "rank",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposal_presentations", :force => true do |t|
    t.integer  "proposal_id", :null => false
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_presentations", ["proposal_id"], :name => "_idx_proposal_presentations_proposal_id"
  add_index "proposal_presentations", ["user_id"], :name => "_idx_proposal_presentations_user_id"

  create_table "proposal_rankings", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.integer  "ranking_type_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "proposal_rankings", ["proposal_id", "user_id"], :name => "proposal_user", :unique => true

  create_table "proposal_states", :force => true do |t|
    t.string "description", :limit => 200
  end

  create_table "proposal_supports", :force => true do |t|
    t.integer  "proposal_id", :null => false
    t.integer  "group_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposal_tags", :force => true do |t|
    t.integer  "proposal_id", :null => false
    t.integer  "tag_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_tags", ["proposal_id", "tag_id"], :name => "index_proposal_tags_on_proposal_id_and_tag_id", :unique => true

  create_table "proposal_votes", :force => true do |t|
    t.integer  "proposal_id", :limit => 8
    t.integer  "positive"
    t.integer  "negative"
    t.integer  "neutral"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposal_watches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "proposal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "proposal_state_id"
    t.integer  "proposal_category_id",                     :default => 5,    :null => false
    t.string   "title",                   :limit => 200,                     :null => false
    t.string   "content",                 :limit => 20000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "valutations",                              :default => 0
    t.integer  "vote_period_id"
    t.integer  "proposal_comments_count",                  :default => 0
    t.integer  "rank",                                     :default => 0,    :null => false
    t.string   "problem",                 :limit => 20000
    t.string   "subtitle",                                 :default => "",   :null => false
    t.string   "problems",                :limit => 18000, :default => "",   :null => false
    t.string   "objectives",              :limit => 18000, :default => "",   :null => false
    t.boolean  "show_comment_authors",                     :default => true, :null => false
  end

  add_index "proposals", ["proposal_category_id"], :name => "_idx_proposals_proposal_category_id"
  add_index "proposals", ["proposal_state_id"], :name => "_idx_proposals_proposal_state_id"
  add_index "proposals", ["vote_period_id"], :name => "_idx_proposals_vote_period_id"

  create_table "provas", :force => true do |t|
    t.string   "testo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinciali_groups", :id => false, :force => true do |t|
    t.integer "id",                                                  :null => false
    t.string  "name",               :limit => 200
    t.string  "description",        :limit => 2000
    t.string  "accept_requests",    :limit => 1,    :default => "v", :null => false
    t.integer "interest_border_id"
    t.integer "provincia_id"
    t.string  "facebook_page_url"
    t.integer "image_id"
    t.string  "title_bar"
    t.string  "image_url"
  end

  create_table "provincias", :force => true do |t|
    t.string  "description", :limit => 100
    t.integer "regione_id",                 :null => false
    t.string  "sigla",       :limit => 5
  end

  create_table "ranking_types", :force => true do |t|
    t.string "description", :limit => 200, :null => false
  end

  create_table "regionali_groups", :id => false, :force => true do |t|
    t.integer "id",                                                  :null => false
    t.string  "name",               :limit => 200
    t.string  "description",        :limit => 2000
    t.string  "accept_requests",    :limit => 1,    :default => "v", :null => false
    t.integer "interest_border_id"
    t.integer "regione_id"
    t.string  "facebook_page_url"
    t.integer "image_id"
    t.string  "title_bar"
    t.string  "image_url"
  end

  create_table "regiones", :force => true do |t|
    t.string "description", :limit => 100
  end

  create_table "request_vote_types", :force => true do |t|
    t.string "description", :limit => 10, :null => false
  end

  create_table "request_votes", :force => true do |t|
    t.integer "group_partecipation_request_id",                :null => false
    t.integer "user_id",                                       :null => false
    t.integer "request_vote_type_id",                          :null => false
    t.string  "comment",                        :limit => 200
  end

  create_table "schulze_votes", :force => true do |t|
    t.integer  "election_id",                :null => false
    t.string   "preferences",                :null => false
    t.integer  "count",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schulze_votes", ["election_id", "preferences"], :name => "index_schulze_votes_on_election_id_and_preferences", :unique => true

  create_table "simple_votes", :force => true do |t|
    t.integer  "candidate_id",                :null => false
    t.integer  "count",        :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_votes", ["candidate_id"], :name => "index_simple_votes_on_candidate_id", :unique => true

  create_table "steps", :force => true do |t|
    t.integer  "tutorial_id",                    :null => false
    t.integer  "index",       :default => 0,     :null => false
    t.string   "title"
    t.text     "content"
    t.boolean  "required",    :default => false
    t.text     "fragment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supporters", :force => true do |t|
    t.integer  "candidate_id", :null => false
    t.integer  "group_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supporters", ["candidate_id", "group_id"], :name => "index_supporters_on_candidate_id_and_group_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "text",                            :null => false
    t.integer  "proposals_count",  :default => 0, :null => false
    t.integer  "blog_posts_count", :default => 0, :null => false
    t.integer  "blogs_count",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["text"], :name => "index_tags_on_text", :unique => true

  create_table "testi_vari", :id => false, :force => true do |t|
    t.integer "id",                      :null => false
    t.string  "testo_a", :limit => 4000
    t.string  "testo_b", :limit => 4000
  end

  create_table "tutorial_assignees", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "tutorial_id",                    :null => false
    t.boolean  "completed",   :default => false, :null => false
    t.integer  "index",       :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutorial_progresses", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.integer  "step_id",                     :null => false
    t.string   "status",     :default => "N", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutorials", :force => true do |t|
    t.string   "action"
    t.string   "controller",  :null => false
    t.string   "name"
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_alerts", :force => true do |t|
    t.integer  "notification_id", :null => false
    t.integer  "user_id"
    t.boolean  "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checked_at"
  end

  create_table "user_borders", :force => true do |t|
    t.integer "user_id",            :null => false
    t.integer "interest_border_id", :null => false
    t.integer "created_at"
  end

  add_index "user_borders", ["user_id"], :name => "_idx_user_borders_user_id"

  create_table "user_follows", :force => true do |t|
    t.integer  "follower_id", :null => false
    t.integer  "followed_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_follows", ["follower_id", "followed_id"], :name => "user_follows_unique", :unique => true

  create_table "user_types", :force => true do |t|
    t.string "description", :limit => 200
    t.string "short_name",  :limit => nil
  end

  add_index "user_types", ["short_name"], :name => "srt_name_unq", :unique => true

  create_table "user_votes", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_votes", ["proposal_id", "user_id"], :name => "onlyvoteuser", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "user_type_id",                              :default => 3,     :null => false
    t.integer  "residenza_id"
    t.integer  "nascita_id"
    t.string   "name",                      :limit => 100
    t.string   "surname",                   :limit => 100
    t.string   "email",                     :limit => 100
    t.string   "sex",                       :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                     :limit => 40
    t.string   "password_salt",             :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "deleted_at"
    t.string   "state",                     :limit => nil
    t.string   "reset_password_token"
    t.string   "encrypted_password",        :limit => 128,                     :null => false
    t.boolean  "activist",                                  :default => false, :null => false
    t.boolean  "elected",                                   :default => false, :null => false
    t.string   "blog_image_url",            :limit => 1000
    t.integer  "image_id"
    t.integer  "rank"
    t.integer  "fb_user_id"
    t.string   "email_hash"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count",                             :default => 0
    t.string   "account_type"
    t.datetime "remember_created_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "banned",                                    :default => false, :null => false
    t.boolean  "email_alerts",                              :default => false, :null => false
  end

  add_index "users", ["email"], :name => "uniqueemail", :unique => true
  add_index "users", ["login"], :name => "uniquelogin", :unique => true

  add_foreign_key "action_abilitations", "group_actions", :name => "action_abilitations_group_action_id_fk"
  add_foreign_key "action_abilitations", "partecipation_roles", :name => "action_abilitations_partecipation_role_id_fk"

  add_foreign_key "authentications", "users", :name => "Ref_authentications_to_users"

  add_foreign_key "blocked_alerts", "notification_types", :name => "Ref_blocked_alerts_to_notification_types"
  add_foreign_key "blocked_alerts", "users", :name => "Ref_blocked_alerts_to_users"

  add_foreign_key "blog_comments", "blog_comments", :name => "Ref_blog_comments_to_blog_comments", :column => "parent_blog_comment_id"
  add_foreign_key "blog_comments", "blog_posts", :name => "Ref_blog_comments_to_blog_entries"
  add_foreign_key "blog_comments", "users", :name => "Ref_blog_comments_to_users"

  add_foreign_key "blog_entries", "blogs", :name => "Ref_blog_entries_to_blogs"

  add_foreign_key "blog_post_images", "blog_posts", :name => "Ref_blog_post_images_to_blog_posts"
  add_foreign_key "blog_post_images", "images", :name => "Ref_blog_post_images_to_images"

  add_foreign_key "blog_post_tags", "blog_posts", :name => "Ref_blog_tags_to_blog_posts"
  add_foreign_key "blog_post_tags", "tags", :name => "blog_post_tags_tag_id_fk"

  add_foreign_key "blog_posts", "blogs", :name => "Ref_blog_entries_to_blogs"
  add_foreign_key "blog_posts", "users", :name => "Ref_blog_posts_to_users"

  add_foreign_key "blog_tags", "blogs", :name => "Ref_blog_tags_to_blogs"
  add_foreign_key "blog_tags", "tags", :name => "blog_tags_tag_id_fk"

  add_foreign_key "blogs", "users", :name => "Ref_blogs_to_users"

  add_foreign_key "candidates", "elections", :name => "candidates_election_id_fk"
  add_foreign_key "candidates", "users", :name => "candidates_user_id_fk"

  add_foreign_key "circoscriziones", "comunes", :name => "Ref_circoscriziones_to_comunes"

  add_foreign_key "circoscrizioni_groups", "circoscriziones", :name => "Ref_circoscrizioni_groups_to_circoscriziones"

  add_foreign_key "comunali_groups", "comunes", :name => "Ref_comunali_groups_to_comunes"

  add_foreign_key "election_votes", "elections", :name => "election_votes_election_id_fk"
  add_foreign_key "election_votes", "users", :name => "election_votes_user_id_fk"

  add_foreign_key "elections", "events", :name => "elections_event_id_fk"

  add_foreign_key "events", "event_series", :name => "Ref_events_to_event_series"
  add_foreign_key "events", "event_types", :name => "Ref_events_to_event_types"

  add_foreign_key "group_affinities", "groups", :name => "group_affinities_group_id_fk"
  add_foreign_key "group_affinities", "users", :name => "group_affinities_user_id_fk"

  add_foreign_key "group_elections", "elections", :name => "group_elections_election_id_fk"
  add_foreign_key "group_elections", "groups", :name => "group_elections_group_id_fk"

  add_foreign_key "group_follows", "groups", :name => "Ref_group_follows_to_groups"
  add_foreign_key "group_follows", "users", :name => "Ref_group_follows_to_users"

  add_foreign_key "group_partecipation_requests", "group_partecipation_request_statuses", :name => "Ref_group_partecipation_requests_to_group_partecipation_request"
  add_foreign_key "group_partecipation_requests", "groups", :name => "Ref_group_partecipation_requests_to_groups"
  add_foreign_key "group_partecipation_requests", "users", :name => "Ref_group_partecipation_requests_to_users"

  add_foreign_key "group_partecipations", "groups", :name => "Ref_groups_partecipations_to_groups"
  add_foreign_key "group_partecipations", "partecipation_roles", :name => "Ref_groups_partecipations_to_partecipation_roles"
  add_foreign_key "group_partecipations", "users", :name => "Ref_groups_partecipations_to_users"

  add_foreign_key "groups", "interest_borders", :name => "Ref_groups_to_interest_borders"

  add_foreign_key "meeting_organizations", "events", :name => "Ref_meetings_organizations_to_events"
  add_foreign_key "meeting_organizations", "groups", :name => "Ref_meetings_organizations_to_groups"

  add_foreign_key "meeting_partecipations", "meetings", :name => "Ref_meetings_partecipations_to_meetings"
  add_foreign_key "meeting_partecipations", "users", :name => "Ref_meetings_partecipations_to_users"

  add_foreign_key "meetings", "events", :name => "Ref_meetings_to_events"
  add_foreign_key "meetings", "places", :name => "Ref_meetings_to_places"

  add_foreign_key "notification_types", "notification_categories", :name => "Ref_notification_types_to_notification_categories"

  add_foreign_key "notifications", "notification_types", :name => "Ref_notifications_to_notification_type"

  add_foreign_key "partecipation_roles", "groups", :name => "Ref_partecipation_roles_to_groups"
  add_foreign_key "partecipation_roles", "partecipation_roles", :name => "Ref_partecipation_roles_to_partecipation_roles", :column => "parent_partecipation_role_id"

  add_foreign_key "places", "comunes", :name => "Ref_places_to_comunes"

  add_foreign_key "post_publishings", "blog_posts", :name => "Ref_post_publishings_to_blog_posts"
  add_foreign_key "post_publishings", "groups", :name => "Ref_post_publishings_to_groups"

  add_foreign_key "proposal_borders", "interest_borders", :name => "Ref_proposal_borders_to_interest_borders"
  add_foreign_key "proposal_borders", "proposals", :name => "Ref_proposal_borders_to_proposals"

  add_foreign_key "proposal_comment_rankings", "proposal_comments", :name => "Ref_proposal_comment_rankings_to_proposal_comments"
  add_foreign_key "proposal_comment_rankings", "ranking_types", :name => "Ref_proposal_comment_rankings_to_ranking_types"
  add_foreign_key "proposal_comment_rankings", "users", :name => "Ref_proposal_comment_rankings_to_users"

  add_foreign_key "proposal_comments", "proposal_comments", :name => "Ref_proposal_comments_to_proposal_comments", :column => "parent_proposal_comment_id"
  add_foreign_key "proposal_comments", "proposals", :name => "Ref_proposal_comments_to_proposals"
  add_foreign_key "proposal_comments", "users", :name => "Ref_proposal_comments_to_users"
  add_foreign_key "proposal_comments", "users", :name => "Ref_proposal_comments_to_users0", :column => "deleted_user_id"

  add_foreign_key "proposal_presentations", "proposals", :name => "Ref_proposals_presentations_to_proposals"
  add_foreign_key "proposal_presentations", "users", :name => "Ref_proposals_presentations_to_users"

  add_foreign_key "proposal_rankings", "proposals", :name => "Ref_proposal_rankings_to_proposals"
  add_foreign_key "proposal_rankings", "ranking_types", :name => "Ref_proposal_rankings_to_ranking_types"
  add_foreign_key "proposal_rankings", "users", :name => "Ref_proposal_rankings_to_users"

  add_foreign_key "proposal_supports", "groups", :name => "Ref_proposal_supports_to_groups"
  add_foreign_key "proposal_supports", "proposals", :name => "Ref_proposal_supports_to_proposals"

  add_foreign_key "proposal_tags", "proposals", :name => "proposal_tags_proposal_id_fk"
  add_foreign_key "proposal_tags", "tags", :name => "proposal_tags_tag_id_fk"

  add_foreign_key "proposal_votes", "proposals", :name => "Ref_proposal_votes_to_proposals"

  add_foreign_key "proposal_watches", "proposals", :name => "Ref_proposal_watches_to_proposals"
  add_foreign_key "proposal_watches", "users", :name => "Ref_proposal_watches_to_users"

  add_foreign_key "proposals", "events", :name => "Ref_proposals_to_events", :column => "vote_period_id"
  add_foreign_key "proposals", "proposal_categories", :name => "Ref_proposals_to_proposal_categories"
  add_foreign_key "proposals", "proposal_states", :name => "Ref_proposals_to_proposal_states"

  add_foreign_key "provinciali_groups", "provincias", :name => "Ref_provinciali_groups_to_provincias"

  add_foreign_key "regionali_groups", "regiones", :name => "Ref_regionali_groups_to_regiones"

  add_foreign_key "request_votes", "group_partecipation_requests", :name => "Ref_request_votes_to_group_partecipation_requests"
  add_foreign_key "request_votes", "request_vote_types", :name => "Ref_request_votes_to_request_vote_types"
  add_foreign_key "request_votes", "users", :name => "Ref_request_votes_to_users"

  add_foreign_key "schulze_votes", "elections", :name => "schulze_votes_election_id_fk"

  add_foreign_key "simple_votes", "candidates", :name => "simple_votes_candidate_id_fk"

  add_foreign_key "steps", "tutorials", :name => "steps_tutorial_id_fk"

  add_foreign_key "supporters", "candidates", :name => "supporters_candidate_id_fk"
  add_foreign_key "supporters", "groups", :name => "supporters_group_id_fk"

  add_foreign_key "tutorial_assignees", "tutorials", :name => "tutorial_assignees_tutorial_id_fk"
  add_foreign_key "tutorial_assignees", "users", :name => "tutorial_assignees_user_id_fk"

  add_foreign_key "tutorial_progresses", "steps", :name => "tutorial_progresses_step_id_fk"
  add_foreign_key "tutorial_progresses", "users", :name => "tutorial_progresses_user_id_fk"

  add_foreign_key "user_alerts", "notifications", :name => "Ref_user_alerts_to_notifications"
  add_foreign_key "user_alerts", "users", :name => "Ref_user_alerts_to_users"

  add_foreign_key "user_borders", "interest_borders", :name => "Ref_user_borders_to_interest_borders"
  add_foreign_key "user_borders", "users", :name => "Ref_user_borders_to_users"

  add_foreign_key "user_follows", "users", :name => "Ref_user_follows_to_users", :column => "follower_id"
  add_foreign_key "user_follows", "users", :name => "Ref_user_follows_to_users0", :column => "followed_id"

  add_foreign_key "user_votes", "proposals", :name => "Ref_user_votes_to_proposals"
  add_foreign_key "user_votes", "users", :name => "Ref_user_votes_to_users"

  add_foreign_key "users", "images", :name => "Ref_users_to_images"
  add_foreign_key "users", "places", :name => "Ref_users_to_places", :column => "residenza_id"
  add_foreign_key "users", "places", :name => "Ref_users_to_places0", :column => "nascita_id"
  add_foreign_key "users", "user_types", :name => "Ref_users_to_user_types"

end
