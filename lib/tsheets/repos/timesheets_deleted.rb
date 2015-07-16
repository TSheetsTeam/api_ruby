class TSheets::Repos::TimesheetsDeleted < TSheets::Repository
  url "/timesheets_deleted"
  model TSheets::Models::TimesheetDeleted
  actions :list
  filter :start_date, :date
  filter :end_date, :date
  filter :ids, [ :integer ]
  filter :modified_since, :datetime
  filter :modified_before, :datetime
  filter :group_ids, :string
  filter :user_ids, [ :integer ]
  filter :username, :string
  filter :jobcode_ids, [ :integer ]
  filter :jobcode_type, :string
  filter :type, :string
  filter :order_results_by, :string
  filter :order_results_reverse, :boolean
  filter :page, :integer
  filter :per_page, :integer
end
