class TSheets::Repos::CurrentTotals < TSheets::Repository
  url "/reports/current_totals"
  model TSheets::Models::CurrentTotals
  actions :report
  filter :user_ids, [ :integer ]
  filter :group_ids, [ :integer ]
  filter :on_the_clock, :string
  filter :page, :integer
  filter :per_page, :integer
  filter :order_by, :string
  filter :order_desc, :boolean
end
