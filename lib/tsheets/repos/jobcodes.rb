class TSheets::Repos::Jobcodes < TSheets::Repository
  url "/jobcodes"
  model TSheets::Models::Jobcode
  actions :list, :add, :edit
  filter :ids, [ :integer ]
  filter :parent_ids, [ :integer ]
  filter :type, :string
  filter :active, :string
  filter :modified_before, :datetime
  filter :modified_since, :datetime
  filter :per_page, :integer
  filter :page, :integer
end
