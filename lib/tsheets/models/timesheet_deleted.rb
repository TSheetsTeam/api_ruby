class TSheets::Models::TimesheetDeleted < TSheets::Model
  field :id, :integer
  field :user_id, :integer
  field :jobcode_id, :integer
  field :start, :datetime
  field :end, :datetime
  field :date, :date
  field :duration, :integer
  field :locked, :integer
  field :notes, :string
  field :customfields, :string
  field :created, :datetime
  field :last_modified, :datetime
  field :type, :string
  
end
