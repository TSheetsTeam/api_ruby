class TSheets::Models::Project < TSheets::Model
  field :start_date, :date
  field :end_date, :date
  field :totals, :hash
  
end
