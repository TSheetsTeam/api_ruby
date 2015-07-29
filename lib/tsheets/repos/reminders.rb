class TSheets::Repos::Reminders < TSheets::Repository
  url "/reminders"
  model TSheets::Models::Reminder
  actions :list, :add, :edit
  filter :user_ids, [ :integer ]
  filter :reminder_types, [ :string ]
  filter :modified_since, :datetime
end
