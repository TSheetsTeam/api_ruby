class TSheets::Models::User < TSheets::Model
  field :id, :integer
  field :username, :string
  field :password, :string
  field :email, :string
  field :first_name, :string
  field :last_name, :string
  field :group_id, :integer
  field :manager_of_group_ids, [ :integer ], exclude: [:add, :edit]
  field :employee_number, :integer
  field :salaried, :boolean
  field :exempt, :boolean
  field :payroll_id, :string
  field :client_url, :string
  field :mobile_number, :string
  field :hire_date, :date
  field :term_date, :date
  field :last_active, :datetime, exclude: [:add, :edit]
  field :active, :boolean
  field :require_password_change, :boolean
  field :approved_to, :date
  field :submitted_to, :date
  field :last_modified, :datetime, exclude: [:add, :edit]
  field :created, :datetime, exclude: [:add, :edit]
  field :permissions, :user_permissions_set

end
