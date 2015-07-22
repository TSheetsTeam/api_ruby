class TSheets::Repos::Payroll < TSheets::Repository
  url "/reports/payroll"
  model TSheets::Models::Payroll
  actions :report
  filter :start_date, :date
  filter :end_date, :date
  filter :user_ids, :integer
  filter :group_ids, :integer
  filter :include_zero_time, :string
end
