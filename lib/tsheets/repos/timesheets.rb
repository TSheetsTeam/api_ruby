  class TSheets::Repos::Timesheets < TSheets::Repository
    url "/timesheets"
    model TSheets::Models::Timesheet
    actions :list, :add, :edit, :delete
    filter :ids, [ :integer ]
    filter :start_date, :date
    filter :end_date, :date
    filter :jobcode_ids, [ :integer ]
    filter :user_ids, [ :integer ]
    filter :group_ids, [ :integer ]
    filter :on_the_clock, :boolean
    filter :jobcode_type, :string
    filter :modified_before, :datetime
    filter :modified_since, :datetime
    filter :per_page, :integer
    filter :page, :integer
  end
