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

ActiveRecord::Schema[8.0].define(version: 2025_05_25_200200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "ai_interaction_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "session_id"
    t.text "user_query"
    t.text "ai_response"
    t.string "interaction_type"
    t.string "context_entity_type", null: false
    t.bigint "context_entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_entity_type", "context_entity_id"], name: "index_ai_interaction_logs_on_context_entity"
    t.index ["user_id"], name: "index_ai_interaction_logs_on_user_id"
  end

  create_table "ai_suggestions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "session_id"
    t.string "context_entity_type", null: false
    t.bigint "context_entity_id", null: false
    t.text "suggestion_prompt"
    t.jsonb "suggestion_content"
    t.string "suggestion_type"
    t.float "confidence_score"
    t.string "status"
    t.integer "feedback_rating"
    t.text "feedback_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_entity_type", "context_entity_id"], name: "index_ai_suggestions_on_context_entity"
    t.index ["user_id"], name: "index_ai_suggestions_on_user_id"
  end

  create_table "alert_rules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "target_entity_type"
    t.jsonb "condition"
    t.string "severity"
    t.jsonb "notification_channels"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alerts", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.bigint "pipeline_run_id", null: false
    t.bigint "pipeline_step_run_id", null: false
    t.bigint "alert_rule_id", null: false
    t.string "severity"
    t.text "message"
    t.string "status"
    t.bigint "acknowledged_by_user_id"
    t.datetime "acknowledged_at"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acknowledged_by_user_id"], name: "index_alerts_on_acknowledged_by_user_id"
    t.index ["alert_rule_id"], name: "index_alerts_on_alert_rule_id"
    t.index ["pipeline_id"], name: "index_alerts_on_pipeline_id"
    t.index ["pipeline_run_id"], name: "index_alerts_on_pipeline_run_id"
    t.index ["pipeline_step_run_id"], name: "index_alerts_on_pipeline_step_run_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action"
    t.string "entity_type", null: false
    t.bigint "entity_id", null: false
    t.jsonb "old_value"
    t.jsonb "new_value"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type", "entity_id"], name: "index_audit_logs_on_entity"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "connections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "type"
    t.jsonb "configuration"
    t.string "test_status"
    t.datetime "last_tested_at"
    t.bigint "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_connections_on_created_by_user_id"
    t.index ["name"], name: "index_connections_on_name", unique: true
  end

  create_table "dashboard_widgets", force: :cascade do |t|
    t.bigint "dashboard_id", null: false
    t.string "widget_type"
    t.string "title"
    t.jsonb "configuration"
    t.integer "refresh_interval_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_dashboard_widgets_on_dashboard_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "description"
    t.jsonb "layout_config"
    t.boolean "is_default"
    t.boolean "is_shared"
    t.jsonb "shared_with_roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "session_id"
    t.string "role"
    t.text "content"
    t.string "data_attachment_path"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alert_id", null: false
    t.string "channel"
    t.text "content"
    t.string "status"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id"], name: "index_notifications_on_alert_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "pipeline_runs", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.integer "pipeline_version_at_run"
    t.string "status"
    t.string "triggered_by_type"
    t.bigint "triggered_by_user_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "duration_ms"
    t.jsonb "parameters"
    t.jsonb "summary_metrics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_pipeline_runs_on_pipeline_id"
    t.index ["triggered_by_user_id"], name: "index_pipeline_runs_on_triggered_by_user_id"
  end

  create_table "pipeline_step_runs", force: :cascade do |t|
    t.bigint "pipeline_run_id", null: false
    t.bigint "pipeline_step_id", null: false
    t.string "status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "duration_ms"
    t.jsonb "metrics"
    t.text "logs_summary"
    t.jsonb "input_data_preview"
    t.jsonb "output_data_preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_run_id"], name: "index_pipeline_step_runs_on_pipeline_run_id"
    t.index ["pipeline_step_id"], name: "index_pipeline_step_runs_on_pipeline_step_id"
  end

  create_table "pipeline_steps", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.string "name"
    t.text "description"
    t.string "step_type"
    t.integer "sequence_order"
    t.jsonb "configuration"
    t.bigint "source_connection_id", null: false
    t.bigint "target_connection_id", null: false
    t.jsonb "expected_input_schema"
    t.jsonb "expected_output_schema"
    t.jsonb "ui_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_pipeline_steps_on_pipeline_id"
    t.index ["source_connection_id"], name: "index_pipeline_steps_on_source_connection_id"
    t.index ["target_connection_id"], name: "index_pipeline_steps_on_target_connection_id"
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "created_by_user_id", null: false
    t.bigint "project_id", null: false
    t.integer "version"
    t.string "status"
    t.jsonb "tags"
    t.jsonb "ai_assisted_design_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_pipelines_on_created_by_user_id"
    t.index ["project_id"], name: "index_pipelines_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "created_by_user_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "started_at"
    t.datetime "due_at"
    t.jsonb "tags", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_projects_on_created_by_user_id"
    t.index ["due_at"], name: "index_projects_on_due_at"
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["started_at"], name: "index_projects_on_started_at"
    t.index ["status"], name: "index_projects_on_status"
    t.index ["tags"], name: "index_projects_on_tags", using: :gin
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "run_logs", force: :cascade do |t|
    t.bigint "pipeline_run_id", null: false
    t.bigint "pipeline_step_run_id", null: false
    t.datetime "timestamp"
    t.string "level"
    t.text "message"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_run_id"], name: "index_run_logs_on_pipeline_run_id"
    t.index ["pipeline_step_run_id"], name: "index_run_logs_on_pipeline_step_run_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.string "cron_expression"
    t.string "timezone"
    t.boolean "is_active"
    t.datetime "next_run_at"
    t.bigint "last_triggered_run_id"
    t.bigint "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_schedules_on_created_by_user_id"
    t.index ["last_triggered_run_id"], name: "index_schedules_on_last_triggered_run_id"
    t.index ["pipeline_id"], name: "index_schedules_on_pipeline_id", unique: true
  end

  create_table "system_settings", force: :cascade do |t|
    t.string "setting_key"
    t.jsonb "setting_value"
    t.text "description"
    t.boolean "is_sensitive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_key"], name: "index_system_settings_on_setting_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "full_name"
    t.boolean "is_active"
    t.boolean "is_admin"
    t.string "role_type"
    t.bigint "role_id"
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 1, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["full_name"], name: "index_users_on_full_name"
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["is_admin"], name: "index_users_on_is_admin"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_type", "role_id"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_interaction_logs", "users"
  add_foreign_key "ai_suggestions", "users"
  add_foreign_key "alerts", "alert_rules"
  add_foreign_key "alerts", "pipeline_runs"
  add_foreign_key "alerts", "pipeline_step_runs"
  add_foreign_key "alerts", "pipelines"
  add_foreign_key "alerts", "users", column: "acknowledged_by_user_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "connections", "users", column: "created_by_user_id"
  add_foreign_key "dashboard_widgets", "dashboards"
  add_foreign_key "dashboards", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "alerts"
  add_foreign_key "notifications", "users"
  add_foreign_key "pipeline_runs", "pipelines"
  add_foreign_key "pipeline_runs", "users", column: "triggered_by_user_id"
  add_foreign_key "pipeline_step_runs", "pipeline_runs"
  add_foreign_key "pipeline_step_runs", "pipeline_steps"
  add_foreign_key "pipeline_steps", "connections", column: "source_connection_id"
  add_foreign_key "pipeline_steps", "connections", column: "target_connection_id"
  add_foreign_key "pipeline_steps", "pipelines"
  add_foreign_key "pipelines", "projects"
  add_foreign_key "pipelines", "users", column: "created_by_user_id"
  add_foreign_key "projects", "users", column: "created_by_user_id"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "run_logs", "pipeline_runs"
  add_foreign_key "run_logs", "pipeline_step_runs"
  add_foreign_key "schedules", "pipeline_runs", column: "last_triggered_run_id"
  add_foreign_key "schedules", "pipelines"
  add_foreign_key "schedules", "users", column: "created_by_user_id"
end
