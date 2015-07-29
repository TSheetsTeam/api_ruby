class TSheets::Models::Reminder < TSheets::Model
  field :id, :integer
  field :user_id, :integer
  field :reminder_type, :string
  field :due_time, :string
  field :due_days_of_week, :string
  field :distribution_methods, [ :string ]
  field :active, :boolean
  field :enabled, :boolean
  field :last_modified, :datetime
  field :created, :datetime
  
end
