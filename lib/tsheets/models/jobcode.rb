class TSheets::Models::Jobcode < TSheets::Model
  field :id, :integer
  field :parent_id, :integer
  field :name, :string
  field :short_code, :string
  field :type, :string
  field :billable, :boolean
  field :billable_rate, :float
  field :has_children, :boolean
  field :assigned_to_all, :boolean
  field :required_customfields, [ :integer ]
  field :filtered_customfielditems, :object
  field :active, :boolean
  field :last_modified, :datetime
  field :created, :datetime
  
end
