class TSheets::Repos::CustomFieldItems < TSheets::Repository
  url "/customfielditems"
  model TSheets::Models::CustomFieldItem
  actions :list, :add, :edit
  filter :customfield_id, :integer
  filter :ids, [ :integer ]
  filter :active, :string
  filter :modified_before, :datetime
  filter :modified_since, :datetime
  filter :per_page, :integer
  filter :page, :integer
end
