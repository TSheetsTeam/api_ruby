  class TSheets::Models::Timesheet < TSheets::Model
    field :id, :integer
    field :user_id, :integer
    field :jobcode_id, :integer
    field :locked, :integer
    field :notes, :string
    field :customfields, :string
    field :created, :datetime
    field :last_modified, :datetime
    field :type, :string
    field :on_the_clock, :boolean
  end
