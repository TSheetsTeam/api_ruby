  class TSheets::Repos::JobcodeAssignments < TSheets::Repository
    url "/jobcode_assignments"
    model TSheets::Models::JobcodeAssignment
    actions :list, :add, :delete
    filter :user_ids, [ :integer ]
    filter :type, :string
    filter :jobcode_parent_id, :integer
    filter :active, :string
    filter :modified_before, :datetime
    filter :modified_since, :datetime
    filter :per_page, :integer
    filter :page, :integer
  end
