class TSheets::Models::Notification < TSheets::Model
  field :id, :integer
  field :user_id, :integer
  field :msg_tracking_id, :string
  field :message, :string
  field :method, :string
  field :precheck, :string
  field :delivery_time, :datetime
  field :created, :date
  
end
