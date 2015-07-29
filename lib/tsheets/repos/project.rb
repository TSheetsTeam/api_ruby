class TSheets::Repos::Project < TSheets::Repository
  url "/reports/project"
  model TSheets::Models::Project
  actions :report
  filter :start_date, :date
  filter :end_date, :date
  filter :user_ids, [ :integer ]
  filter :group_ids, [ :integer ]
  filter :jobcode_ids, [ :integer ]
  filter :jobcode_type, :string
  filter :customfielditems, :hash
end
