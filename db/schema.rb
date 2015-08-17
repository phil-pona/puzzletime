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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150702152630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: :cascade do |t|
    t.string  "name",     limit: 255,                 null: false
    t.boolean "payed",                default: false
    t.boolean "private",              default: false
    t.boolean "vacation",             default: false, null: false
    t.index ["name"], :name => "index_absences_on_name", :unique => true
  end

  create_table "accounting_posts", force: :cascade do |t|
    t.integer "work_item_id",                                                                null: false
    t.integer "portfolio_item_id"
    t.string  "reference",              limit: 255
    t.float   "offered_hours"
    t.decimal "offered_rate",                       precision: 12, scale: 2
    t.decimal "offered_total",                      precision: 12, scale: 2
    t.integer "discount_percent"
    t.integer "discount_fixed"
    t.integer "remaining_hours"
    t.boolean "billable",                                                    default: true,  null: false
    t.boolean "description_required",                                        default: false, null: false
    t.boolean "ticket_required",                                             default: false, null: false
    t.boolean "closed",                                                      default: false, null: false
    t.boolean "from_to_times_required",                                      default: false, null: false
    t.index ["portfolio_item_id"], :name => "index_accounting_posts_on_portfolio_item_id"
    t.index ["work_item_id"], :name => "index_accounting_posts_on_work_item_id"
  end

  create_table "billing_addresses", force: :cascade do |t|
    t.integer "client_id",                 null: false
    t.integer "contact_id"
    t.string  "supplement",    limit: 255
    t.string  "street",        limit: 255
    t.string  "zip_code",      limit: 255
    t.string  "town",          limit: 255
    t.string  "country",       limit: 2
    t.string  "invoicing_key"
    t.index ["client_id"], :name => "index_billing_addresses_on_client_id"
    t.index ["contact_id"], :name => "index_billing_addresses_on_contact_id"
  end

  create_table "clients", force: :cascade do |t|
    t.integer "work_item_id",                                        null: false
    t.string  "crm_key",                 limit: 255
    t.boolean "allow_local",                         default: false, null: false
    t.integer "last_invoice_number",                 default: 0
    t.string  "invoicing_key"
    t.integer "last_billing_address_id"
    t.index ["work_item_id"], :name => "index_clients_on_work_item_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "client_id",                 null: false
    t.string   "lastname",      limit: 255
    t.string   "firstname",     limit: 255
    t.string   "function",      limit: 255
    t.string   "email",         limit: 255
    t.string   "phone",         limit: 255
    t.string   "mobile",        limit: 255
    t.string   "crm_key",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invoicing_key"
    t.index ["client_id"], :name => "index_contacts_on_client_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string  "number",         limit: 255, null: false
    t.date    "start_date",                 null: false
    t.date    "end_date",                   null: false
    t.integer "payment_period",             null: false
    t.text    "reference"
    t.text    "sla"
    t.text    "notes"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.string   "cron",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], :name => "delayed_jobs_priority"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name",      limit: 255, null: false
    t.string "shortname", limit: 3,   null: false
    t.index ["name"], :name => "index_departments_on_name", :unique => true
    t.index ["shortname"], :name => "index_departments_on_shortname", :unique => true
  end

  create_table "employee_lists", force: :cascade do |t|
    t.integer  "employee_id",             null: false
    t.string   "title",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["employee_id"], :name => "index_employee_lists_on_employee_id"
  end

  create_table "employee_lists_employees", id: false, force: :cascade do |t|
    t.integer  "employee_list_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["employee_id"], :name => "index_employee_lists_employees_on_employee_id"
    t.index ["employee_list_id"], :name => "index_employee_lists_employees_on_employee_list_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string  "firstname",             limit: 255,                 null: false
    t.string  "lastname",              limit: 255,                 null: false
    t.string  "shortname",             limit: 3,                   null: false
    t.string  "passwd",                limit: 255
    t.string  "email",                 limit: 255,                 null: false
    t.boolean "management",                        default: false
    t.float   "initial_vacation_days"
    t.string  "ldapname",              limit: 255
    t.string  "eval_periods",                                                   array: true
    t.integer "department_id"
    t.index ["department_id"], :name => "index_employees_on_department_id"
    t.index ["shortname"], :name => "chk_unique_name", :unique => true
  end

  create_table "employees_invoices", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "invoice_id"
    t.index ["employee_id"], :name => "index_employees_invoices_on_employee_id"
    t.index ["invoice_id"], :name => "index_employees_invoices_on_invoice_id"
  end

  create_table "employments", force: :cascade do |t|
    t.integer "employee_id"
    t.decimal "percent",     precision: 5, scale: 2, null: false
    t.date    "start_date",                          null: false
    t.date    "end_date"
    t.index ["employee_id"], :name => "index_employments_on_employee_id"
    t.foreign_key ["employee_id"], "employees", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_employments_employees"
  end

  create_table "holidays", force: :cascade do |t|
    t.date  "holiday_date",  null: false
    t.float "musthours_day", null: false
    t.index ["holiday_date"], :name => "index_holidays_on_holiday_date", :unique => true
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "order_id",                                                   null: false
    t.date     "billing_date",                                               null: false
    t.date     "due_date",                                                   null: false
    t.decimal  "total_amount",       precision: 12, scale: 2,                null: false
    t.float    "total_hours",                                                null: false
    t.string   "reference",                                                  null: false
    t.date     "period_from",                                                null: false
    t.date     "period_to",                                                  null: false
    t.string   "status",                                                     null: false
    t.boolean  "add_vat",                                     default: true, null: false
    t.integer  "billing_address_id",                                         null: false
    t.string   "invoicing_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grouping",                                    default: 0,    null: false
    t.index ["billing_address_id"], :name => "index_invoices_on_billing_address_id"
    t.index ["order_id"], :name => "index_invoices_on_order_id"
  end

  create_table "invoices_work_items", id: false, force: :cascade do |t|
    t.integer "work_item_id"
    t.integer "invoice_id"
    t.index ["invoice_id"], :name => "index_invoices_work_items_on_invoice_id"
    t.index ["work_item_id"], :name => "index_invoices_work_items_on_work_item_id"
  end

  create_table "order_comments", force: :cascade do |t|
    t.integer  "order_id",   null: false
    t.text     "text",       null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["order_id"], :name => "index_order_comments_on_order_id"
  end

  create_table "order_contacts", primary_key: "false", :default => { :expr => "nextval('order_contacts_false_seq'::regclass)" }, force: :cascade do |t|
    t.integer "contact_id",             null: false
    t.integer "order_id",               null: false
    t.string  "comment",    limit: 255
    t.index ["contact_id"], :name => "index_order_contacts_on_contact_id"
    t.index ["order_id"], :name => "index_order_contacts_on_order_id"
  end

  create_table "order_kinds", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.index ["name"], :name => "index_order_kinds_on_name", :unique => true
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string  "name",     limit: 255,                 null: false
    t.string  "style",    limit: 255
    t.boolean "closed",               default: false, null: false
    t.integer "position",                             null: false
    t.index ["name"], :name => "index_order_statuses_on_name", :unique => true
    t.index ["position"], :name => "index_order_statuses_on_position"
  end

  create_table "order_targets", force: :cascade do |t|
    t.integer  "order_id",                                      null: false
    t.integer  "target_scope_id",                               null: false
    t.string   "rating",          limit: 255, default: "green", null: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["order_id"], :name => "index_order_targets_on_order_id"
    t.index ["target_scope_id"], :name => "index_order_targets_on_target_scope_id"
  end

  create_table "order_team_members", primary_key: "false", :default => { :expr => "nextval('order_team_members_false_seq'::regclass)" }, force: :cascade do |t|
    t.integer "employee_id",             null: false
    t.integer "order_id",                null: false
    t.string  "comment",     limit: 255
    t.index ["employee_id"], :name => "index_order_team_members_on_employee_id"
    t.index ["order_id"], :name => "index_order_team_members_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "work_item_id",                   null: false
    t.integer  "kind_id"
    t.integer  "responsible_id"
    t.integer  "status_id"
    t.integer  "department_id"
    t.integer  "contract_id"
    t.integer  "billing_address_id"
    t.string   "crm_key",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["billing_address_id"], :name => "index_orders_on_billing_address_id"
    t.index ["contract_id"], :name => "index_orders_on_contract_id"
    t.index ["department_id"], :name => "index_orders_on_department_id"
    t.index ["kind_id"], :name => "index_orders_on_kind_id"
    t.index ["responsible_id"], :name => "index_orders_on_responsible_id"
    t.index ["status_id"], :name => "index_orders_on_status_id"
    t.index ["work_item_id"], :name => "index_orders_on_work_item_id"
  end

  create_table "overtime_vacations", force: :cascade do |t|
    t.float   "hours",         null: false
    t.integer "employee_id",   null: false
    t.date    "transfer_date", null: false
    t.index ["employee_id"], :name => "index_overtime_vacations_on_employee_id"
  end

  create_table "plannings", force: :cascade do |t|
    t.integer  "employee_id",                     null: false
    t.integer  "start_week",                      null: false
    t.integer  "end_week"
    t.boolean  "definitive",      default: false, null: false
    t.text     "description"
    t.boolean  "monday_am",       default: false, null: false
    t.boolean  "monday_pm",       default: false, null: false
    t.boolean  "tuesday_am",      default: false, null: false
    t.boolean  "tuesday_pm",      default: false, null: false
    t.boolean  "wednesday_am",    default: false, null: false
    t.boolean  "wednesday_pm",    default: false, null: false
    t.boolean  "thursday_am",     default: false, null: false
    t.boolean  "thursday_pm",     default: false, null: false
    t.boolean  "friday_am",       default: false, null: false
    t.boolean  "friday_pm",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_abstract"
    t.decimal  "abstract_amount"
    t.integer  "work_item_id",                    null: false
    t.index ["employee_id"], :name => "index_plannings_on_employee_id"
    t.index ["work_item_id"], :name => "index_plannings_on_work_item_id"
  end

  create_table "portfolio_items", force: :cascade do |t|
    t.string  "name",   limit: 255,                null: false
    t.boolean "active",             default: true, null: false
    t.index ["name"], :name => "index_portfolio_items_on_name", :unique => true
  end

  create_table "target_scopes", force: :cascade do |t|
    t.string  "name",     limit: 255, null: false
    t.string  "icon",     limit: 255
    t.integer "position",             null: false
    t.index ["name"], :name => "index_target_scopes_on_name", :unique => true
    t.index ["position"], :name => "index_target_scopes_on_position"
  end

  create_table "user_notifications", force: :cascade do |t|
    t.date "date_from", null: false
    t.date "date_to"
    t.text "message",   null: false
    t.index ["date_from", "date_to"], :name => "index_user_notifications_on_date_from_and_date_to"
  end

  create_table "work_items", force: :cascade do |t|
    t.integer "parent_id"
    t.string  "name",            limit: 255,                  null: false
    t.string  "shortname",       limit: 5,                    null: false
    t.text    "description"
    t.integer "path_ids",                                                  array: true
    t.string  "path_shortnames", limit: 255
    t.string  "path_names",      limit: 2047
    t.boolean "leaf",                         default: true,  null: false
    t.boolean "closed",                       default: false, null: false
    t.index ["parent_id"], :name => "index_work_items_on_parent_id"
    t.index ["path_ids"], :name => "index_work_items_on_path_ids"
  end

  create_table "working_conditions", force: :cascade do |t|
    t.date    "valid_from"
    t.decimal "vacation_days_per_year", precision: 5, scale: 2, null: false
    t.decimal "must_hours_per_day",     precision: 4, scale: 2, null: false
  end

  create_table "worktimes", force: :cascade do |t|
    t.integer "absence_id"
    t.integer "employee_id"
    t.string  "report_type",     limit: 255,                 null: false
    t.date    "work_date",                                   null: false
    t.float   "hours"
    t.time    "from_start_time"
    t.time    "to_end_time"
    t.text    "description"
    t.boolean "billable",                    default: true
    t.boolean "booked",                      default: false
    t.string  "type",            limit: 255
    t.string  "ticket",          limit: 255
    t.integer "work_item_id"
    t.integer "invoice_id"
    t.index ["absence_id", "employee_id", "work_date"], :name => "worktimes_absences"
    t.index ["employee_id", "work_date"], :name => "worktimes_employees"
    t.index ["invoice_id"], :name => "index_worktimes_on_invoice_id"
    t.index ["work_item_id", "employee_id", "work_date"], :name => "worktimes_work_items"
    t.foreign_key ["absence_id"], "absences", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_times_absences"
    t.foreign_key ["employee_id"], "employees", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_times_employees"
  end

end
