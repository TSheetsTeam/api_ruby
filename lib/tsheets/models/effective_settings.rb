class TSheets::Models::EffectiveSettings < TSheets::Model
  field :general, :hash
  field :time_entry, :hash
  field :invoicing, :hash
  field :alerts, :hash
  field :dialin, :hash
  field :sounds, :hash
  
end
