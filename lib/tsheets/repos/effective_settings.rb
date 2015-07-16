class TSheets::Repos::EffectiveSettings < TSheets::Repository
  url "/effective_settings"
  model TSheets::Models::EffectiveSettings, singleton: true
  actions :list
  filter :user_id, :integer
  filter :modified_before, :datetime
  filter :modified_since, :datetime
end
