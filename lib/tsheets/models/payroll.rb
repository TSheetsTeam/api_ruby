class TSheets::Models::Payroll < TSheets::Model
  field :user_id, :integer
  field :client_id, :integer
  field :start_date, :date
  field :end_date, :date
  field :total_re_seconds, :integer
  field :total_ot_seconds, :integer
  field :total_dt_seconds, :integer
  field :total_pto_seconds, :integer
  field :total_work_seconds, :integer
  field :pto_seconds, :hash
  
end
