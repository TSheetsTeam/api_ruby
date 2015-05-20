class TSheets::Models::User < TSheets::Model

  field :id, :integer

  field :first_name, :string

  field :last_name, :string

  field :group_id, :integer

  field :active, :boolean

  field :employee_number, :integer

  field :salaried, :boolean

  field :exempt, :boolean

  field :username, :string

  field :email, :string

  field :payroll_id, :integer

  field :hire_date, :date

  field :term_date, :date

  field :job_title, :string

  field :gender, :string

  field :last_modified, :datetime

  field :last_active, :datetime

  field :created, :datetime

  field :mobile_number, :string

  field :require_password_change, :boolean

  field :permissions, :user_permissions_set

end
