class TSheets::Models::JobcodeAssignment < TSheets::Model
  field :id, :integer
  field :user_id, :integer
  field :jobcode_id, :integer
  field :active, :boolean
  field :last_modified, :datetime
  field :created, :datetime
  
end
