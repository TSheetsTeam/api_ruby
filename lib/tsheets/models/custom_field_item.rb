  class TSheets::Models::CustomFieldItem < TSheets::Model
    field :id, :integer
    field :customfield_id, :integer
    field :name, :string
    field :short_code, :string
    field :active, :boolean
    field :last_modified, :datetime
    field :created, :datetime
    field :required_customfields, [ :integer ]
  end
