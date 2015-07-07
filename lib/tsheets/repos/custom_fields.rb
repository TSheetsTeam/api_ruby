  class TSheets::Repos::CustomFields < TSheets::Repository
    url "/customfields"
    model TSheets::Models::CustomField
    actions :list
    filter :ids, [ :integer ]
    filter :applies_to, :string
    filter :value_type, :string
    filter :modified_before, :string
    filter :modified_since, :string
    filter :per_page, :integer
    filter :page, :integer
  end
