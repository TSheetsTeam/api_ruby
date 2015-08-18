class TSheets::Models::Timesheet < TSheets::Model
  field :id, :integer, {:exclude=>[:add, :edit]}
  field :user_id, :integer
  field :jobcode_id, :integer
  field :locked, :integer, {:exclude=>[:add, :edit]}
  field :notes, :string
  field :customfields, :string
  field :created, :datetime, {:exclude=>[:add, :edit]}
  field :last_modified, :datetime, {:exclude=>[:add, :edit]}
  field :type, :string
  field :on_the_clock, :boolean, {:exclude=>[:add, :edit]}
  field :start, :datetime
  field :end, :datetime
  field :date, :date
  field :duration, :integer
  field :tz, :integer, {:exclude=>[:add, :edit]}
  field :tz_str, :string, {:exclude=>[:add, :edit]}
  field :location, :string, {:exclude=>[:add, :edit]}
  
end
