class TSheets::Models::CustomField < TSheets::Model
  field :id, :integer
  field :name, :string
  field :short_code, :string
  field :required, :boolean
  field :applies_to, :string
  field :type, :string
  field :ui_preference, :string
  field :regex_filter, :string
  field :last_modified, :datetime
  field :created, :datetime
  field :required_customfields, [ :integer ]
  
end
