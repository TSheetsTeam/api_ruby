class TSheets::Models::UserPermissionsSet < TSheets::Model
  field :admin, :boolean
  field :mobile, :boolean
  field :status_box, :boolean
  field :reports, :boolean
  field :manage_timesheets, :boolean
  field :manage_authorization, :boolean
  field :manage_users, :boolean
  field :manage_my_timesheets, :boolean
  field :manage_jobcodes, :boolean
  field :approve_timesheets, :boolean
end
