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

ActiveRecord::Schema[8.0].define(version: 2025_08_23_215344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vault_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vault_id"], name: "index_api_keys_on_vault_id"
  end

  create_table "contexts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vault_id", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "autotag", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vault_id"], name: "index_contexts_on_vault_id"
  end

  create_table "contexts_entries", id: false, force: :cascade do |t|
    t.uuid "context_id", null: false
    t.uuid "entry_id", null: false
    t.index ["context_id", "entry_id"], name: "index_contexts_entries_on_context_id_and_entry_id", unique: true
    t.index ["entry_id", "context_id"], name: "index_contexts_entries_on_entry_id_and_context_id"
  end

  create_table "emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "mailbox_id", null: false
    t.string "to", null: false
    t.string "cc"
    t.string "from", null: false
    t.string "subject"
    t.text "body", null: false
    t.datetime "received_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mailbox_id", "received_at"], name: "index_emails_on_mailbox_id_and_received_at"
    t.index ["mailbox_id"], name: "index_emails_on_mailbox_id"
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vault_id", null: false
    t.string "title"
    t.text "description"
    t.string "entriable_type", null: false
    t.uuid "entriable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entriable_type", "entriable_id"], name: "index_entries_on_entriable"
    t.index ["entriable_type", "entriable_id"], name: "index_entries_on_entriable_type_and_entriable_id"
    t.index ["vault_id", "entriable_type"], name: "index_entries_on_vault_id_and_entriable_type"
    t.index ["vault_id"], name: "index_entries_on_vault_id"
  end

  create_table "external_api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vault_id", null: false
    t.string "name", null: false
    t.string "service_key", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_key"], name: "index_external_api_keys_on_service_key", unique: true
    t.index ["vault_id"], name: "index_external_api_keys_on_vault_id"
  end

  create_table "links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vault_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vault_id"], name: "index_mailboxes_on_vault_id"
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "vault_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "vault_id"], name: "index_memberships_on_user_id_and_vault_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
    t.index ["vault_id"], name: "index_memberships_on_vault_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prompts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "context_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_id"], name: "index_prompts_on_context_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "vaults", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_keys", "vaults"
  add_foreign_key "contexts", "vaults"
  add_foreign_key "emails", "mailboxes"
  add_foreign_key "entries", "vaults"
  add_foreign_key "external_api_keys", "vaults"
  add_foreign_key "mailboxes", "vaults"
  add_foreign_key "memberships", "users"
  add_foreign_key "memberships", "vaults"
  add_foreign_key "prompts", "contexts"
end
