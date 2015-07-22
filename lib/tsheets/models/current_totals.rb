class TSheets::Models::CurrentTotals < TSheets::Model
  field :user_id, :integer
  field :on_the_clock, :boolean
  field :timesheet_id, :integer
  field :jobcode_id, :integer
  field :group_id, :integer
  field :shift_seconds, :integer
  field :day_seconds, :integer
  
end
