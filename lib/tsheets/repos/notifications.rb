class TSheets::Repos::Notifications < TSheets::Repository
  url "/notifications"
  model TSheets::Models::Notification
  actions :list, :add, :delete
  filter :ids, [ :integer ]
  filter :delivery_before, :datetime
  filter :delivery_after, :datetime
  filter :user_id, :integer
  filter :msg_tracking_id, :string
  filter :per_page, :integer
  filter :page, :integer
end
